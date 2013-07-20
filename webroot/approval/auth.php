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
			header("Location: /approval/login.php");
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