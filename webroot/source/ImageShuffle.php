<?php
require_once '../source/AHAConstants.php';
require_once '../source/config.php';
require_once('../source/MySQLi.class.php');

class AHAImageShuffle {
    private $numimagesbetweensponsorimages=24;
    private $url;
    private $displayimagenum = 0;
    private $stockimagenum = 0;
    private $sponsorimagenum = 0;
    private $db;

    public function __construct() {
        $this->db = new SQL($host = "localhost", $user = "ahauser", $pass = "hahafunny1!", $db = "aha", $prefix = "", $debug = FALSE);
        session_start();
	if (is_null($_SESSION['displayimagenum']))
	{
	    $_SESSION['displayimagenum']=0;
	}
	if (is_null($_SESSION['stockimagenum']))
	{
	    $_SESSION['stockimagenum']=0;
	}
	if (is_null($_SESSION['sponsorimagenum']))
	{
	    $_SESSION['sponsorimagenum']=0;
	}
	$this->displayimagenum = $_SESSION['displayimagenum'];
	$this->stockimagenum = $_SESSION['stockimagenum'];
	$this->sponsorimagenum = $_SESSION['sponsorimagenum'];
	$serveruri = $_SERVER['REQUEST_URI'];
	$this->url = "http://" . $_SERVER['HTTP_HOST'] . substr($serveruri, 0, strrpos($serveruri, '/')) . "/../";
    }
    private function saveSessionVars() {
	$_SESSION['displayimagenum'] = $this->displayimagenum;
	$_SESSION['stockimagenum'] = $this->stockimagenum;
	$_SESSION['sponsorimagenum'] = $this->sponsorimagenum;
    }

    private function moveImageFromApprovedToDisplaying($displayguid) {
        if ($displayguid)
        {
            $toDisplayingSQL='UPDATE images SET status=' . AHAConstants::STATUS_COMPLETED . ' WHERE guid=?';
	    $stmt=$this->db->prepare($toDisplayingSQL);
	    $stmt->bind_param('s', $displayguid);
	    $stmt->execute();
        }
    }
    private function moveImageFromDisplayingToSkylined($skylinedguid) {
        if ($skylinedguid)
        {
            $toSkylineSQL='UPDATE images SET status=' . AHAConstants::STATUS_SKYLINED . ' WHERE guid=?';
	    $stmt=$this->db->prepare($toSkylineSQL);
	    $stmt->bind_param('s', $skylinedguid);
	    $stmt->execute();
        }
    }
    public function getNextImageToDisplay() {
        if ($this->displayimagenum % 24 != 0)
	{
	    $returl = $this->getNextUserImageToDisplay();
	    if (is_null($returl))
	    {
	        $returl = $this->getNextStockImageToDisplay();
	    }
	}
	else
	{
	    $returl = $this->getNextSponsorImageToDisplay();
	    $this->displayimagenum = 0;
	}
	$this->displayimagenum += 1;
	$this->saveSessionVars();
	return $returl;
    }

    private function getNextStockImageToDisplay() {
        $directory = "../stockimages";
	$scanned_directory = array_diff(scandir($directory), array('..', '.'));
	$numfiles = sizeof($scanned_directory);
	echo "numfiles=".$numfiles;
	if ($numfiles > 0)
	{
	    $this->stockimagenum = $this->stockimagenum % $numfiles;
	    $returl = $this->url . "stockimages/" . $scanned_directory[2 + $this->stockimagenum];
	    $this->stockimagenum += 1;
	}
	return $returl;
    }

    private function getNextSponsorImageToDisplay() {
        $directory = "../sponsorimages";
	$scanned_directory = array_diff(scandir($directory), array('..', '.'));
	$numfiles = sizeof($scanned_directory);
	if ($numfiles > 0)
	{
	    $this->sponsorimagenum = $this->sponsorimagenum % $numfiles;
	    $returl = $this->url . "sponsorimages/" . $scanned_directory[2 + $this->sponsorimagenum];
	    $this->sponsorimagenum += 1;
	}
	return $returl;
    }

    private function getNextUserImageToDisplay() {
        $resultSet = $this->db->select('images', 'guid', 'WHERE status=' . AHAConstants::STATUS_APPROVED . ' order by timestamp asc LIMIT 1');
	if($row = $this->db->fetch())
	{
	   $returl = $row['guid'];
	   if ($returl)
	   {
	       $this->moveImageFromApprovedToDisplaying($returl);
	       $returl = $this->url . "images/" . $returl;
	   }
	}
	return $returl;
    }
}
?>
