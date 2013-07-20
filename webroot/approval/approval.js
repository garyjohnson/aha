var Approval = {
	denied:[],
	selectImage:function(img) {
		var overlay = $("<div />")
			.addClass("deniedOverlay")
			.css({left:img.position().left,top:img.position().top})
			.attr("id","overlay-"+img.attr("id"));
		$("#imageList").append(overlay);
		overlay.click(function() {
			Approval.deselectImage(img);
		});
		img.addClass("selected");
		Approval.denied.push(img);
	},
	deselectImage:function(img) {
		img.removeClass("selected");
		$("#overlay-"+img.attr("id")).remove();
		if(index = Approval.denied.indexOf()) {
			Approval.denied.splice(index, 1);
		}
	}
};

$(document).ready(function() {
	$(".images").click(function() {
		Approval.selectImage($(this));
	});
});