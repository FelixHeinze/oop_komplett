
<?php

// JSON-Antwort für Flutter
header('Content-Type: application/json; charset=utf-8');

// Datenbankverbindung
$servername = "127.0.0.1";
$username   = "test";
$password   = "Test123";
$dbname     = "i13";

// Verbindung herstellen
$conn = new mysqli(
    $servername,
    $username,
    $password,
    $dbname
);

// Verbindung prüfen
if ($conn->connect_error) {
    http_response_code(500);

    echo json_encode([
        "error" => "Datenbankverbindung fehlgeschlagen"
    ]);

    exit;
}

// Zeichensatz festlegen
$conn->set_charset("utf8mb4");

// Daten aus der Tabelle kunde abrufen
$sql = "SELECT * FROM kunde";
$result = $conn->query($sql);

// Abfrage prüfen
if ($result === false) {
    http_response_code(500);

    echo json_encode([
        "error" => "Datenbankabfrage fehlgeschlagen"
    ]);

    $conn->close();
    exit;
}

// Ergebnisse als Array speichern
$rows = [];

while ($row = $result->fetch_assoc()) {
    $rows[] = $row;
}

// JSON an Flutter zurückgeben
echo json_encode(
    $rows,
    JSON_UNESCAPED_UNICODE
);

// Verbindung schließen
$result->free();
$conn->close();

?>
