<?php
/**
 * Small tooltip manager
 * User: hadidotj
 * Date: 7/20/13
 * Time: 2:00 AM
 */
class ToolTip {
	const TYPE_PNG = "png";
	const TYPE_JPEG = "jpeg";
	const TYPE_GIF = "gif";

	private $file;
	private $img;
	private $extText;
	private $ext;

	public function ToolTip($file) {
		$this->file = $file;
		$this->setExtension($file);
		$this->createImage();
	}

	public function printImage($type = null, $filename = null) {
		if($type == null) $type = $this->ext;

		switch($type) {
			case ToolTip::TYPE_PNG:
				imagepng($this->img, $filename);
				break;

			case ToolTip::TYPE_JPEG:
				imagejpeg($this->img, $filename);
				break;

			case ToolTip::TYPE_GIF:
				imagegif($this->img, $filename);
				break;

			default:
				imagepng($this->img, $filename);
				break;
		}
	}

	private function createImage() {
		switch($this->ext) {
			case ToolTip::TYPE_PNG:
				$this->img = imagecreatefrompng($this->file);
				break;

			case ToolTip::TYPE_JPEG:
				$this->img = imagecreatefromjpeg($this->file);
				break;

			case ToolTip::TYPE_GIF:
				$this->img = imagecreatefromgif($this->file);
				break;

			default:
				$this->img = imagecreatefromstring(file_get_contents($this->file));
				break;
		}
	}

	private function setExtension($file) {
		$this->extText = substr(strrchr($file,"."),1);
		switch($this->extText) {
			case "png":
				$this->ext = ToolTip::TYPE_PNG;
				break;

			case "jpeg":
			case "jpg":
				$this->ext = ToolTip::TYPE_JPEG;
				break;

			case "gif":
				$this->ext = ToolTip::TYPE_GIF;
				break;

			default:
				$this->ext = null;
				break;
		}
	}
}
?>