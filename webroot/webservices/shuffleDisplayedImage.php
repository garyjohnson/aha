<?php
// Take image save to file system under images and then insert into device folder
// and save the device to the database and the image.
require_once '../source/AHAConstants.php';
require_once '../source/config.php';
require_once('../source/MySQLi.class.php');

//::TODO:: Remove this is some testing
//var_dump($_REQUEST,$_FILES);

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

$shuffleOutguid=$_REQUEST['guid'];
if ($shuffleOutguid)
{
    $shuffleOutSQL='UPDATE images SET status=' . AHAConstants::STATUS_SKYLINED . ' WHERE guid=?';
    $params = array(':guid' => $shuffleOutguid);
    $stmt=$db->prepare($shuffleOutSQL);
    $stmt->bind_param('s', $shuffleOutguid);
    $stmt->execute();
}

$resultSet = $db->select('images', 'guid', 'WHERE status=' . AHAConstants::STATUS_APPROVED . ' order by timestamp asc LIMIT 1');
if($row = $db->fetch())
{
   $retguid = $row['guid'];
}

if ($retguid)
{
    $shuffleInSQL='UPDATE images SET status=' . AHAConstants::STATUS_DISPLAYING . ' WHERE guid=?';
    $stmt=$db->prepare($shuffleInSQL);
    $stmt->bind_param('s', $retguid);
    $stmt->execute();
}

echo json_encode(array('guid'=>$retguid));

?>

