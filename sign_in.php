<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json");

// DB connection
$host = "localhost";
$user = "root";
$pass = "";
$db = "docuease";

$conn = new mysqli($host, $user, $pass, $db);

// Check connection
if ($conn->connect_error) {
    http_response_code(500);
    echo json_encode(["status" => "error", "message" => "Database connection failed"]);
    exit();
}

// Get POST data
$data = json_decode(file_get_contents("php://input"), true);

if (!isset($data['email']) || !isset($data['password'])) {
    http_response_code(400);
    echo json_encode(["status" => "error", "message" => "Email and password required."]);
    exit();
}

$email = $conn->real_escape_string($data['email']);
$password = $data['password'];

// Query user
$result = $conn->query("SELECT * FROM users WHERE email = '$email'");

if ($result->num_rows === 1) {
    $user = $result->fetch_assoc();

    // Verify hashed password
    if (password_verify($password, $user['password'])) {
        echo json_encode([
            "status" => "success",
            "message" => "Login successful",
            "user" => [
                "id" => $user['id'],
                "first_name" => $user['first_name'],
                "last_name" => $user['last_name'],
                "email" => $user['email']
            ]
        ]);
    } else {
        echo json_encode(["status" => "error", "message" => "Incorrect password."]);
    }
} else {
    echo json_encode(["status" => "error", "message" => "No account found with this email."]);
}
?>