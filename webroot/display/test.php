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

<body>

    <script type="text/javascript">

        //::TODO:: CHANGE BACK TO 30 seconds
        var SHUFFLE_INTERVAL_TIME = 5000;
        
        var currentImageNumber = 0;
        var lastGuid= null;
        
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
                lastGuid = $('#image'+currentImageNumber).attr('src');
                $('#image'+currentImageNumber).attr('src', data.guid);
            }, "json");
        }
        
        function IncrementImageNumber()
        {
            currentImageNumber = currentImageNumber+1;
            if (currentImageNumber==7)
            {
                currentImageNumber=1;
            }
        }

    </script>

    <div id="container" class="cotainer">
        <!--  Row 1 -->
        <div class="row">
            <div class="col"><img id="image1" src="../images/CF58EF06-1E86-4E2C-93C1-A035F340DD4B_9DE2367F-FB86-494A-B3B0-54104B80068C.jpg"/></div>
            <div class="col"><img id="image2" src="../images/CF58EF06-1E86-4E2C-93C1-A035F340DD4B_9DE2367F-FB86-494A-B3B0-54104B80068C.jpg"/></div>
            <div class="col"><img id="image3" src="../images/CF58EF06-1E86-4E2C-93C1-A035F340DD4B_9DE2367F-FB86-494A-B3B0-54104B80068C.jpg"/></div>
        </div>

        <!--  Row 2 -->
        <div class="row">
            <div class="col"><img id="image4" src="../images/CF58EF06-1E86-4E2C-93C1-A035F340DD4B_9DE2367F-FB86-494A-B3B0-54104B80068C.jpg"/></div>
            <div class="col"><img id="image5" src="../images/CF58EF06-1E86-4E2C-93C1-A035F340DD4B_9DE2367F-FB86-494A-B3B0-54104B80068C.jpg"/></div>
            <div class="col"><img id="image6" src="../images/CF58EF06-1E86-4E2C-93C1-A035F340DD4B_9DE2367F-FB86-494A-B3B0-54104B80068C.jpg"/></div>
        </div>


        <!--  Row 3 SKYLINE -->
        <div class="row">

        </div>
    </div>


<!--        <script src="js/plugins.js"></script>
        <script src="js/main.js"></script>-->

</body>
</html>
