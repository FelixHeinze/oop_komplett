
<?php
//api php datei liegt auf xampp in htdocs 
header('Content-Type: application/json');
//Flutter app -->  PHP API <-- DB
$servername = "10.0.2.2"; // Adresse von server
//neuer nutzer angelegt für ke
$username = "test";
$password = "Test123";
$dbname = "i13";

// Create connection
$conn = new mysqli($servername, $username, $password, $dbname);

// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

$sql = "SELECT * FROM kunde";
$result = $conn->query($sql);

if ($result->num_rows > 0) {
    $rows = array();
    while($r = mysqli_fetch_assoc($result)) {
        $rows[] = $r;
    }
    print json_encode($rows);
} else {
    echo "0 results";
}
$conn->close();
?>