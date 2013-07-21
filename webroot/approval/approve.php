<?php
require_once 'auth.php';
Auth::requireAuth();

require_once '../source/MySQLi.class.php';
require_once '../source/config.php';
require_once '../source/AHAConstants.php';
$sql = new SQL(Config::$mysql);

header("Content-Type: text/json");

?>