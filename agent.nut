local html = @"<!doctype html>
<html lang=""en"">
<head>
  <meta charset=""utf-8"" />
  <meta name=""viewport"" content=""width=device-width, initial-scale=1.0"">
  <title>Pan/Tilt Control</title>
  <link rel=""stylesheet"" href=""https://code.jquery.com/ui/1.10.3/themes/smoothness/jquery-ui.css"" />
  <link rel=""stylesheet"" href=""//d2c5utp5fpfikz.cloudfront.net/2_3_1/css/bootstrap.min.css"" >
  <link rel=""stylesheet"" href=""//d2c5utp5fpfikz.cloudfront.net/2_3_1/css/bootstrap-responsive.min.css"" >
  <script src=""https://code.jquery.com/jquery-1.9.1.js""></script>
  <script src=""https://code.jquery.com/ui/1.10.3/jquery-ui.js""></script>
  <script type = ""text/javascript"">
    function sendToImp(value){
        if (window.XMLHttpRequest) {devInfoReq=new XMLHttpRequest();}
        else {devInfoReq=new ActiveXObject(""Microsoft.XMLHTTP"");}
        try {
            devInfoReq.open('POST', document.URL, false);
            devInfoReq.send(value);
        } catch (err) {
            console.log('Error parsing device info from imp');
        }
    }
    function pan(value){
        sendToImp('{""pan"":""' + value +'""}');
    }
    function tilt(value){
        sendToImp('{""tilt"":""' + value +'""}');
    }
  $(function() {
    $( '#slider-vertical' ).slider({
      orientation: 'vertical',
      range: 'min',
      min: 0,
      max: 100,
      value: 50,
      step: 10,
      stop: function( event, ui ) {
        $( '#tilt' ).val( ui.value );
        tilt(ui.value);
      }
    });
    $( '#tilt' ).val( $( '#slider-vertical' ).slider( 'value' ) );
  });
    $(function() {
    $( '#slider-horizontal' ).slider({
      orientation: 'horizontal',
      range: 'min',
      min: 0,
      max: 100,
      value: 50,
      step: 10,
      stop: function( event, ui ) {
        $( '#pan' ).val( ui.value );
        pan(ui.value);
      }
    });
    $( '#pan' ).val( $( '#slider-horizontal' ).slider( 'value' ) );
  });
  </script>
</head>
<body>
<div class='well' style='max-width: 320px; margin: 0 auto 10px; height:480px; font-size:22px;'>
      <div class='row' style='margin-left:40px;'>
        <div class='col-sm-4'>
          <div class='panel panel-default'>
            <div class='panel-heading'>
              <h3 class='panel-title'>Pan & Tilt</h3>
            </div>
            <div class='panel-body'>
            <div>
               <label for='tilt'>Tilt:</label>
                 <input type='text' id='tilt' style='width:30px; border: 0; color: #f6931f; font-weight: bold;' />
            </div>
            <div id='slider-vertical' style='height: 200px;'></div>
            
             <label for='pan'>Pan:</label>
                <input type='text' id='pan' style='width:30px; border: 0; color: #f6931f; font-weight: bold;' />
             
            <div id='slider-horizontal' style='width: 200px;'></div>
            </div>
          </div>
</div>
</body>
</html>";

http.onrequest(function(request,res){
    if (request.body == "") {
        res.send(200, html);
    }else{
        local json = http.jsondecode(request.body);
        if("pan" in json){
            server.log("Agent: Panning");
            device.send("pan", json.pan);
        }else if("tilt" in json){
            server.log("Agent: Tilting");
            device.send("tilt", json.tilt);
        }else{
            server.log("Unrecognized Body: "+request.body);
        }
        res.send(200, "");
    }
});
