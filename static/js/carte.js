$(document).ready(function (){

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


    var listeLayerParking=[];
    $.each(dataP,function (i,park) {
        let xy = park.coordonnees.split(',');
        let latitude = xy[0];
        longitude = xy[1];
        let nomParking = park.idParking;
        listeLayerParking[i] = draw_markerParking(latitude, longitude, nomParking, couleurParking, rotation, map);
    });




     //Affichage piste 05 (EN cycle LTO):
    let coordWaypoint=[ [35.50289,139.78066],
                        [35.52428,139.80383],
                        [35.54049,139.82198,],
                        [35.54157,139.82050],
                        [139.80679, 35.53006],
                        [139.80132, 35.53793],
                        [139.80004, 35.53732],
                        [139.80556, 35.52920],
                        [139.80143, 35.52579],
                        [139.84302, 35.55940]];

    let Way=Array();
    let i=0;
    $.each(coordWaypoint, function(index, value){
        let latitude = value[0];
        let longitude = value [1];
        Way[i]=draw_markerWaypoint(latitude, longitude,"WB"+index , "blue");
        map.addLayer(Way[i]); // affichage sur la carte des markers
        i++;
    });

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

    $.post("/getParking","", function (data)
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

            let Avion1=newLayer[0];    //Pacman
            let HomPark=newLayer[1];   //fantomeB
            let HomDecAtt=newLayer[2];   //fantomeR



    $('button').on('click', function (){ // click sur bouton "en route"
        let stepMarker = 100;

            let lineB = new ol.geom.LineString(lineBleue); // formatage de la ligne
             var callb1 = function () { // function de callback
                map.removeLayer(HomDecAtt); // suppression du layer fantomeR
                 insertRepasBDD(3);
            };

            var callb = function () { // function de callback
                map.removeLayer(HomPark); // suppression du layer fantomeB
                insertRepasBDD(2);
                let lineR = new ol.geom.LineString(lineRouge);  // formatage de la ligne
                move_marker(Avion1, lineR, stepMarker, callb1);  //déplacement du pacman vers fontomeR
            };
            move_marker(Avion1, lineB, stepMarker, callb);//déplacement du pacman vers fontomeB

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


});

let tableau=[];
tableau[1]=idAvion;
tableau[2]=immatAvion;
tableau[3]=categorie;


function getAion()
{
    return tableau
}


function getParkingSolution()
{
    $.post("/getParkingSolution","", function (data)
    {
        /*data.idParking*/
        /* Appeler des fonctions d'interface*/

    },'json');

 }

function insertRepasBDD(idFantome)
{
     $.post("/repas",{idLayer:idFantome}, function (data) {
         console.log(data);
     });

}

