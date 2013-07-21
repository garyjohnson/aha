<?php
require_once 'auth.php';
Auth::requireAuth();

require_once '../source/MySQLi.class.php';
require_once '../source/config.php';
require_once '../source/AHAConstants.php';
$sql = new SQL(Config::$mysql);

header("Content-Type: application/json");
if($_POST["approve"] == "true") {
	if(count($_POST["imgs"]) <= 0) {
		exit('{"code":400,"msg":"No image ids received."}');
	}
	$ids = $sql->escape($_POST["imgs"]);
	$cids = "'".implode("','",$ids)."'";
	if($sql->update("images","status=1","WHERE guid IN ({$cids})")) {
		exit('{"code":200,"msg":"Success!"}');
	} else {
		exit('{"code":500,"msg":"Failed to remove. Try again later."}');
	}
} else {
	exit('{"code":400,"msg":"Bad Request"}');
}
?>