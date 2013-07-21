<? include '../source/config.php';?>
</!DOCTYPE html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <title>AHA!</title>
    <meta name="description" content="">
    <meta name="viewport" content="width=device-width">
    <link rel="stylesheet" href="../source/css/frontend.css">
    <script src="//ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js"></script>
    <!--        <link rel="stylesheet" href="css/normalize.css">
            <link rel="stylesheet" href="css/main.css">
            <script src="js/vendor/modernizr-2.6.2.min.js"></script>-->
</head>

<body style="background-color: black;">
    <script src="js/canvasmask.js"></script>
    <script type="text/javascript">

        //::TODO:: CHANGE BACK TO 30 seconds
        var SHUFFLE_INTERVAL_TIME = 3000;
        
        var currentImageNumber = 6;
        var row = 0;
        var squareWidth = 180;
        var skylineWidth = 1000;
        var leftPosition = 0;
        var skylineHeight = 1200 - squareWidth;
        var topPosition = skylineHeight;
        var lastGuid = null;
        var droppingGuid = null;
        
        $(document).ready(function() 
        {
            var tid = setInterval(Shuffle, SHUFFLE_INTERVAL_TIME);
        });

        function Shuffle() 
        {
            IncrementImageNumber();
            $.post("../webservices/shuffleDisplayedImage.php", 
            { "guid":  $('#image'+currentImageNumber).attr('src')},
            function(data)
            {
                if(data.imageurl!=null)
                {
		    imagenumber = (currentImageNumber % 6) + 1;
                    droppingGuid = $('#image'+imagenumber).attr('src');
                    animateDroppingImage();
                    $('#image'+imagenumber).attr('src', data.imageurl);
                }
                
                
            }, "json");
        }
        
        function IncrementImageNumber()
        {
            currentImageNumber = currentImageNumber+1;
        }
        
        function animateDroppingImage()
        {
            
            $('#skyline').append('<img id="image'+currentImageNumber+'" src="'+droppingGuid+'" style="opacity:0;width:'+squareWidth+'px;height:'+squareWidth+'px;position:absolute" />')
            $('#image'+currentImageNumber).animate({
                left: '+='+leftPosition,
                top: '+='+topPosition,
		opacity:1
                }, 5000, function() {
                // Animation complete.
                });        
                
            leftPosition = leftPosition+squareWidth;
            if((leftPosition)>=skylineWidth)
            {
                leftPosition=0;
                topPosition = topPosition-squareWidth;
            }
            if((topPosition)<400)
            {
                //reset the skyline
                
                setTimeout(function(){
                $('#skyline').html(' <img src="img/CityBack2.png" style="position: absolute;z-index: 1"/>'); 
                topPosition=skylineHeight;
                leftPosition=0;
                },SHUFFLE_INTERVAL_TIME)
                
            }
            
        }
    </script>

    <div id="container" class="cotainer" style="height:320px;">
        <!--  Row 1 -->
        <div class="row">
            <div class="col"><img id="image1" src="../<?= Config::$startImage1?>"/></div>
            <div class="col"><img id="image2" src="../<?= Config::$startImage2?>"/></div>
            <div class="col"><img id="image3" src="../<?= Config::$startImage3?>"/></div>
        </div>

        <!--  Row 2 -->
        <div class="row">
            <div class="col"><img id="image4" src="../<?= Config::$startImage1?>"/></div>
            <div class="col"><img id="image5" src="../<?= Config::$startImage2?>"/></div>
            <div class="col"><img id="image6" src="../<?= Config::$startImage3?>"/></div>
        </div>


        <!--  Row 3 SKYLINE -->
        <div id="skyline">
            <img src="img/CityBack2.png" style="position: absolute;z-index: 1"/>
        </div>
    </div>


<!--        <script src="js/plugins.js"></script>
        <script src="js/main.js"></script>-->

</body>
</html>
