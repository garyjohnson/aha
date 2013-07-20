<?php
require 'auth.php';
Auth::requireAuth();

require '../source/MySQLi.class.php';
require '../source/config.php';
$sql = new SQL(Config::$mysql);
?>
