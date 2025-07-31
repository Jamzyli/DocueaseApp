<?php
session_start();
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST');
header('Access-Control-Allow-Headers: Content-Type, Authorization');

date_default_timezone_set('Asia/Manila');

$response = ['success' => false, 'message' => ''];

/* ── 1. DB connection ───────────────────────────────────────────── */
$conn = new mysqli('localhost', 'root', '', 'docuease');
if ($conn->connect_error) {
    $response['message'] = 'Database connection failed: ' . $conn->connect_error;
    echo json_encode($response);
    exit;
}

/* ── 2. Read JSON payload ───────────────────────────────────────── */
$data = json_decode(file_get_contents('php://input'), true);
if ($data === null) {
    $response['message'] = 'Invalid JSON data received.';
    echo json_encode($response);
    exit;
}

/* ── 3. Required fields ─────────────────────────────────────────── */
$certificate_type = $data['certificate_type'] ?? null;
$full_name        = $data['full_name']        ?? null;
$address          = $data['address']          ?? null;
$contact_number   = $data['contact_number']   ?? null;
$email            = $data['email']            ?? null;

// Normalize certificate_type by removing the word "certificate" and trimming whitespace
if ($certificate_type !== null) {
    $certificate_type = strtolower($certificate_type);
    $certificate_type = str_replace('certificate', '', $certificate_type);
    $certificate_type = trim($certificate_type);
}

// Validate certificate_type allowed values
$allowed_types = ['birth', 'marriage', 'death'];

if (empty($certificate_type) || empty($full_name) || empty($address) ||
    empty($contact_number)   || empty($email)) {
    $response['message'] = 'Missing required fields.';
    echo json_encode($response);
    exit;
}

if (!in_array($certificate_type, $allowed_types)) {
    $response['message'] = 'Invalid certificate_type. Allowed values are: birth, marriage, death.';
    echo json_encode($response);
    exit;
}

/* ── 4. Enforce limit: max 2 requests per e‑mail per day ────────── */
$limitPerDay = 2;
$checkSql = "SELECT COUNT(*) AS today_total
             FROM requests
             WHERE email = ? AND DATE(submitted_at) = CURDATE()";
$checkStmt = $conn->prepare($checkSql);
$checkStmt->bind_param('s', $email);
$checkStmt->execute();
$todayTotal = $checkStmt->get_result()->fetch_assoc()['today_total'] ?? 0;
$checkStmt->close();

if ($todayTotal >= $limitPerDay) {
    $response['message'] = 'Limit reached: only 2 requests per day are allowed for this e‑mail.';
    echo json_encode($response);
    exit;
}

/* ── 5. Resolve user_id from e‑mail (or from session) ───────────── */
$user_id = $_SESSION['id'] ?? null;            // prefer active session
if ($user_id === null) {
    $findUser = $conn->prepare("SELECT id FROM users WHERE email = ? LIMIT 1");
    $findUser->bind_param('s', $email);
    $findUser->execute();
    $result = $findUser->get_result()->fetch_assoc();
    $findUser->close();

    if ($result) {
        $user_id = (int) $result['id'];
    } else {
        $response['message'] = 'No user account matched this e‑mail. Please sign in again.';
        echo json_encode($response);
        exit;
    }
}

/* ── 6. Save the uploaded valid‑ID image ───────────────────────── */
$valid_id_base64 = $data['valid_id_base64'] ?? null;
$file_extension  = $data['file_extension']  ?? 'png';
$valid_id_path   = null;

if ($valid_id_base64) {
    $upload_dir = 'uploads/valid_ids/';
    if (!is_dir($upload_dir)) mkdir($upload_dir, 0777, true);

    $file_name = uniqid('id_') . '.' . preg_replace('/[^a-zA-Z0-9]/', '', $file_extension);
    $file_path = $upload_dir . $file_name;

    $decoded_image = base64_decode($valid_id_base64);
    if ($decoded_image === false || file_put_contents($file_path, $decoded_image) === false) {
        $response['message'] = 'Failed to save valid‑ID image.';
        echo json_encode($response);
        exit;
    }
    $valid_id_path = $file_path;
} else {
    $response['message'] = 'Valid‑ID image is required.';
    echo json_encode($response);
    exit;
}

/* ── 7. Optional certificate‑specific fields ───────────────────── */
$date_of_birth    = $data['date_of_birth']    ?? null;
$place_of_birth   = $data['place_of_birth']   ?? null;
$spouse_name      = $data['spouse_name']      ?? null;
$date_of_marriage = $data['date_of_marriage'] ?? null;
$date_of_death    = $data['date_of_death']    ?? null;
$place_of_death   = $data['place_of_death']   ?? null;

$submitted_at = date('Y-m-d H:i:s');
$status       = 'Pending';

/* ── 8. Insert the request in a transaction ────────────────────── */
$conn->begin_transaction();
try {
    $stmt = $conn->prepare(
        "INSERT INTO requests (
            user_id, certificate_type, full_name, address, contact_number, email,
            valid_id_path, submitted_at, status,
            date_of_birth, place_of_birth,
            spouse_name, date_of_marriage,
            date_of_death, place_of_death
        ) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"
    );
    if (!$stmt) throw new Exception('Prepare failed: ' . $conn->error);

    $stmt->bind_param(
        'issssssssssssss',
        $user_id,
        $certificate_type,
        $full_name,
        $address,
        $contact_number,
        $email,
        $valid_id_path,
        $submitted_at,
        $status,
        $date_of_birth,
        $place_of_birth,
        $spouse_name,
        $date_of_marriage,
        $date_of_death,
        $place_of_death
    );

    if (!$stmt->execute()) throw new Exception('Execute failed: ' . $stmt->error);

    $conn->commit();
    $response['success'] = true;
    $response['message'] = 'Request submitted successfully!';
} catch (Exception $e) {
    $conn->rollback();
    $response['message'] = 'Database error: ' . $e->getMessage();
    error_log('Error in request_handler.php: ' . $e->getMessage());
}
$conn->close();

echo json_encode($response);
?>
