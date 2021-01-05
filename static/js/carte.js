$(document).ready(function (){

    //affiche de la carte dur l'ENAC
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

     //Affichage des waypoints bleus
    let coordWaypoint=[ [43.56520767508311, 1.4793492845952274],
                        [43.56396382024834, 1.4806045583782506],
                        [43.56499000234101, 1.4824928334706613],
                        [43.56532428515708, 1.4821709683980915],
                        [43.56413485181106, 1.4834047845096097]];

    let Way=Array();
    let i=0;
    $.each(coordWaypoint, function(index, value){
        let latitude = value[0];
        let longitude = value [1];
        Way[i]=draw_markerWaypoint(latitude, longitude,"WB"+index , "blue");
        map.addLayer(Way[i]); // affichage sur la carte des markers
        i++;
    });

    // trajectoire vers le fantôme bleu
    let lineBleue=[
        [1.4793492845952274, 43.56520767508311],
        [1.4806045583782506, 43.56396382024834],
        [1.4824928334706613, 43.56499000234101],
        [1.4821709683980915, 43.56532428515708],
        [1.4818169168182642, 43.5658218189366]];

    // trajectoire vers le fantôme rouge depuis position du fantôme bleu
    let lineRouge=[
        [1.4818169168182642, 43.5658218189366],
        [1.4821709683980915, 43.56532428515708],
        [1.4824928334706613, 43.56499000234101],
        [1.4838983109542172, 43.56369172357968]];


     //Affichage du pacman et des fantômes

    $.post("/getPacman","", function (data)
    {

        //alert(JSON.stringify(data));
        let newLayer=Array();
        $.each(data, function(index, lay) {
            let xy = lay.coord.split(','); // separation par la virgule
            let latitude = parseFloat(xy[1]);
            let longitude = parseFloat(xy[0]);
            let nomMarker = lay.nomLayer;
            let imageMarker = lay.image;
            let echelleMarker = parseFloat(lay.echelle);
            let rotationMarker = parseFloat(lay.rotation);

            newLayer[index] = draw_marker(nomMarker, longitude, latitude, imageMarker, echelleMarker);
            map.addLayer(newLayer[index]); // affichage sur la carte des markers
            newLayer[index].getStyle()[0].getImage().setRotation(rotationMarker); // rotation en radian

            let pacman=newLayer[0];
            let fantomeB=newLayer[1];
            let fantomeR=newLayer[2];



    $('button').on('click', function (){ // click sur bouton "en route"
        let stepMarker = 100;

            let lineB = new ol.geom.LineString(lineBleue); // formatage de la ligne
             var callb1 = function () { // function de callback
                map.removeLayer(fantomeR); // suppression du layer fantomeR
                 insertRepasBDD(3);
            };

            var callb = function () { // function de callback
                map.removeLayer(fantomeB); // suppression du layer fantomeB
                insertRepasBDD(2);
                let lineR = new ol.geom.LineString(lineRouge);  // formatage de la ligne
                move_marker(pacman, lineR, stepMarker, callb1);  //déplacement du pacman vers fontomeR
            };
            move_marker(pacman, lineB, stepMarker, callb);//déplacement du pacman vers fontomeB

    });

    });
    },'json');

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




    $.post("/vigie","", function (get_parkingData)
        {
            var listeLayerParking=[];
            $.each(dataP,function (i,park){
                let xy = park.coordonnées.split(',');
                let latitude = xy[0]; longitude = xy[1];
                let nomParking = park.idParking;
                listeLayerParking[i]=draw_markerParking(latitude, longitude,nomParking,couleurParking,rotation,map);
            });


    },'json');


});


function insertRepasBDD(idFantome)
{
     $.post("/repas",{idLayer:idFantome}, function (data) {
         console.log(data);
     });

}

