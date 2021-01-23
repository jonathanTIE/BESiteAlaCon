$(document).ready(function () {

    /* debut fonctions */
    /* debut interface affectation parking */

    function updateParkingSolutionFront() {
        var parkings = [];
        var category = $("#plane").attr("categorie");
        console.log(category);
        $.post("/getParkingLibre", {qtPark: 3, category:category}, function (data) {
            $.each(data, function (i, park) {
                parkings[i] = park.idParking;
            });
            for (i = 0; i < 3; i++) {
                $("#parking-" + i.toString()).text(parkings[i]);

            }
            $("#plane").attr("nbParkings", parkings.length);
            updateButtonFront();
        }, 'json')


        return parkings;
    }

    function updatePlaneFront(callback) //return list of all planes from view if needed
    {
                let planes = [];
        $.post("/getAvionLibre", "", function (data) {

            /* array from database data */
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
                $("#plane").text(planes[0][1])
                    .attr('categorie', planes[0][2]);
                   console.log("fin update category");
            } else {
                $("#plane").text("PLUS D'AVION !");
            }
            callback();


        }, 'json');
            return planes;




    }

    function updateButtonFront() {
        console.log(parseInt($("#plane").attr("nbParkings"),10));
        if (parseInt($("#plane").attr("nbParkings"),10) === 0) {
            $('#solution-button').text("Recalculer");
        } else {
            $('#solution-button').text("Refuser");
        }
    }

    function getPlaneParkingPair()
    {
        //update parking (with right category) from plane immatriculation
        updatePlaneFront(updateParkingSolutionFront);
        //$.when(updatePlaneFront()).then(updateParkingSolutionFront())
        //.then(updateButtonFront(0));
    }

    function assignParking(plane, parking) {
        $.post("/assignerAvion", {plane: plane, parking: parking}, function (isExecuted) {
            console.log("plane");
            console.log(plane);
            //getPathLanding(plane.spawn, parking, movePlane) //movePlane est une fonction qui prend comme param routearrivee
            getPlaneParkingPair();
            console.log("parking assigné & front end updaté !");


        });
    }
    /* fin interface affectation parking */
    /* debut mouvement et obtention coordonnes avion */
    function getPathCoords(path) //path is an array of waypoints in str form
    {
      return new Promise(function(resolve, reject) {
        let coords = [];
        $.post("/getCoordsGPS", {'path':path}, function (data) {
            $.each(data, function (i, item) {
                coords.push(
                    $.map(item.coordonnees.split(","), function(value) {
                        return parseFloat(+value, 10);
                    })
                );
            });
            resolve(coords)
        },'json');
    });
    }

    function getPathLanding(waypoint="C1", parking="P1", callback=function(){})
    {
        return new Promise(function(resolve, reject) {
            $.post("/getPathWaypoints", {waypoint: waypoint}, function (data) {
                let pathToTerminal = data.Path;
                let terminalWaypoint = "erreur SQL";

                $.post("/getParkingTerminalWaypoint", {parking: parking}, async function (data) {
                    terminalWaypoint = data.waypointProche;
                    let pathStr = waypoint + "-" + pathToTerminal + "-" + terminalWaypoint + "-" + parking; //resultat DB + parking waypoint + parking
                    path = pathStr.split("-");
                    let coords = await getPathCoords(path);
                    resolve(coords);
                }, 'json')
            }, 'json');

        });
    }


    function getPathDeparture(parking, runway=NaN)
    {
        return new Promise(function(resolve, reject) {
            $.post("/getPathWaypoints", {waypoint:runway}, function (data) {
                let pathToRunway = data.Path;
                let terminalWaypoint = "erreur SQL";

                $.post("/getParkingTerminalWaypoint", {parking: parking}, async function (data) {
                    terminalWaypoint = data.waypointProche;
                    let pathStr = parking + "-" + terminalWaypoint + "-" + pathToRunway; //resultat DB + parking waypoint + parking
                    path = pathStr.split("-");
                    let coords = await getPathCoords(path);
                    resolve(coords);
                }, 'json')
            },'json');
    });
    }
    function getFullPlanePath(plane, parking)
    {
        let spawn = "C1";//plane.waypoint;
        let despawn = "05";//parking.runway;
        $.when(getPathLanding(spawn, "P3"),//parking.idParking)
        getPathDeparture("P3", "05")).done(function(pathLand, pathDep)
        {
            console.log(pathLand);
            console.log(pathDep);
        });

    }
    getFullPlanePath("a","a");
    /* fin mouvement et obtention coordonnes avion */

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



    /*DEBUT Parking*/

    $.post("/getParking", "", function (dataP) {
        var couleurOcc = "#D9521A"
        var rotation = 0.0
        var listeLayerParking = [];
            $.each(dataP, function (i, park) {
            let xy = park.coordonnees.split(',');
            let latitude = xy[1];
            longitude = xy[0]; /*inversion parce qu'on est con sur la base de données*/
            let nomParking = park.idParking;
            listeLayerParking[i] = draw_markerParking(latitude, longitude, nomParking, couleurOcc, rotation, map);
            map.addLayer(listeLayerParking[i]); // affichage sur la carte des markers

            $.post("/getParkingLibre", {qtPark: 3, category:'C'}, function (dataPF)
                {
                        changeCouleurParking(nomParking,"#0FD757",listeLayerParking) //Parking Free Classe C/B/A
                        //map.addLayer(listeLayerParking[i]); // affichage sur la carte des markers
                }, 'json')

            $.post("/getParkingLibre", {qtPark: 3, category:'B'}, function (dataPF)
                {
                        changeCouleurParking(nomParking,"#0FD7EB",listeLayerParking) //Parking Free Classe B/A
                        //map.addLayer(listeLayerParking[i]); // affichage sur la carte des markers
                }, 'json')

            $.post("/getParkingLibre", {qtPark: 3, category:'A'}, function (dataPF)
                {
                        changeCouleurParking(nomParking,"#F9F539",listeLayerParking) //Parking Free Classe A
                        //map.addLayer(listeLayerParking[i]); // affichage sur la carte des markers
                }, 'json')

            listeLayerParking[i].getStyle()[0].getImage().setRotation(rotation); // rotation en radian


            $('button').on('click', function () { // click sur bouton "en route"
                let stepMarker = 100;
            });
        });

    }, 'json');



        // var couleurFreeC= "#0FD757" -C
        // var couleurFreeB= "#0FD7EB" -B
        // var couleurFreeA= "#F9F539" -A




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


    /*Avion Arrivée*/

    var routeArrivee = [
        [139.84302, 35.55940],
        [139.82198, 35.54049],
        [139.80383, 35.52428],
        [139.80143, 35.52579],
        [139.80556, 35.52920],
        [139.80679, 35.53006],
        [139.80132, 35.53793],
        [139.79304, 35.54988]];

    $.post("/getPlane", "", function (dataA) {

        var listeAvion = [];
        $.each(dataA, function (i, avion) {
            let nomMarker = avion.immatAvion;
            let echelle = 0.03;


            listeAvion[i] = draw_marker(nomMarker, 139.84302, 35.55940, avion.images, echelle);



            let Avion3 = listeAvion[2];


            $('button#approach').on('click', function () { // click sur bouton "en route"
                let stepMarker = 100;
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
                //fonction qui execute l'arrivée(fonctionDeSupression)

                */
                move_marker(listeAvion[0], routeArr, stepMarker, callb);//déplacement du l'avion 1 vers la piste de décollage ou atterrissage
            });

        });
    }, 'json');

        /*Avion Départ*/


    var routeDepart = [
        [139.79304, 35.54988],
        [139.80132, 35.53793],
        [139.80679, 35.53006],
        [139.80556, 35.52920],
        [139.80143, 35.52579],
        [139.80383, 35.52428],
        [139.82198, 35.54049],
        [139.84302, 35.55940]];

    $.post("/getPlane", "", function (dataA) {

        var listeAvion = [];
        console.log("get plane");
        console.log(dataA);
        $.each(dataA, function (i, avion) {
            let nomMarker = avion.immatAvion;

            let echelle = 0.03;


            listeAvion[i] = draw_marker(nomMarker, 139.84302, 35.55940, avion.images, echelle);



            let Avion3 = listeAvion[2];


            $('button#depart').on('click', function () { // click sur bouton "en route"
                let stepMarker = 100;
                map.addLayer(listeAvion[0]);
                let routeDep = new ol.geom.LineString(routeDepart);
                var callb1 = function () { // function de callback
                };

                var callb = function () { // function de callback
                    map.removeLayer(listeAvion[i]); // suppression du layer de l'avion
                };
                move_marker(listeAvion[0], routeDep, stepMarker, callb);//déplacement de l'avion hors du champ de vision donc disparition
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
    getPlaneParkingPair();
    //updatePlaneFront();

    $('#solution-button').on('click', function () { // click sur bouton 'recalculer/refuser'
        updateParkingSolutionFront();
    });

    $(".parking-button").on('click', function (data) {
        assignParking($("#plane").text(), $(this).text());
        //
    });

    /* FIN BOUTONS */

    function insertFlightPlan(idAvion) {
        $.post("/flightplan", {idLayer: idAvion}, function (data) {
            console.log(data);
        });

    }




    /* Graphique Statistiques*/
    $.post('/getChart',{},function(donnees)
    {
        let labelsC = donnees.map(function (e)
        {
            return "Parking"+e.x
        });

        let dataC = donnees.map(function (e)
        {
            return e.y
        });


        var ctx = document.getElementById('myChart').getContext('2d');
        var myChart = new Chart(ctx, {
            type: 'bar',
            data: {
                labels: labelsC, //dataC.label (x)
                datasets: [{
                    label: "Taux d'occupation des parkings",
                    data: dataC, //dataC.data (y)
                    backgroundColor: [
                        'rgba(255, 99, 132, 0.2)',
                        'rgba(54, 162, 235, 0.2)',
                        'rgba(255, 206, 86, 0.2)',
                        'rgba(75, 192, 192, 0.2)',
                        'rgba(153, 102, 255, 0.2)',
                        'rgba(255, 159, 64, 0.2)'
                    ],
                    borderColor: [
                        'rgba(255, 99, 132, 1)',
                        'rgba(54, 162, 235, 1)',
                        'rgba(255, 206, 86, 1)',
                        'rgba(75, 192, 192, 1)',
                        'rgba(153, 102, 255, 1)',
                        'rgba(255, 159, 64, 1)'
                    ],
                    borderWidth: 1
                }]
            },
            options: {
                scales: {
                    yAxes: [{
                        ticks: {
                            beginAtZero: true
                        }
                    }]
                }
            }
        });
    },'json');



});


/*alert(getAvion())*/

/*
Parcours test::
Parking :
    P3
Parking Nord 3       [139.78786, 35.55411],
Wayppint proche :
T1 :
Prévoir un waypoint en plus pour pour la sorti des parkings. Coordonnées possibles :
[35.5545813706495, 139.79057567546323] devant le point T1
[35.552780402431665, 139.7919959993632] devant le point T2
[35.5509169303004, 139.7933907318415] devant le point T3

[35.54766161885484, 139.79555994293432]
[35.54653828179949, 139.7929574565983]

Taxiway :
A4 : [139.80004, 35.53732]
A5 : [139.80556, 35.52920]
A6 : [139.80143, 35.52579]


Piste de décollage :
DEP1 : [139.80376, 35.52421]

Circuit de départ :
DEP 2 : [139.84302, 35.55940]


 */