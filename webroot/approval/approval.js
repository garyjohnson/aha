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
		Approval.denied.push(img.attr("id"));
	},
	deselectImage:function(img) {
		img.removeClass("selected");
		$("#overlay-"+img.attr("id")).remove();
		if((index = Approval.denied.indexOf(img.attr("id"))) >= 0) {
			Approval.denied.splice(index, 1);
		}
	},
	approveAll:function() {
		var ids = [];
		var imgs = $("#imageList img");
		for(var i=0;i<imgs.length;i++) {
			ids.push($(imgs.get(i)).attr("id"));
		}
		if(ids.length > 0) {
			$.ajax({
				cache:false,
				data:{approve:true,imgs:ids},
				type:"POST",
				url:"approve.php",
				success:function(data) {
					if(data.code == 200) {
						$("#imageList").html("");
						Approval.denied = [];
						location.href = "index.php"; // Refresh the page ;)
					} else if (data.url) {
						location.href = data.url;
					}
				},
				error:function(xhr,status,error) {
					alert("There was an error while approving. Please try again.");
				}
			});
		}
	},
	denySelected:function() {
		var ids = Approval.denied;
		if(ids.length > 0) {
			$.ajax({
				cache:false,
				data:{deny:true,imgs:ids},
				type:"POST",
				url:"deny.php",
				success:function(data) {
					if(data.code == 200) {
						for(var i in Approval.denied) {
							$("#overlay-"+Approval.denied[i]).remove();
							$("#"+Approval.denied[i]).remove();
						}
						Approval.denied = [];
						$("#pendingCount").html($("#imageList img").length);
						if($("#imageList img").length <=0)
							location.href = "index.php"; // Refresh the page b/c there are none left!
					} else if (data.url) {
						location.href = data.url;
					}
				},
				error:function(xhr,status,error) {
					alert("There was an error while denying. Please try again.");
				}
			});
		}
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