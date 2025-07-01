<?php
header('Content-Type: application/json');
$pdo = new PDO("mysql:host=localhost;dbname=ta_base", "utilisateur", "motdepasse");

$stmt = $pdo->prepare("SELECT identifiant, pswd, fonction FROM users");
$stmt->execute();
$users = $stmt->fetchAll(PDO::FETCH_ASSOC);

echo json_encode($users);
?>