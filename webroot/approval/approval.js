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
	},
	approveAll:function() {
		var ids = [];
		for(var img in $("#imageList img")) {
			ids.push(img.attr("id"));
		}
		$.ajax({
			cache:false,
			data:{approve:true,imgs:ids},
			type:"POST",
			url:"/approval/approve.php",
			success:function(data) {
				if(data.code == 200) {
					for(var i in Approval.denied) {
						var img = Approval.denied[i];
						$("#overlay-"+img.attr("id")).remove();
						img.remove();
					}
					Approval.denied = [];
				}
			},
			error:function(xhr,status,error) {
				alert("There was an error while denying. Please try again.");
			}
		});
	},
	denySelected:function() {
		var ids = [];
		for(var i in Approval.denied) {
			ids.push(Approval.denied[i].attr("id"));
		}
		$.ajax({
			cache:false,
			data:{deny:true,imgs:ids},
			type:"POST",
			url:"/approval/deny.php",
			success:function(data) {
				for(var i in Approval.denied) {
					$("#overlay-"+Approval.denied[i].attr("id")).remove();
					Approval.denied[i].remove();
				}
				Approval.denied = [];
			},
			error:function(xhr,status,error) {
				alert("There was an error while denying. Please try again.");
			}
		});
	},
	registerListeners:function() {
		$(document).ready(function() {
			$(".images").click(function() {
				Approval.selectImage($(this));
			});
			$("#denyButton").click(function() {
				Approval.denySelected();
			});
			$("#approveButton").click(function() {
				Approval.approveAll();
			})
		});
	}
};
Approval.registerListeners();