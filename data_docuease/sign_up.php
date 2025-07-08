<?php
header("Content-Type: application/json");


// DB connection setup
$host = "localhost"; // or use 192.168.137.1 if Flutter is on another device
$user = "root";
$pass = ""; // default XAMPP password
$db = "docuease"; // change this

$conn = new mysqli($host, $user, $pass, $db);

if ($conn->connect_error) {
    echo json_encode(["success" => false, "message" => "Database connection failed"]);
    exit();
}

// Get JSON input from Flutter
$data = json_decode(file_get_contents("php://input"), true);

// Validate input
if (
    isset($data['first_name']) &&
    isset($data['last_name']) &&
    isset($data['address']) &&
    isset($data['contact_no']) &&
    isset($data['email']) &&
    isset($data['password'])
) {
    $first_name = $conn->real_escape_string($data['first_name']);
    $last_name = $conn->real_escape_string($data['last_name']);
    $address = $conn->real_escape_string($data['address']);
    $contact_no = $conn->real_escape_string($data['contact_no']);
    $email = $conn->real_escape_string($data['email']);
    $password = password_hash($data['password'], PASSWORD_DEFAULT);

    $sql = "INSERT INTO users (first_name, last_name, address, contact_no, email, password)
            VALUES ('$first_name', '$last_name', '$address', '$contact_no', '$email', '$password')";

    if ($conn->query($sql) === TRUE) {
        echo json_encode(["success" => true]);
    } else {
        echo json_encode(["success" => false, "message" => "Insert failed: " . $conn->error]);
    }
} else {
    echo json_encode(["success" => false, "message" => "Missing required fields"]);
}

$conn->close();
?>
