$(document).ready(function () {


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



    /* debut fonctions */


    /* debut interface affectation parking */

    function updateParkingSolutionFront() {
        var parkings = [];
        var category = $("#plane").attr("categorie");
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
            } else {
                $("#plane").text("PLUS D'AVION !");
            }
            callback();


        }, 'json');
            return planes;




    }

    function updateButtonFront() {
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

    function updateDepartureTime(planeImmat)
    {
        $.post("/departAvion", {planeImmat:planeImmat}, function (data) {
            },'json');
    }
    function deplacerAvion(routeArrivee, routeDepart,immatAvion,images, cbk= function(){})
    {
    //Avion Approche
        let nomMarker = immatAvion;
        let echelle = 0.03;
        let max = 90000;
        let min = 15000; //Temps d'atterrissage jusqu'au départ entre 15s et 90s

        var AjustAvion = draw_marker(nomMarker, 139.84302, 35.55940, images, echelle);


        // let Avion3 = listeAvion[2];

        let stepMarker = 100;
        map.addLayer(AjustAvion);
        let routeArr = new ol.geom.LineString(routeArrivee);
        var callb = function () { // function de callback
        };
        console.log("pre move maker");
        console.log(AjustAvion);
        move_marker(AjustAvion, routeArr, stepMarker, callb);//déplacement du l'avion 1 vers la piste de décollage ou atterrissage

        setTimeout(
            function()
            {
                let routeDep = new ol.geom.LineString(routeDepart);
                var callb2 = function () { // function de callback
                    map.removeLayer(AjustAvion); // suppression du layer de l'avion
                };
            move_marker(AjustAvion, routeDep, stepMarker, callb2);//déplacement de l'avion hors du champ de vision donc disparition
            cbk(immatAvion)
            }, Math.floor(Math.random()*(max-min)+min));



    }

    async function getPlanePic (planeID)
    {
        return new Promise(function(resolve, reject) {
            $.post("/getPlaneData", {immat: planeID}, function (planeInfo) {
                resolve(planeInfo['images']);
            });
        });
    }

    async function assignParking(planeId, parking) {
        $.post("/assignerAvion", {plane: planeId, parking: parking}, function (insertionStatus) {
            let spawn =  "C1";//plane.waypoint; $("#approach").text() ||
            let despawn = "05";//parking.runway;
            console.log(spawn);
            $.when(getPathLanding(spawn, parking),//parking.idParking)
            getPathDeparture(parking, despawn),
            getPlanePic(planeId))
                .done(function(pathLand, pathDep, planePic)
                {
                    console.log(planeId);
                    console.log(pathLand);
                    console.log(pathDep);
                    console.log(planePic);
                    //TODO : si probléme dans l'update, mettre getPlaneParkingPair ici
                    deplacerAvion(pathLand, pathDep, planeId, planePic, updateDepartureTime);
                    color_parkings();
                });
                //color_parkings();
                //changeCouleurParking(parking, "#D9521A", map.getLayers());
                getPlaneParkingPair();
                console.log("parking assigné & front end updaté !");
        });
    }
    /* fin mouvement et obtention coordonnes avion */

    var listeLayerParking = []; //global variable
    /* fin fonctions */
    $.post("/getParking", "", function (dataP) {
        console.log(dataP);
        var couleurOcc = "#D9521A"
        var rotation = 0.0
            $.each(dataP, function (i, park) {
                let xy = park.coordonnees.split(',');
                let latitude = xy[1];
                longitude = xy[0]; /*inversion parce qu'on est con sur la base de données*/
                let nomParking = park.idParking;
                listeLayerParking[i] = draw_markerParking(latitude, longitude, nomParking, couleurOcc, rotation, map);
                map.addLayer(listeLayerParking[i]); // affichage sur la carte des markers
                listeLayerParking[i].getStyle()[0].getImage().setRotation(rotation); // rotation en radian
    });
    }, 'json');

    /*DEBUT Parking*/
    function color_parkings()
    {
            function OrderParkingA() {
                $.post("/getParkingLibre", {qtPark: 100, category: 'A'}, function (dataAF) {
                    $.each(dataAF, function (i,park) {
                        let nomParking = park.idParking;
                        changeCouleurParking(nomParking, "#F9F539", listeLayerParking); //Parking Free Classe C/B/A
                    });
                    }, 'json');
                }

            function OrderParkingB_A() {
                $.post("/getParkingLibre", {qtPark: 100, category: 'B'}, function (dataAF) {
                    $.each(dataAF, function (i,park) {
                        let nomParking = park.idParking;
                        changeCouleurParking(nomParking, "#0FD7EB", listeLayerParking); //Parking Free Classe C/B/A
                    });
                    OrderParkingA();
                    }, 'json');
            }

            function OrderParkingC_B_A() {

                $.post("/getParkingLibre", {qtPark: 100, category: 'C'}, function (dataAF) {
                    console.log(dataAF);
                    $.each(dataAF, function (i,park) {
                        let nomParking = park.idParking;
                        changeCouleurParking(nomParking, "#0FD757", listeLayerParking); //Parking Free Classe C/B/A
                    });
                    OrderParkingB_A();
                    }, 'json');
            }

            function OrderParking_All() {

                $.post("/getParking", {qtPark: 100, category: 'C'}, function (dataAF) {
                    console.log(dataAF);
                    $.each(dataAF, function (i,park) {
                        let nomParking = park.idParking;
                        changeCouleurParking(nomParking, "#D9521A", listeLayerParking); //Parking Free Classe C/B/A
                    });
                    OrderParkingC_B_A();
                    }, 'json');
            }
            OrderParking_All();


    }
color_parkings();




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