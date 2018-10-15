<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="windy.aspx.cs" Inherits="IBHSWMap.Site.windy" %>

<!DOCTYPE html>
<html>
<head>
    <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-MCw98/SFnGE8fJT3GXwEOngsV7Zt27NXFoaoApmYm81iuXoPkFOJwJ8ERdknLPMO" crossorigin="anonymous">

    <script src="https://code.jquery.com/jquery-3.3.1.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/js/bootstrap.min.js" integrity="sha384-ChfqqxuZUCnJSK3+MXmPNIyE6ZbWh2IMqE241rYiqJxyMiZ6OW/JmZQ5stwEULTy" crossorigin="anonymous"></script>

     
    <script src="https://api4.windy.com/assets/libBoot.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/bluebird/3.3.5/bluebird.min.js"></script>
    <!--<script src="https://cdn.jsdelivr.net/npm/es6-promise@4/dist/es6-promise.min.js"></script>-->
    <!--<script src="https://cdn.jsdelivr.net/npm/es6-promise@4/dist/es6-promise.auto.min.js"></script>-->
    <!--<script src="https://cdn.jsdelivr.net/npm/promise-polyfill@8/dist/polyfill.min.js"></script>-->

    <!--<link rel="stylesheet" href="https://unpkg.com/leaflet@1.3.4/dist/leaflet.css" />-->
    <!--<script src="https://unpkg.com/leaflet@1.3.4/dist/leaflet.js" ></script>-->
    <script src="../vendors/Leaflet.0.7.7.1/dist/leaflet-src.js"></script>
    <script src="../vendors/Leaflet.0.7.7.1/dist/leaflet.js"></script>
    <link href="../vendors/Leaflet.0.7.7.1/dist/leaflet.css" rel="stylesheet" />
    <style>
        #windy {
            width: 100%;
            height: 100%;
        }

        .addr {
            user-select: all;
        }

        textarea {
            border: 0;
            overflow: auto;
            resize: none;
        }
    </style>

    <meta charset="utf-8" />
    <title>Designations Weather Map</title>
</head>
<body style="position:absolute;width:100%;height:100%">
    <form id="mainForm" runat="server"  ><asp:HiddenField runat="server" id="ServerException" /></form>  
    <div class="col-md-12" style="display:none;color:white;background-color:red" id="IEBanner">
        <h4>IE is too slow to load all addresses.  Please use any other browser! Only 500 locations shown.</h4>
    </div>
    <div class="col-md-12" id="LoadingDiv">
        <div class="row justify-content-center" style="margin-top:100px">
            <img src="world.gif" style="width: 100px;height: 100px;" />
        </div>
        <div class="row justify-content-center" style="margin-top:10px" id="LoadingDivText">
            Loading Addresses
        </div>
    </div>
    <div class="col-md-12" id="windy"  >


    </div>


    <script>
        var WINDYAPI;
        $(document).ready(function () {
            var mapLocation = getMapLocations();


        });


        function initMap(locations) {
            $("#LoadingDiv").hide();
            //$("#windy").hide();
            const options = {

                // Required: API key
                key: 'rMhagcaAQ9pvjBFHAeniG2Cy0SdBIMHB',

                // Put additional console output
                verbose: false,

                // Optional: Initial state of the map
                lat: 32.8,
                lon: -90.6,
                zoom: 5
            };

            // Initialize Windy API
            windyInit(options, function (windyAPI) {
                // windyAPI is ready, and contain 'map', 'store',
                // 'picker' and other usefull stuff

                console.log("-IN-------------------------------------------------");
                //console.dir(locations);

                //const { map } = windyAPI;
                //var mapapi = windyAPI;
                WINDYAPI = windyAPI;
                var map = windyAPI.map;
                //var map = L.map('windy').setView([51.5, -0.09], 13);

                // .map is instance of Leaflet map

                // L.popup()
                //     .setLatLng([50.4, 14.3])
                //     .setContent("Hello World")
                //     .openOn(map);

                limit =  locations.AddressList.length;
                if (window.navigator.userAgent.indexOf("MSIE ") > 0 || !!navigator.userAgent.match(/Trident.*rv\:11\./)) {
                    limit = 300;
                    $("#IEBanner").show();
                }

               
                var desColor = "Black";
                var bckColor = "White";
                var pntColor = "Red";
                
               $.each(locations.AddressList, function (i, j) {
                    //console.log(j.DesignationType);
                   
                   if (i < limit) { //just a limiter

                      
                       if (j.DesignationType.search("Gold") > 0) {
                           desColor = "Black";
                           bckColor = "Gold";
                           pntColor = "Gold";
                       } else if (j.DesignationType.search("Silver") > 0) {
                           desColor = "white";
                           bckColor = "gray";
                           pntColor = "silver";
                       } else if (j.DesignationType.search("Bronze") > 0 ) {
                           desColor = "White";
                           bckColor = "Brown";
                           pntColor = "Brown";
                       } else {
                           desColor = "White";
                           bckColor = "Purple";
                           pntColor = "Purple";
                       }

                        //28.80 x -85.9
                        var jLat = j.Lat; // = (j.Lat == null || j.Lat == "" || isNaN(j.Lat)) ? 33.02 : j.Lat;
                        var jLng = j.Lng; // = (j.Lng == null || j.Lng == "" || isNaN(j.Lat)) ? -85.9 : j.Lng;

                        if ((j.Lat == null || j.Lat == "" || isNaN(j.Lat)) ||
                            (j.Lng == null || j.Lng == "" || isNaN(j.Lat))) {
                            jLat = "33.02";
                            jLng = "-85.9";

                        }

                        var cir = L.circle([jLat, jLng], 200, {
                            color: pntColor,
                            fillColor: "white",
                            fillOpacity: 0
                        });
                        cir.addTo(map);


                       var popText =
                           "<div>" +
                           "<textarea rows=1 onClick='this.select();' style='color:red;height:20px'>" +
                           j.FID +
                           "</textarea>" +
                           "</div>";

                       //console.log("Address : " + j.Address)
                       if (j.Address != "" && j.Address != null) {
                           popText = popText + "<textarea rows=1 class='addr' onClick='this.select();'  >" +
                               j.Address + "\n" +
                               j.City + ", " + j.State + " " + j.Zip + "</textarea>" + "<br />";
                       }
                       popText = popText + 
                            
                            "<span style='color:green'>" + j.ProgramType.replace("FORTIFIED Home:", "") + "</span> " +
                            "<span style='color:" + desColor + ";background-color:" + bckColor + "'>" + j.DesignationType.replace("FORTIFIED", "") + "</span>"
                            ;
                        cir.bindPopup(popText);

                    }


                });

                
                
                console.log("-OUT-------------------------------------------------");



            });
        }



        function initMap_ORIGINAL(locations) {
            const options = {

                // Required: API key
                key: 'rMhagcaAQ9pvjBFHAeniG2Cy0SdBIMHB',

                // Put additional console output
                verbose: false,

                // Optional: Initial state of the map
                lat: 32.8,
                lon: -90.6,
                zoom: 5
            };

            // Initialize Windy API
            //windyInit(options, windyAPI => {
            //    // windyAPI is ready, and contain 'map', 'store',
            //    // 'picker' and other usefull stuff

            //    console.log("-IN-------------------------------------------------")
            //    console.dir(locations);

            //    const { map } = windyAPI;
            //    // .map is instance of Leaflet map

            //    // L.popup()
            //    //     .setLatLng([50.4, 14.3])
            //    //     .setContent("Hello World")
            //    //     .openOn(map);


            //    $.each(locations.AddressList, function (i, j) {
            //        //console.log(j);

            //        var desColor = "Black";
            //        var bckColor = "White";
            //        var pntColor = "Red";
            //        if (j.DesignationType.search("Gold") > 0) {
            //            desColor = "Black";
            //            bckColor = "Gold";
            //            pntColor = "Gold";
            //        } else if (j.DesignationType.search("Silver") > 0) {
            //            desColor = "white";
            //            bckColor = "gray";
            //            pntColor = "silver";
            //        } else {
            //            desColor = "White";
            //            bckColor = "Brown";
            //            pntColor = "Brown";
            //        }

            //        var cir = L.circle([j.Lat, j.Lng], 200, {
            //            color: pntColor,
            //            fillColor: "white",
            //            fillOpacity: 0
            //        }).addTo(map);



            //        var popText =
            //            "<div><textarea rows=1 onClick='this.select();' style='color:red;height:20px'>" + j.FID + "</textarea></div>" +
            //            "<textarea rows=1 class='addr' onClick='this.select();'  >" +
            //            j.Address + "\n" +
            //            j.City + ", " + j.State + " " + j.Zip +
            //            "</textarea><br />" +
            //            "<span style='color:green'>" + j.ProgramType.replace("FORTIFIED Home:", "") + "</span> " +
            //            "<span style='color:" + desColor + ";background-color:" + bckColor + "'>" + j.DesignationType.replace("FORTIFIED", "") + "</span>"
            //            ;
            //        cir.bindPopup(popText);

            //    });

            //    console.log("-OUT-------------------------------------------------");



            //});
        };

        function getMapLocations() {
            var urlPre = location.href.substring(0, window.location.href.lastIndexOf('/'));
            var url = urlPre + "/evaluations.svc/GetAddresses";

            console.log(url);
            $.ajax({
                type: "GET",
                url: url,
                contentType: "application/json; charset=utf-8",
                datatype: "json",
                success: function (data) {
                    console.log("INitializing Map...");
                    initMap(data.d);
                },
                error: function (err) {
                    console.dir(err);
                }
            });

        };

     
    </script>
</body>
    </html>
