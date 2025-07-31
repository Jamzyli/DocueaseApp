<?php
header("Content-Type: application/json");
require 'vendor/autoload.php'; // PHPMailer + phpdotenv

use PHPMailer\PHPMailer\PHPMailer;
use PHPMailer\PHPMailer\Exception;

// Load environment variables
$dotenv = Dotenv\Dotenv::createImmutable(__DIR__);
$dotenv->load();

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

if (!$data) {
    echo json_encode(["success" => false, "message" => "Invalid or no JSON input"]);
    exit();
}

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
    $otp = rand(100000, 999999);

    $check = $conn->query("SELECT id FROM users WHERE email = '$email'");
    if ($check && $check->num_rows > 0) {
        echo json_encode(["success" => false, "message" => "Email already exists."]);
        exit();
    }

    $sql = "INSERT INTO users (first_name, last_name, address, contact_no, email, password, otp, status)
            VALUES ('$first_name', '$last_name', '$address', '$contact_no', '$email', '$password', '$otp', 'unverified')";

    if ($conn->query($sql) === TRUE) {
        $mail = new PHPMailer(true);

        try {
            $mail->isSMTP();
            $mail->Host       = 'smtp.gmail.com';
            $mail->SMTPAuth   = true;
            $mail->Username   = $_ENV['GMAIL_USERNAME']; 
            $mail->Password   = $_ENV['GMAIL_PASSWORD']; 
            $mail->SMTPSecure = 'tls';
            $mail->Port       = 587;

            $mail->setFrom($_ENV['GMAIL_USERNAME'], 'DocuEase');
            $mail->addAddress($email, $first_name);

            $mail->isHTML(true);
            $mail->Subject = 'Your DocuEase OTP Verification Code';
            $mail->Body    = "
                <p>Hi <strong>$first_name</strong>,</p>
                <p>Your OTP code is: <strong style='font-size: 24px;'>$otp</strong></p>
                <p>Please enter this code to activate your account.</p>
            ";

            $mail->SMTPOptions = [
                'ssl' => [
                    'verify_peer' => false,
                    'verify_peer_name' => false,
                    'allow_self_signed' => true
                ]
            ];

            $mail->send();
            echo json_encode(["success" => true, "message" => "Registration successful. OTP sent to email."]);
        } catch (Exception $e) {
            echo json_encode(["success" => false, "message" => "Email failed to send: {$mail->ErrorInfo}"]);
        }
    } else {
        echo json_encode(["success" => false, "message" => "Insert failed: " . $conn->error]);
    }
} else {
    echo json_encode(["success" => false, "message" => "Missing required fields"]);
}

$conn->close();
