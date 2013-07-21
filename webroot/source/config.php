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
        public static $startImage1 = "sponsorimages/aha_logo-04.jpg";
        public static $startImage2 = "sponsorimages/aha_logo-05.jpg";
        public static $startImage3 = "sponsorimages/aha_logo-06.jpg";
}
?>
