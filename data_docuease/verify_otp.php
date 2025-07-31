<?php
header("Content-Type: application/json");

$host = "localhost";
$user = "root";
$pass = "";
$db   = "docuease";

$conn = new mysqli($host, $user, $pass, $db);

if ($conn->connect_error) {
    echo json_encode(["success" => false, "message" => "Database connection failed"]);
    exit();
}

$data = json_decode(file_get_contents("php://input"), true);

if (isset($data['email']) && isset($data['otp'])) {
    $email = $conn->real_escape_string($data['email']);
    $otp   = $conn->real_escape_string($data['otp']);

    $query = "SELECT * FROM users WHERE email = '$email' AND otp = '$otp' AND status = 'unverified'";
    $result = $conn->query($query);

    if ($result && $result->num_rows === 1) {
        $update = "UPDATE users SET otp = NULL, status = 'verified' WHERE email = '$email'";
        if ($conn->query($update) === TRUE) {
            echo json_encode(["success" => true, "message" => "OTP verified. You can now log in."]);
        } else {
            echo json_encode(["success" => false, "message" => "Failed to verify account."]);
        }
    } else {
        echo json_encode(["success" => false, "message" => "Wrong OTP. Please try again."]);
    }
} else {
    echo json_encode(["success" => false, "message" => "Missing email or OTP."]);
}

$conn->close();
