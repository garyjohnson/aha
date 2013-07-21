<?php
// Take image save to file system under images and then insert into device folder
// and save the device to the database and the image.
require_once '../source/ImageShuffle.php';

//::TODO:: Remove this is some testing
//var_dump($_REQUEST,$_FILES);

//log each request
//$file = 'log.txt';
//$current = file_get_contents($file);
//file_put_contents($file, $current.  date("F j, Y, g:i a")."\n"
        //."==FILES==".print_r($_FILES, TRUE)
        //."==REQUEST==".print_r($_REQUEST, TRUE)
        //."==GetAllHeaders==".print_r(getallheaders(), TRUE)."\n");

// -------------------------------------------
// - Save metadata to the database
// -------------------------------------------

//::TODO:: use config file for DB connection
//$db = new SQL(Config::$mysql);
$imageshuffle = new AHAImageShuffle();
$returl = $imageshuffle->getNextImageToDisplay();

echo json_encode(array('imageurl'=>$returl));

?>

