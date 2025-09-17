<?php
// ============================
// SIRENHub Config
// ============================

// Database credentials
$servername = "localhost";
$username   = "sirr4915_hub";
$password   = "sirr4915_hub";
$dbname     = "sirr4915_hub";

// Aktifkan laporan error mysqli (untuk debugging, bisa dimatikan di production)
mysqli_report(MYSQLI_REPORT_ERROR | MYSQLI_REPORT_STRICT);

try {
    $conn = new mysqli($servername, $username, $password, $dbname);
    $conn->set_charset("utf8"); // pastikan encoding UTF-8
} catch (mysqli_sql_exception $e) {
    die("DB connection failed: " . $e->getMessage());
}

// ============================
// Discord / Other settings
// ============================

define('DISCORD_LINK', 'https://discord.gg/yourserver'); // ganti dengan link Discord resmi
?>
