$(document).ready(function () {

    /* debut fonctions */

    function updateParkingSolutionFront() {
        var parkings = [];
        $.post("/getParkingLibre", "", function (data) {
            $.each(data, function (i, park) {
                parkings[i] = park.idParking;
            });

            //alert($('#plane').text());
            for (i = 0; i < 3; i++) {
                $("#parking-" + i.toString()).text(parkings[i]);

            }
        }, 'json');
        return parkings;
    }

    function updatePlaneFront() //return list of all planes from view if needed
    {
        $.post("/getAvionLibre", "", function (data) {
            /* array from database data */
            let planes = [];
            $.each(data, function (i, plane) {
                let tableau = [];
                tableau[0] = plane.idAvion;
                tableau[1] = plane.immatAvion;
                tableau[2] = plane.categorie;
                planes[i] = tableau;
            });

            /* choice of 1 plane (first one) & frontend update*/
            if (planes[0] != null) //there are still planes to land
            {
                $("#plane").text(planes[0][1]);
            } else {
                $("#plane").text("PLUS D'AVION !");
            }

            return planes;

        }, 'json');
    }

    function updateButtonFront() {
        if (updateParkingSolutionFront().length === 0) {
            $('#solution-button').text("Recalculer");
        } else {
            $('#solution-button').text("Refuser");
        }
    }

    function assignParking(plane, parking) {
        $.post("/assignerAvion", {plane: plane, parking: parking}, function (isExecuted) {
            updatePlaneFront();
            updateParkingSolutionFront();


        });
    }


    /* fin fonctions */

    //affiche de la carte dur l'Haneda
    var map = new ol.Map({
        target: 'map',
        layers: [
            new ol.layer.Tile({
                //source: new ol.source.OSM()
                source: new ol.source.XYZ({
                    attributions: ['Powered by Esri',
                        'Source: Esri, DigitalGlobe, GeoEye, Earthstar Geographics, CNES/Airbus DS, USDA, USGS, AeroGRID, IGN, and the GIS User Community'],
                    attributionsCollapsible: false,
                    url: 'https://services.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}',
                    maxZoom: 23
                })
            })
        ],
        view: new ol.View({
            center: ol.proj.fromLonLat([139.78577, 35.54905]),
            zoom: 13.5
        })
    });

    map.set('name', 'mapName');


    /*

        var listeLayerParking=[];
        $.each(dataP,function (i,park) {
            let xy = park.coordonnees.split(',');
            let latitude = xy[0];
            longitude = xy[1];
            let nomParking = park.idParking;
                 alert("2");
            listeLayerParking[i] = draw_markerParking(latitude, longitude, nomParking, couleurParking, rotation, map);
        });

    */


    /*
    // trajectoire vers l'homme Parking
    let lineBleue=[
        [1.4793492845952274, 43.56520767508311],
        [1.4806045583782506, 43.56396382024834],
        [1.4824928334706613, 43.56499000234101],
        [1.4821709683980915, 43.56532428515708],
        [1.4818169168182642, 43.5658218189366]];

    // trajectoire vers l'homme Décollage/Atterrissae
    let lineRouge=[
        [1.4818169168182642, 43.5658218189366],
        [1.4821709683980915, 43.56532428515708],
        [1.4824928334706613, 43.56499000234101],
        [1.4838983109542172, 43.56369172357968]];
*/

    //Affichage des avions

    /*DEBUT Parking*/

    $.post("/getParking", "", function (dataP) {
        var couleur = "#66ffff"
        var rotation = 0.0
        var listeLayerParking = [];
        $.each(dataP, function (i, park) {
            let xy = park.coordonnees.split(',');
            let latitude = xy[1];
            longitude = xy[0]; /*inversion parce qu'on est con sur la base de données*/
            let nomParking = park.idParking;

            listeLayerParking[i] = draw_markerParking(latitude, longitude, nomParking, couleur, rotation, map);
            /*Ajout sur principe du pacman*/
            map.addLayer(listeLayerParking[i]); // affichage sur la carte des markers
            listeLayerParking[i].getStyle()[0].getImage().setRotation(rotation); // rotation en radian


            $('button').on('click', function () { // click sur bouton "en route"
                let stepMarker = 100;
            });


        });

    }, 'json');


    /*FIN Parking*/

    /* DEBUT Waypoint */

    $.post("/getWaypoint", "", function (dataP) {
        var couleur = "#6FF"
        var couleurtax = "#F45715" /*Orange*/
        var couleurcir = "#10CF35" /*VertClair*/
        var couleurpistD = "#FAF80C" /*Jaune*/
        var couleurpistA = "#FA0001" /*Rouge*/
        var rotation = 0.0
        var listeLayerWaypoint = [];
        $.each(dataP, function (i, way) {
            let type = way.type;
            let xy = way.coordonnees.split(',');
            let latitude = xy[1];
            longitude = xy[0]; /*inversion parce qu'on est con sur la base de données*/
            let nomWaypoint = way.idWaypoint;

            switch (type) {
                case 'circuit':
                    couleur = couleurcir;
                    break;
                case 'pisteArrivee':
                    couleur = couleurpistA;
                    break;
                case 'pisteDepart':
                    couleur = couleurpistD;
                    break;
                case 'taxiway':
                    couleur = couleurtax;
                    break;
                default:
                    console.log(`Sorry, we are out of color`);
            }

            listeLayerWaypoint[i] = draw_markerWaypoint(latitude, longitude, nomWaypoint, couleur);
            /*Ajout sur principe du pacman*/
            map.addLayer(listeLayerWaypoint[i]); // affichage sur la carte des markers
            listeLayerWaypoint[i].getStyle()[0].getImage().setRotation(rotation); // rotation en radian


            $('button').on('click', function () { // click sur bouton "en route"
                let stepMarker = 100;
            });

        });
    }, 'json');


    /* FIN Waypoint */

    /* DEBUT Avion */

    var routeArrivee = [
        [139.84302, 35.55940],
        [139.80383, 35.52428],
        [139.80143, 35.52579],
        [139.80679, 35.53006],
        [139.80132, 35.53793],
        [139.79304, 35.54988]];


    $.post("/getPlane", "", function (dataA) {

        var rotation = 0.0
        var listeAvion = [];
        $.each(dataA, function (i, avion) {
            let nomMarker = "FSEXE";
            // let xy = avion.coordonnees.split(',');
            let echelle = 0.03;
            // let latitude = xy[1]; longitude = xy[0]; /*inversion parce qu'on est con sur la base de données*/


            listeAvion[i] = draw_marker(nomMarker, 139.84302, 35.55940, avion.images, echelle);
            // map.addLayer(listeAvion[i]); // affichage sur la carte des markers
            listeAvion[i].getStyle()[0].getImage().setRotation(rotation); // rotation en radian


            /*let Avion2=listeAvion[1];*/
            let Avion3 = listeAvion[2];


            $('button#depart').on('click', function () { // click sur bouton "en route"
                let stepMarker = 100;
                alert(listeAvion);
                map.addLayer(listeAvion[0]);
                let routeArr = new ol.geom.LineString(routeArrivee);
                var callb = function () { // function de callback
                    /*map.removeLayer(Avion3); // suppression du layer Homme Décollage/Atterrissage
                     insertFlightPlan(3);*/
                };

                /*var callb = function () { // function de callback
                    map.removeLayer(HomPark); // suppression du layer Homme Parking
                    insertRepasBDD(2);
                    let lineR = new ol.geom.LineString(lineRouge);  // formatage de la ligne
                    move_marker(Avion1, lineR, stepMarker, callb1);  //déplacement de l'avion 1 vers parking
                };
                */
                move_marker(listeAvion[0], routeArr, stepMarker, callb);//déplacement du l'avion 1 vers la piste de décollage ou atterrissage
            });

        });
    }, 'json');


    /* FIN Avion */


    //tooltip sur chacun des layers
    var tooltip = document.getElementById('tooltip');
    var overlay = new ol.Overlay({
        element: tooltip,
        offset: [10, 0],
        positioning: 'bottom-left'
    });
    map.addOverlay(overlay);

    map.on('pointermove', function(evt){
        displayTooltip(evt, overlay, map);
    });
    


    /* DEBUT BOUTONS */

    updatePlaneFront();
    updateButtonFront();

    $('#solution-button').on('click', function () { // click sur bouton "en route"
        updateParkingSolutionFront();
    });

    $(".parking-button").on('click', function (data) {
        assignParking($("#plane").text(), $(this).text());
    });

    /* FIN BOUTONS */

    function insertFlightPlan(idAvion) {
        $.post("/flightplan", {idLayer: idAvion}, function (data) {
            console.log(data);
        });

    }
});

/*alert(getAvion())*/

