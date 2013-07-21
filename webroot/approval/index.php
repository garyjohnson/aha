<?php
/**
 * User: hadidotj
 * Date: 7/20/13
 * Time: 2:00 AM
 */
require_once 'auth.php';
Auth::requireAuth();

require_once '../source/MySQLi.class.php';
require_once '../source/config.php';
require_once '../source/AHAConstants.php';
$sql = new SQL(Config::$mysql);

$count = $sql->select("images","*","WHERE status='".AHAConstants::STATUS_PENDING."' LIMIT 0,50");
$images = $sql->fetchAll(MYSQLI_ASSOC);
$serveruri = $_SERVER['REQUEST_URI'];
$serveruri = substr($serveruri, 0, strrpos($serveruri, '/'));
?>
<!DOCTYPE HTML>
<html>
	<head>
		<title>Image Approval</title>
		<link href="<?php echo $serveruri; ?>/approval.css" rel="stylesheet" type="text/css" />
		<script src="<?php echo $serveruri; ?>/../source/jquery-1.10.2.min.js"></script>
		<script src="<?php echo $serveruri; ?>/approval.js"></script>
	</head>
	<body>
		<div id="menu">
			<div class="button" id="approveButton">Approve All (<span id="pendingCount"><?php echo $count; ?></span>)</div>
			<div class="right"><a href="<?php echo $serveruri; ?>/login.php?logout">Logout</a></div>
			<div class="button" id="denyButton">Deny Selected</div>
		</div>
		<div id="imageList">
<?
foreach($images as $i) {
	echo "<img src='$serveruri/../images/{$i["guid"]}' width='150' height='150' class='images noselect' id='{$i["guid"]}' />";
}
?>
		</div>
	</body>
</html>
