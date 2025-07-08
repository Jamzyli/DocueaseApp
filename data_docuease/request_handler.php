<?php
// request_handler.php
session_start(); // Start session to access user ID if available
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *'); // Allow requests from any origin (for development)
header('Access-Control-Allow-Methods: GET, POST');
header('Access-Control-Allow-Headers: Content-Type, Authorization');

$response = ['success' => false, 'message' => ''];

// Database connection details - NASA LOOB NA NG FILE NA ITO
$host = "localhost";
$user = "root";
$pass = "";
$db = "docuease";

// Establish database connection
$conn = new mysqli($host, $user, $pass, $db);

// Check if the database connection was successful
if ($conn->connect_error) {
    $response['message'] = "Database connection failed: " . $conn->connect_error;
    echo json_encode($response);
    exit();
}

// Get the raw POST data
$json_data = file_get_contents('php://input');
$data = json_decode($json_data, true);

if ($data === null) {
    $response['message'] = 'Invalid JSON data received.';
    echo json_encode($response);
    exit;
}

// --- IMPORTANT: Replace this with your actual user ID retrieval logic ---
// For demonstration, we'll use a hardcoded user_id or one from session if exists.
// In a real application, this would come from an authenticated session or token.
$user_id = $_SESSION['id'] ?? 1; // Assuming user ID is stored in session after login. Default to 1 for testing.
if (!isset($_SESSION['id'])) {
    error_log("Warning: User ID not found in session for request submission. Using default ID: " . $user_id);
}
// --- End of IMPORTANT section ---

// Sanitize and get data from the incoming JSON
$certificate_type = $data['certificate_type'] ?? null;
$full_name = $data['full_name'] ?? null;
$address = $data['address'] ?? null;
$contact_number = $data['contact_number'] ?? null;
$email = $data['email'] ?? null;

// Handle Base64 image upload
$valid_id_base64 = $data['valid_id_base64'] ?? null;
$file_extension = $data['file_extension'] ?? 'png'; // Default to png if not provided
$valid_id_path = null;

if ($valid_id_base64) {
    $upload_dir = 'uploads/valid_ids/';
    // Create directory if it doesn't exist
    if (!is_dir($upload_dir)) {
        mkdir($upload_dir, 0777, true); // 0777 for full permissions, adjust as needed for production
    }

    // Generate a unique file name
    $file_name = uniqid('id_') . '.' . $file_extension;
    $file_path = $upload_dir . $file_name;

    // Decode and save the image
    $decoded_image = base64_decode($valid_id_base64);
    if ($decoded_image !== false) {
        if (file_put_contents($file_path, $decoded_image)) {
            $valid_id_path = $file_path; // Store the relative path in the database
        } else {
            error_log("Failed to save uploaded image to: " . $file_path);
            $response['message'] = 'Failed to save valid ID image.';
            echo json_encode($response);
            exit;
        }
    } else {
        error_log("Base64 decode failed for valid ID image.");
        $response['message'] = 'Invalid Base64 image data.';
        echo json_encode($response);
        exit;
    }
} else {
    // If no image is provided, you might want to set a default or return an error
    // For now, it will remain NULL as initialized.
    error_log("No valid ID image Base64 data received.");
}

$submitted_at = date('Y-m-d H:i:s'); // Set submission timestamp on the server
$status = 'Pending'; // Default status for new requests

// Certificate-specific fields (can be null)
$date_of_birth = $data['date_of_birth'] ?? null;
$place_of_birth = $data['place_of_birth'] ?? null;
$spouse_name = $data['spouse_name'] ?? null;
$date_of_marriage = $data['date_of_marriage'] ?? null;
$date_of_death = $data['date_of_death'] ?? null;
$place_of_death = $data['place_of_death'] ?? null;

// Validate required fields
if (empty($certificate_type) || empty($full_name) || empty($address) || empty($contact_number) || empty($email)) {
    $response['message'] = 'Missing required fields.';
    echo json_encode($response);
    exit;
}

$conn->begin_transaction();
try {
    // Prepare the INSERT statement with all columns, including user_id, valid_id_path, submitted_at, and status
    $stmt = $conn->prepare("INSERT INTO requests (
        user_id, certificate_type, full_name, address, contact_number, email, valid_id_path, submitted_at, status,
        date_of_birth, place_of_birth, 
        spouse_name, date_of_marriage,
        date_of_death, place_of_death
    ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)");

    if (!$stmt) {
        throw new Exception("Failed to prepare statement: " . $conn->error);
    }

    // Bind parameters (15 total: 'i' for user_id, then 14 's' for strings)
    $stmt->bind_param("issssssssssssss", 
        $user_id,
        $certificate_type, 
        $full_name, 
        $address, 
        $contact_number, 
        $email, 
        $valid_id_path, // Now this will contain the path if an image was uploaded
        $submitted_at, 
        $status,
        $date_of_birth, 
        $place_of_birth,
        $spouse_name, 
        $date_of_marriage,
        $date_of_death, 
        $place_of_death
    );

    if (!$stmt->execute()) {
        throw new Exception("Failed to execute statement: " . $stmt->error);
    }
    $stmt->close();
    $conn->commit();

    $response['success'] = true;
    $response['message'] = 'Request submitted successfully!';

} catch (Exception $e) {
    $conn->rollback();
    $response['message'] = 'Database error: ' . $e->getMessage();
    error_log('Error in request_handler.php: ' . $e->getMessage()); // Log detailed error
} finally {
    // Close connection only if it's open and not already closed by database.php's global scope
    if (isset($conn) && $conn->ping()) {
        $conn->close();
    }
}

echo json_encode($response);
?>
