$(document).ready(function() {
	$(".images").click(function() {
		var overlay = $("<div/>").addClass("deniedOverlay");
		overlay.css({left:$(this).position().left,top:$(this).position().top});
		$("#imageList").append(overlay);
	});
});