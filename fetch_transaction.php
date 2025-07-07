<?php
header("Content-Type: application/json");

$conn = new mysqli("localhost", "root", "", "docuease");

if ($conn->connect_error) {
    echo json_encode([]);
    exit();
}

$sql = "SELECT id as transaction_id, certificate_type, full_name, submitted_at AS request_date, status FROM requests ORDER BY submitted_at DESC";
$result = $conn->query($sql);

$transactions = [];

while ($row = $result->fetch_assoc()) {
    $transactions[] = $row;
}

echo json_encode($transactions);
$conn->close();
?>
