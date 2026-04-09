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

$SECRET_KEY   = 'CHANGE_THIS_TO_A_RANDOM_SECRET';
$DATA_FILE    = __DIR__ . '/products.json';
$TOKENS_FILE  = __DIR__ . '/web_tokens.json';
$STATS_FILE   = __DIR__ . '/stats.json';
$ORDERS_FILE  = __DIR__ . '/orders.json';
$VIEWS_FILE   = __DIR__ . '/views.json';

// ── CORS headers (allow Flutter web & mobile) ─────────────────────────────
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, PUT, POST, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type, Authorization');

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(204);
    exit;
}

header('Content-Type: application/json; charset=UTF-8');

// ── Visit ping (no auth — called by Flutter web app on every startup) ────────
// Increments today's visit count and total visit count in stats.json.
if ($_SERVER['REQUEST_METHOD'] === 'POST' && ($_GET['action'] ?? '') === 'ping') {
    $today = date('Y-m-d');
    $stats = file_exists($STATS_FILE)
        ? (json_decode(file_get_contents($STATS_FILE), true) ?? [])
        : [];

    // Reset daily counter if the date has changed
    if (($stats['today_date'] ?? '') !== $today) {
        $stats['today_date']  = $today;
        $stats['today_visits'] = 0;
    }

    $stats['today_visits'] = ($stats['today_visits'] ?? 0) + 1;
    $stats['total_visits']  = ($stats['total_visits']  ?? 0) + 1;

    file_put_contents($STATS_FILE, json_encode($stats));
    echo json_encode(['success' => true]);
    exit;
}

// ── Stats (admin only — requires Authorization header) ────────────────────────
// Returns web visit counts + notification subscriber count.
if ($_SERVER['REQUEST_METHOD'] === 'GET' && ($_GET['action'] ?? '') === 'stats') {
    $auth = $_SERVER['HTTP_AUTHORIZATION'] ?? '';
    if ($auth !== 'Bearer ' . $SECRET_KEY) {
        http_response_code(403);
        echo json_encode(['error' => 'Unauthorized']);
        exit;
    }

    $stats = file_exists($STATS_FILE)
        ? (json_decode(file_get_contents($STATS_FILE), true) ?? [])
        : [];

    $today = date('Y-m-d');
    $todayVisits = ($stats['today_date'] ?? '') === $today
        ? ($stats['today_visits'] ?? 0)
        : 0;

    $tokens = file_exists($TOKENS_FILE)
        ? (json_decode(file_get_contents($TOKENS_FILE), true) ?? [])
        : [];

    echo json_encode([
        'web_visits_today'        => $todayVisits,
        'web_visits_total'        => $stats['total_visits'] ?? 0,
        'notification_subscribers' => count($tokens),
    ]);
    exit;
}

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

// ── Track product view (no auth) ─────────────────────────────────────────────
if ($_SERVER['REQUEST_METHOD'] === 'POST' && ($_GET['action'] ?? '') === 'track_view') {
    $body      = json_decode(file_get_contents('php://input'), true);
    $productId = trim($body['productId'] ?? '');
    if ($productId) {
        $views = file_exists($VIEWS_FILE)
            ? (json_decode(file_get_contents($VIEWS_FILE), true) ?? [])
            : [];
        $views[$productId] = ($views[$productId] ?? 0) + 1;
        file_put_contents($VIEWS_FILE, json_encode($views));
    }
    echo json_encode(['success' => true]);
    exit;
}

// ── Get top-viewed products (admin only) ──────────────────────────────────────
if ($_SERVER['REQUEST_METHOD'] === 'GET' && ($_GET['action'] ?? '') === 'top_views') {
    $auth = $_SERVER['HTTP_AUTHORIZATION'] ?? '';
    if ($auth !== 'Bearer ' . $SECRET_KEY) {
        http_response_code(403);
        echo json_encode(['error' => 'Unauthorized']);
        exit;
    }
    $views = file_exists($VIEWS_FILE)
        ? (json_decode(file_get_contents($VIEWS_FILE), true) ?? [])
        : [];
    arsort($views);
    echo json_encode(array_slice($views, 0, 10, true));
    exit;
}

// ── Save order (no auth — called by Flutter on checkout) ──────────────────────
if ($_SERVER['REQUEST_METHOD'] === 'POST' && ($_GET['action'] ?? '') === 'save_order') {
    $body  = json_decode(file_get_contents('php://input'), true);
    if (!$body || empty($body['items'])) {
        http_response_code(400);
        echo json_encode(['error' => 'Invalid order data']);
        exit;
    }

    $orders = file_exists($ORDERS_FILE)
        ? (json_decode(file_get_contents($ORDERS_FILE), true) ?? [])
        : [];

    $body['savedAt'] = date('c'); // server timestamp
    array_unshift($orders, $body); // newest first

    // Keep last 500 orders
    if (count($orders) > 500) {
        $orders = array_slice($orders, 0, 500);
    }

    file_put_contents($ORDERS_FILE, json_encode($orders, JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE));
    echo json_encode(['success' => true]);
    exit;
}

// ── Get orders (admin only) ───────────────────────────────────────────────────
if ($_SERVER['REQUEST_METHOD'] === 'GET' && ($_GET['action'] ?? '') === 'get_orders') {
    $auth = $_SERVER['HTTP_AUTHORIZATION'] ?? '';
    if ($auth !== 'Bearer ' . $SECRET_KEY) {
        http_response_code(403);
        echo json_encode(['error' => 'Unauthorized']);
        exit;
    }
    $limit  = min((int) ($_GET['limit'] ?? 50), 200);
    $orders = file_exists($ORDERS_FILE)
        ? (json_decode(file_get_contents($ORDERS_FILE), true) ?? [])
        : [];
    echo json_encode(array_slice($orders, 0, $limit));
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
