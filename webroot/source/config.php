<?php
class Config {
	public static $mysql = Array(
		"host"=>"localhost",
		"user"=>"ahauser",
		"pass"=>"hahafunny1!",
		"db"=>"aha",
		"prefix"=>"",
		"debug"=>false
	);
        //This is needed because to set the src field in jquery you must give a full path to the image
        public static $imageurl = "http://172.16.0.160:8888/GiveCamp/webroot/images/";
        public static $startImage = "myDeviceId_CD54CB10-0C8E-4060-BA55-9993AB4F5AAC.jpg";
}
?>
