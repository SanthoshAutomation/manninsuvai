<?php
/**
 * Mannin Suvai - Products API
 * Upload this file to your web server (shared hosting / VPS).
 * The products.json file will be created in the same folder.
 *
 * SETUP:
 *  1. Upload api.php and products.json to your server.
 *  2. Set $SECRET_KEY below to any random string.
 *  3. In the Flutter admin panel → Settings:
 *       Read URL : https://yourserver.com/path/api.php
 *       Write URL: https://yourserver.com/path/api.php
 *       API Key  : (same secret key)
 *       Use JSONBin headers: OFF
 */

$SECRET_KEY = 'CHANGE_THIS_TO_A_RANDOM_SECRET';
$DATA_FILE   = __DIR__ . '/products.json';

// ── CORS headers (allow Flutter web & mobile) ─────────────────────────────
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, PUT, POST, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type, Authorization');

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(204);
    exit;
}

header('Content-Type: application/json; charset=UTF-8');

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
