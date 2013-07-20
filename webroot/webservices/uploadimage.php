<?php
// Take image save to file system under images and then insert into device folder 
// and save the device to the database and the image.
require_once '../source/config.php';
require_once('../source/MySQLi.class.php');



//::TODO:: Remove this is some testing
var_dump($_REQUEST,$_FILES);

// -------------------------------------------
// - Saves file to filesystem at ../images/
// -------------------------------------------
if (file_exists("../images/" . $_FILES["file"]["name"]))
{
    echo $_FILES["file"]["name"] . " already exists. ";
}
else
{
    move_uploaded_file($_FILES["file"]["tmp_name"],
    "../images/" . $_FILES["file"]["name"]);
    echo "Stored in: " . "../images/" . $_FILES["file"]["name"];
}

// -------------------------------------------
// - Save metadata to the database
// -------------------------------------------

//::TODO:: use config file for DB connection
//$db = new SQL(Config::$mysql);
$db = new SQL($host = "localhost", $user = "ahauser", $pass = "hahafunny1!", $db = "aha", $prefix = "", $debug = FALSE);

$db->insert('images', array('guid'=>$_FILES["file"]["name"],'device'=>$_REQUEST['device'],'status'=>'0'));
var_dump($db);exit();
?>
?>

