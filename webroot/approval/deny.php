<?php
require_once 'auth.php';
Auth::requireAuth();

$serveruri = $_SERVER['REQUEST_URI'];
$serveruri = substr($serveruri, 0, strrpos($serveruri, '/'));

require_once '../source/MySQLi.class.php';
require_once '../source/config.php';
require_once '../source/AHAConstants.php';
$sql = new SQL(Config::$mysql);

header("Content-Type: application/json");
if($_POST["deny"] == "true") {
	if(count($_POST["imgs"]) <= 0) {
		exit('{"code":400,"msg":"No image ids received."}');
	}
	$ids = $sql->escape($_POST["imgs"]);
	$cids = "'".implode("','",$ids)."'";
	if($sql->delete("images","guid IN ({$cids})")) {
		foreach($ids as $i) {
			if(file_exists("../images/{$i}.jpg")) {
				@unlink("../images/{$i}.jpg");
			}
		}
		exit('{"code":200,"msg":"Success!"}');
	} else {
		exit('{"code":500,"msg":"Failed to remove. Try again later."}');
	}
} else {
	exit('{"code":400,"msg":"Bad Request"}');
}
?>