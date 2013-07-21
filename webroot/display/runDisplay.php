<? include '../source/config.php';?>
<!DOCTYPE html>
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
        var squareWidth = 200;
        var skylineWidth = 1100;
        var leftPosition = 0;
        var skylineHeight = 1200;
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
                    droppingGuid = $('#image4').attr('src');
                    animateDroppingImage();
                    $('#image4').attr('src',$('#image5').attr('src'));
                    $('#image5').attr('src',$('#image6').attr('src'));
                    $('#image6').attr('src',$('#image3').attr('src'));
                    $('#image3').attr('src',$('#image2').attr('src'));
                    $('#image2').attr('src',$('#image1').attr('src'));
                    $('#image1').attr('src', data.imageurl);
                }
                
                
            }, "json");
        }
        
        function IncrementImageNumber()
        {
            currentImageNumber = currentImageNumber+1;
        }
        
        function animateDroppingImage()
        {
            
            $('#skyline').append('<img id="image'+currentImageNumber+'" src="'+droppingGuid+'" style="width:'+squareWidth+'px;height:'+squareWidth+'px;position:absolute" />')
            $('#image'+currentImageNumber).animate({
                left: '+='+leftPosition,
                top: '+='+topPosition
                }, 5000, function() {
                // Animation complete.
                });        
                
            leftPosition = leftPosition+squareWidth;
            if((leftPosition)>=skylineWidth)
            {
                leftPosition=0;
                topPosition = topPosition-squareWidth;
            }
            if((topPosition)<0)
            {
                //reset the skyline
                
                setTimeout(function(){
                $('#skyline').html(' <img src="img/CityBack.png" style="position: absolute;z-index: 1"/>'); 
                topPosition=skylineHeight;
                leftPosition=0;
                },SHUFFLE_INTERVAL_TIME)
                
            }
            
        }
    </script>

    <div id="container" class="cotainer">
        <!--  Row 1 -->
        <div class="row">
            <div class="col"><img id="image1" src="../images/<?= Config::$startImage?>"/></div>
            <div class="col"><img id="image2" src="../images/<?= Config::$startImage?>"/></div>
            <div class="col"><img id="image3" src="../images/<?= Config::$startImage?>"/></div>
        </div>

        <!--  Row 2 -->
        <div class="row">
            <div class="col"><img id="image4" src="../images/<?= Config::$startImage?>"/></div>
            <div class="col"><img id="image5" src="../images/<?= Config::$startImage?>"/></div>
            <div class="col"><img id="image6" src="../images/<?= Config::$startImage?>"/></div>
        </div>


        <!--  Row 3 SKYLINE -->
        <div id="skyline" class="row" style="min-height: 1200px;height:1200px;width:1080px;">
            <img src="img/CityBack.png" style="position: absolute;z-index: 1"/>
        </div>
    </div>


<!--        <script src="js/plugins.js"></script>
        <script src="js/main.js"></script>-->

</body>
</html>
