<?php
require 'auth.php';

// Attempt to login the user
$error = "";
if($_POST["username"] != "" && $_POST["password"] != "") {
	require '../source/MySQLi.class.php';
	require '../source/config.php';
	$sql = new SQL(Config::$mysql);

	$user = $sql->escape($_POST["username"]);
	$pw = sha1($_POST["password"]);
	$sql->select("admin","*","WHERE `username`='{$user}'");
	$row = $sql->fetch();

	if($row["username"] == $user && $row["password"] == $pw) {
		Auth::destroy();
		Auth::set(Auth::LOGGED_IN_KEY, TRUE);
		Auth::set(Auth::USERNAME, $user);

		header("Location: /approval/index.php");
	} else {
		$error = "Invalid username or password. Please try again.";
	}
}

if(!is_null($_REQUEST["logout"])) {
	Auth::destroy();
	header("Location: /approval/login.php");
}
?>
<!DOCTYPE HTML>
<html>
	<head>
		<title>Please Login</title>
	</head>
	<body>
		<?php if($error != "") { echo "<p>{$error}</p>"; } ?>
		<p>Please login to continue onto the approval page.</p>
		<form action="login.php" method="POST">
			Username: <input type="text" name="username" value="<?php echo $user; ?>"><br />
			Password: <input type="password" name="password"><br />
			<input type="submit" value="Log In">
		</form>
	</body>
</html>