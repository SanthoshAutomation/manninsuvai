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
 *  6. Upload it to the same folder as this file on Hostinger (NOT public_html root)
 *
 * IMPORTANT: Keep firebase-service-account.json private.
 * Never share it publicly or commit it to Git.
 *
 * HOW IT WORKS:
 *  - Android app users: subscribed to FCM topic "manninsuvai_updates" — one message reaches all
 *  - Chrome web users: their push tokens are stored in web_tokens.json (via api.php)
 *    This script sends individually to each web token
 *  - Admin panel POSTs { title, body, imageUrl? } to this script
 *  - This script calls FCM v1 API using the service account private key
 *  - FCM delivers to all Android + web users
 */

$SECRET_KEY           = 'CHANGE_THIS_TO_A_RANDOM_SECRET'; // Must match $SECRET_KEY in api.php
$SERVICE_ACCOUNT_FILE = __DIR__ . '/firebase-service-account.json';
$TOKENS_FILE          = __DIR__ . '/web_tokens.json';
$FCM_TOPIC            = 'manninsuvai_updates';

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
$body     = json_decode(file_get_contents('php://input'), true);
$title    = trim($body['title']    ?? '');
$message  = trim($body['body']     ?? '');
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
                 . 'Upload it to the same folder as this file on Hostinger.',
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
    $now  = time();
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

    $sigInput = "$header.$payload";
    $sig      = '';
    if (!openssl_sign($sigInput, $sig, $sa['private_key'], OPENSSL_ALGO_SHA256)) {
        return null;
    }

    $ch = curl_init('https://oauth2.googleapis.com/token');
    curl_setopt_array($ch, [
        CURLOPT_POST           => true,
        CURLOPT_POSTFIELDS     => http_build_query([
            'grant_type' => 'urn:ietf:params:oauth:grant-type:jwt-bearer',
            'assertion'  => "$sigInput.{$b64u($sig)}",
        ]),
        CURLOPT_RETURNTRANSFER => true,
        CURLOPT_TIMEOUT        => 15,
    ]);
    $resp = curl_exec($ch);
    curl_close($ch);

    return json_decode($resp, true)['access_token'] ?? null;
}

$accessToken = getGoogleAccessToken($sa);
if (!$accessToken) {
    http_response_code(500);
    echo json_encode([
        'error' => 'Could not get Google access token. '
                 . 'Check that firebase-service-account.json is valid.',
    ]);
    exit;
}

// ── FCM v1: send one message to a token or topic ──────────────────────────────
function sendFcmMessage(array $message, string $projectId, string $accessToken): int
{
    $ch = curl_init("https://fcm.googleapis.com/v1/projects/{$projectId}/messages:send");
    curl_setopt_array($ch, [
        CURLOPT_POST           => true,
        CURLOPT_POSTFIELDS     => json_encode(['message' => $message]),
        CURLOPT_RETURNTRANSFER => true,
        CURLOPT_TIMEOUT        => 15,
        CURLOPT_HTTPHEADER     => [
            'Authorization: Bearer ' . $accessToken,
            'Content-Type: application/json',
        ],
    ]);
    curl_exec($ch);
    $code = (int) curl_getinfo($ch, CURLINFO_HTTP_CODE);
    curl_close($ch);
    return $code;
}

// ── Build the base notification object ───────────────────────────────────────
$notification = ['title' => $title, 'body' => $message];
if ($imageUrl !== '') {
    $notification['image'] = $imageUrl;
}

$projectId      = $sa['project_id'];
$androidDelivered = false;
$webDelivered   = 0;
$webFailed      = 0;

// ── 1. Send to FCM topic → reaches all Android users ─────────────────────────
$topicMessage = [
    'topic'        => $FCM_TOPIC,
    'notification' => $notification,
    'android'      => ['priority' => 'high'],
];
$topicCode = sendFcmMessage($topicMessage, $projectId, $accessToken);
$androidDelivered = ($topicCode === 200);

// ── 2. Send to each web token → reaches Chrome users ─────────────────────────
if (file_exists($TOKENS_FILE)) {
    $webTokens = json_decode(file_get_contents($TOKENS_FILE), true) ?? [];

    foreach ($webTokens as $token) {
        $tokenMessage = [
            'token'        => $token,
            'notification' => $notification,
            'webpush'      => [
                'notification' => [
                    'icon'  => '/favicon.png',
                    'badge' => '/favicon.png',
                ],
            ],
        ];
        $code = sendFcmMessage($tokenMessage, $projectId, $accessToken);
        if ($code === 200) {
            $webDelivered++;
        } else {
            $webFailed++;
        }
    }
}

// ── Respond ───────────────────────────────────────────────────────────────────
if (!$androidDelivered && $webDelivered === 0) {
    http_response_code(500);
    echo json_encode([
        'error'          => 'Notification delivery failed',
        'android_ok'     => $androidDelivered,
        'web_delivered'  => $webDelivered,
        'web_failed'     => $webFailed,
    ]);
    exit;
}

echo json_encode([
    'success'        => true,
    'android_topic'  => $androidDelivered,
    'web_delivered'  => $webDelivered,
    'web_failed'     => $webFailed,
]);
