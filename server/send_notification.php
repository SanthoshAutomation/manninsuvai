<?php
/**
 * Mannin Suvai - FCM Push Notification Sender
 *
 * Upload this file alongside api.php on your Hostinger server.
 * Also upload your Firebase service account JSON as firebase-service-account.json
 * to the same folder.
 *
 * HOW TO GET firebase-service-account.json:
 *  1. Go to https://console.firebase.google.com
 *  2. Open your project → Project Settings (gear icon)
 *  3. Click the "Service accounts" tab
 *  4. Click "Generate new private key" → confirm → download the JSON file
 *  5. Rename the downloaded file to: firebase-service-account.json
 *  6. Upload it to the same folder as this file on Hostinger
 *
 * IMPORTANT: Keep firebase-service-account.json private.
 * Never share it or commit it to Git.
 *
 * HOW IT WORKS:
 *  - Flutter app subscribes all users to FCM topic "manninsuvai_updates"
 *  - Admin panel POSTs a notification title + body to this script
 *  - This script uses the service account to call Google's FCM v1 API
 *  - FCM delivers the notification to all subscribed devices
 *  - No individual device tokens are stored anywhere
 */

$SECRET_KEY          = 'CHANGE_THIS_TO_A_RANDOM_SECRET'; // Must match $SECRET_KEY in api.php
$SERVICE_ACCOUNT_FILE = __DIR__ . '/firebase-service-account.json';
$FCM_TOPIC           = 'manninsuvai_updates';

// ── CORS headers ──────────────────────────────────────────────────────────────
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type, Authorization');

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(204);
    exit;
}

header('Content-Type: application/json; charset=UTF-8');

// ── Method check ──────────────────────────────────────────────────────────────
if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    http_response_code(405);
    echo json_encode(['error' => 'Method not allowed']);
    exit;
}

// ── Auth check ────────────────────────────────────────────────────────────────
$auth = $_SERVER['HTTP_AUTHORIZATION'] ?? '';
if ($auth !== 'Bearer ' . $SECRET_KEY) {
    http_response_code(403);
    echo json_encode(['error' => 'Unauthorized']);
    exit;
}

// ── Parse notification payload ────────────────────────────────────────────────
$body    = json_decode(file_get_contents('php://input'), true);
$title   = trim($body['title'] ?? '');
$message = trim($body['body'] ?? '');
$imageUrl = trim($body['imageUrl'] ?? '');

if (!$title || !$message) {
    http_response_code(400);
    echo json_encode(['error' => '"title" and "body" are required']);
    exit;
}

// ── Load service account ──────────────────────────────────────────────────────
if (!file_exists($SERVICE_ACCOUNT_FILE)) {
    http_response_code(500);
    echo json_encode([
        'error' => 'firebase-service-account.json not found. '
                 . 'Upload it to the same folder as this file on Hostinger.'
    ]);
    exit;
}

$sa = json_decode(file_get_contents($SERVICE_ACCOUNT_FILE), true);
if (!$sa || !isset($sa['project_id'], $sa['client_email'], $sa['private_key'])) {
    http_response_code(500);
    echo json_encode(['error' => 'Invalid firebase-service-account.json']);
    exit;
}

// ── Get OAuth2 access token via JWT ──────────────────────────────────────────
function getGoogleAccessToken(array $sa): ?string
{
    $now = time();

    $b64u = fn($data) => rtrim(strtr(base64_encode($data), '+/', '-_'), '=');

    $header  = $b64u(json_encode(['alg' => 'RS256', 'typ' => 'JWT']));
    $payload = $b64u(json_encode([
        'iss'   => $sa['client_email'],
        'sub'   => $sa['client_email'],
        'aud'   => 'https://oauth2.googleapis.com/token',
        'iat'   => $now,
        'exp'   => $now + 3600,
        'scope' => 'https://www.googleapis.com/auth/firebase.messaging',
    ]));

    $sigInput = $header . '.' . $payload;
    $sig      = '';
    if (!openssl_sign($sigInput, $sig, $sa['private_key'], OPENSSL_ALGO_SHA256)) {
        return null;
    }
    $jwt = $sigInput . '.' . $b64u($sig);

    $ch = curl_init('https://oauth2.googleapis.com/token');
    curl_setopt_array($ch, [
        CURLOPT_POST           => true,
        CURLOPT_POSTFIELDS     => http_build_query([
            'grant_type' => 'urn:ietf:params:oauth:grant-type:jwt-bearer',
            'assertion'  => $jwt,
        ]),
        CURLOPT_RETURNTRANSFER => true,
        CURLOPT_TIMEOUT        => 15,
    ]);
    $resp = curl_exec($ch);
    curl_close($ch);

    $data = json_decode($resp, true);
    return $data['access_token'] ?? null;
}

$accessToken = getGoogleAccessToken($sa);
if (!$accessToken) {
    http_response_code(500);
    echo json_encode([
        'error' => 'Could not get Google access token. '
                 . 'Check that firebase-service-account.json is valid.'
    ]);
    exit;
}

// ── Build FCM v1 message ──────────────────────────────────────────────────────
$notification = ['title' => $title, 'body' => $message];
if ($imageUrl !== '') {
    $notification['image'] = $imageUrl;
}

$fcmPayload = [
    'message' => [
        'topic'        => $FCM_TOPIC,
        'notification' => $notification,
        'android'      => ['priority' => 'high'],
    ],
];

// ── Send via FCM v1 API ───────────────────────────────────────────────────────
$projectId = $sa['project_id'];
$ch = curl_init("https://fcm.googleapis.com/v1/projects/{$projectId}/messages:send");
curl_setopt_array($ch, [
    CURLOPT_POST           => true,
    CURLOPT_POSTFIELDS     => json_encode($fcmPayload),
    CURLOPT_RETURNTRANSFER => true,
    CURLOPT_TIMEOUT        => 20,
    CURLOPT_HTTPHEADER     => [
        'Authorization: Bearer ' . $accessToken,
        'Content-Type: application/json',
    ],
]);
$result   = curl_exec($ch);
$httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
curl_close($ch);

$resultData = json_decode($result, true);

if ($httpCode === 200) {
    echo json_encode(['success' => true, 'message_id' => $resultData['name'] ?? '']);
} else {
    http_response_code(500);
    echo json_encode([
        'error'   => 'FCM API returned error',
        'code'    => $httpCode,
        'details' => $resultData,
    ]);
}
