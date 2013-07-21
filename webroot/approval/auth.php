<?php
/**
 * Small tooltip manager
 * User: hadidotj
 * Date: 7/20/13
 * Time: 2:00 AM
 */
class Auth {
	const SESSION_KEY = "ahathisisawesome";
	const LOGGED_IN_KEY = "loggedIn";
	const USERNAME = "username";

	public static function init() {
		if(!headers_sent())
			session_start();
	}

	public static function requireAuth() {
		if(Auth::get(Auth::LOGGED_IN_KEY) !== TRUE || Auth::get(Auth::USERNAME) == "") {
			$serveruri = $_SERVER['REQUEST_URI'];
			$serveruri = substr($serveruri, 0, strrpos($serveruri, '/'));

			if($_SERVER['HTTP_X_REQUESTED_WITH'] == 'XMLHttpRequest') {
				header("Content-Type: application/json");
				exit('{"code":401,"msg":"Not authorized.","url":"'.$serveruri.'/login.php"}');
			}
			header("Location: " . $serveruri . "/login.php");
			exit();
		}
	}

	public static function set($key, $value) {
		$_SESSION[Auth::SESSION_KEY][$key] = $value;
	}

	public static function get($key) {
		return $_SESSION[Auth::SESSION_KEY][$key];
	}

	public static function destroy() {
		$_SESSION = null;
		unset($_SESSION);
		session_destroy();
		session_start();
	}
}
Auth::init();
?>
