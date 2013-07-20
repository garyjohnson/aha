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

$count = $sql->select("images","*","WHERE status='".AHAConstants::STATUS_PENDING."'");
$images = $sql->fetchAll(MYSQLI_ASSOC);
?>
<!DOCTYPE HTML>
<html>
	<head>
		<title>Image Approval</title>
	</head>
	<body>
		<div>There are <?php echo $count; ?> pending images. <a href="/approval/login.php?logout">Logout</a></div>
<?
foreach($images as $i) {
	echo "<img src='/images/{$i["guid"]}_{$i["device"]}.jpg' />";
}
?>
	</body>
</html>
