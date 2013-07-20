<?php
// Take image save to file system under images and then insert into device folder 
// and save the device to the database and the image.
require_once '../source/AHAConstants.php';
require_once '../source/config.php';
require_once('../source/MySQLi.class.php');

//::TODO:: Remove this is some testing
var_dump($_REQUEST,$_FILES);

//log each request
$file = 'log.txt';
$current = file_get_contents($file);
file_put_contents($file, $current.  date("F j, Y, g:i a")."\n"
        ."==FILES==".print_r($_FILES, TRUE)
        ."==REQUEST==".print_r($_REQUEST, TRUE)
        ."==GetAllHeaders==".print_r(getallheaders(), TRUE)."\n");


// -------------------------------------------
// - Save metadata to the database
// -------------------------------------------

//::TODO:: use config file for DB connection
//$db = new SQL(Config::$mysql);
$db = new SQL($host = "localhost", $user = "ahauser", $pass = "hahafunny1!", $db = "aha", $prefix = "", $debug = FALSE);



//check if device is black listed before saving file an

$resultSet = $db->select('device', '*', 'WHERE guid='.$_REQUEST['device']);
if($row = $db->fetch())
{
    if ($row['blacklisted']== AHAConstants::DEVICE_BLACKLISTED)
        exit();
    
}
else 
    {
    //insert device into databaes
    $db->insert('devices', array('guid'=>$_REQUEST['device'],'email'=>$_REQUEST['email']));
}


$db->insert('images', array('guid'=>$_REQUEST['device']."_".$_FILES["file"]["name"],'device'=>$_REQUEST['device'],'status'=>'0'));

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
    "../images/". $_REQUEST['device'] . "_" . $_FILES["file"]["name"]);
    echo "Stored in: " . "../images/" . $_REQUEST['device'] . "_" . $_FILES["file"]["name"];
}

?>

