<?
require_once '../source/AHAConstants.php';
require_once '../source/config.php';
require_once('../source/MySQLi.class.php');

?>
<head>
    <META HTTP-EQUIV="refresh" CONTENT="15">
</head>
<h1>Run the Display</h1>
<a href="runDisplay.php">Run Display</a><br/><br/>
<h1>Below are all the images in the image directory</h1> - Refreshes every 15 seconds<br/>
<?php
$dirname = "../images/";
$images = glob($dirname."*.jpg");
foreach($images as $image) {
echo '<img src="'.$image.'" style="width:250px;height:250px;"/>';
}?>


<?php

$approvedArray = array();
$pendingArray = array();
$displayingArray = array();
$skylinedArray = array();
$completedArray = array();

$db = new SQL(Config::$mysql);
$db->select('images');
$rows = $db->fetchAll();

foreach ($rows as $row)
{
    if($row['status']==AHAConstants::STATUS_APPROVED)
    {
        array_push($approvedArray, $row);
    }
    else if($row['status']==AHAConstants::STATUS_PENDING)
    {
         array_push($pendingArray, $row);
    }
    
    else if($row['status']==AHAConstants::STATUS_DISPLAYING)
    {
         array_push($displayingArray, $row);
    }
    else if($row['status']==AHAConstants::STATUS_SKYLINED)
    {
         array_push($skylinedArray, $row);
    }
    else if($row['status']==AHAConstants::STATUS_COMPLETED)
    {
         array_push($completedArray, $row);
    }
}
?>


<h1>Below are all approved images</h1> 
<?php 
foreach ($approvedArray as $row)
{
echo '<img src="../images/'.$row['guid'].'" style="width:250px;height:250px;"/>';
}
?>
<h1>Below are all pending images</h1> 
<?php 
foreach ($pendingArray as $row)
{
echo '<img src="../images/'.$row['guid'].'" style="width:250px;height:250px;"/>';
}
?>

<h1>Below are all displaying images</h1> 
<?php 
foreach ($displayingArray as $row)
{
echo '<img src="../images/'.$row['guid'].'" style="width:250px;height:250px;"/>';
}
?>

<h1>Below are all skylined images</h1> 
<?php 
foreach ($skylinedArray as $row)
{
echo '<img src="../images/'.$row['guid'].'" style="width:250px;height:250px;"/>';
}
?>

<h1>Below are all completed images</h1> 
<?php 
foreach ($completedArray as $row)
{
echo '<img src="../images/'.$row['guid'].'" style="width:250px;height:250px;"/>';
}
?>