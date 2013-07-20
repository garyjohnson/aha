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
}

?>
