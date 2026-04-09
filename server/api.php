<?php
/**
 * Mannin Suvai - Products API
 * Upload this file to your Hostinger server (e.g. public_html/manninsuvai/).
 * The products.json file will be created in the same folder.
 *
 * SETUP:
 *  1. Upload api.php, send_notification.php and products.json to your server.
 *  2. Set $SECRET_KEY below to any random string (remember it — you'll need it in Admin Settings).
 *  3. In the Flutter admin panel → Settings:
 *       Read URL : https://yourdomain.com/manninsuvai/api.php
 *       Write URL: https://yourdomain.com/manninsuvai/api.php
 *       API Key  : (same secret key as below)
 *       Use JSONBin headers: OFF
 */

$SECRET_KEY  = 'CHANGE_THIS_TO_A_RANDOM_SECRET';
$DATA_FILE   = __DIR__ . '/products.json';
$TOKENS_FILE = __DIR__ . '/web_tokens.json';

// ── CORS headers (allow Flutter web & mobile) ─────────────────────────────
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, PUT, POST, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type, Authorization');

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(204);
    exit;
}

header('Content-Type: application/json; charset=UTF-8');

// ── Web push token registration (no auth — any browser can register) ──────
// Called automatically by the Flutter web app when a user opens the site.
// Tokens are stored in web_tokens.json and used by send_notification.php.
if ($_SERVER['REQUEST_METHOD'] === 'POST' && ($_GET['action'] ?? '') === 'register_token') {
    $body  = json_decode(file_get_contents('php://input'), true);
    $token = trim($body['token'] ?? '');

    if (!$token) {
        http_response_code(400);
        echo json_encode(['error' => 'token required']);
        exit;
    }

    $tokens = file_exists($TOKENS_FILE)
        ? (json_decode(file_get_contents($TOKENS_FILE), true) ?? [])
        : [];

    if (!in_array($token, $tokens, true)) {
        $tokens[] = $token;
        // Keep only the latest 2000 tokens to prevent file bloat
        if (count($tokens) > 2000) {
            $tokens = array_slice($tokens, -2000);
        }
        file_put_contents($TOKENS_FILE, json_encode($tokens));
    }

    echo json_encode(['success' => true]);
    exit;
}

// ── GET: return products ───────────────────────────────────────────────────
if ($_SERVER['REQUEST_METHOD'] === 'GET') {
    if (!file_exists($DATA_FILE)) {
        echo json_encode(['products' => []]);
        exit;
    }
    echo file_get_contents($DATA_FILE);
    exit;
}

// ── PUT / POST: save products ──────────────────────────────────────────────
if (in_array($_SERVER['REQUEST_METHOD'], ['PUT', 'POST'])) {
    // Verify secret key
    $auth = $_SERVER['HTTP_AUTHORIZATION'] ?? '';
    if ($auth !== 'Bearer ' . $SECRET_KEY) {
        http_response_code(403);
        echo json_encode(['error' => 'Unauthorized']);
        exit;
    }

    $body = file_get_contents('php://input');
    if (!$body) {
        http_response_code(400);
        echo json_encode(['error' => 'Empty body']);
        exit;
    }

    // Validate JSON
    $data = json_decode($body, true);
    if (!$data || !isset($data['products'])) {
        http_response_code(400);
        echo json_encode(['error' => 'Invalid JSON — must have a "products" key']);
        exit;
    }

    // Write to file
    file_put_contents($DATA_FILE, json_encode($data, JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE));
    echo json_encode(['success' => true, 'count' => count($data['products'])]);
    exit;
}

http_response_code(405);
echo json_encode(['error' => 'Method not allowed']);
