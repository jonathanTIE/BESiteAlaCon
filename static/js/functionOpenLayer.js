function draw_marker(nomMarker, longitude, latitude, imageMarker, echelle)
{

        /* coordonnées longitude, latitude du marker */
        let coord = [parseFloat(longitude), parseFloat(latitude)];

        /* création du marker */

        let layerMarker = new ol.layer.Vector({
            source: new ol.source.Vector({
                features: [new ol.Feature(
                    {
                        type:"Point",
                        desc: nomMarker,
                        geometry: new ol.geom.Point(ol.proj.fromLonLat(coord))

                    })
                ] // marker en forme de point
            }),
            style: [new ol.style.Style({ // style du marker
                image: new ol.style.Icon({
                    rotation: 0,
                    //crossOrigin: 'anonimymous',
                    src : '../static/images/'+imageMarker,
                    scale: echelle,
                })
            })]
        });

        layerMarker.set('name', nomMarker);
        return layerMarker;
}


function draw_markerWaypoint(latitude, longitude,nomWaypoint, couleur)
{

        // coordonnées longitude, latitude du marker
        let coord = [parseFloat(longitude), parseFloat(latitude)];

        // création du marker

        let layerWaypoint = new ol.layer.Vector({
            source: new ol.source.Vector({
                features: [new ol.Feature(
                    {
                        type:"Point",
                        desc: nomWaypoint,
                        geometry: new ol.geom.Point(ol.proj.fromLonLat(coord))

                    })
                ] // marker en forme de point
            }),
            style: [new ol.style.Style({ // style du marker
                image: new ol.style.Circle({
                    radius: 5,
                    fill: new ol.style.Fill({color: couleur}), // couleur interieur du cercle
                    stroke: new ol.style.Stroke({color: couleur, width: 1}) // couleur bordure du cercle
                })
            })]
        });


        layerWaypoint.set('name', nomWaypoint);

        return layerWaypoint;

}
function draw_markerParking(latitude, longitude,nomParking, couleur, rotation, map)
{

        // coordonnées longitude, latitude du marker
        let coord = [parseFloat(longitude), parseFloat(latitude)];

        // création du marker

        let layerWaypoint = new ol.layer.Vector({
            source: new ol.source.Vector({
                features: [new ol.Feature(
                    {
                        type:"Point",
                        desc: nomParking,
                        geometry: new ol.geom.Point(ol.proj.fromLonLat(coord))

                    })
                ] // marker en forme de point
            }),
            style: [new ol.style.Style({ // style du marker
                image: new ol.style.RegularShape({
                    radius: 16,
                    points: 4,
                    angle: rotation,
                    fill: new ol.style.Fill({color: couleur}), // couleur interieur du cercle
                    stroke: new ol.style.Stroke({color: "black", width: 1}) // couleur bordure du cercle
                }),
                text: new ol.style.Text({
                text:nomParking,
                textBaseline: 'center',
                font: '14px Calibri,sans-serif',
                fill: new ol.style.Fill({ color: '#000' }),
                stroke: new ol.style.Stroke({ color: '#fff', width: 2 })
                })
            })]
        });


        layerWaypoint.set('name', nomParking);

        return layerWaypoint;

}


function move_marker(marker, line, stepMarker, callb)
{
    //let init=line.getCoordinateAt(0);
    var features=marker.getSource().getFeatures();
    var featureToUpdate=features[0];

    var step = 0;
    var key = setInterval( function() { // la fonction suivante s'execute toutes les 70ms
    if (step < stepMarker)
    {
        step++;
        let coord = line.getCoordinateAt(step/stepMarker); // retourne les coordonnées géographiques sur un point de la trajectoire
        let newPoint=new ol.geom.Point(ol.proj.fromLonLat(coord)); // formatage des coordonnées géographiques
        // calculeAngle()
        featureToUpdate.setGeometry(newPoint); // deplacement du marker
        // marker.getStyle()[0].getImage().setRotation(angle);

    } else {
        clearInterval(key); // fin du déplacement
        callb(); // fonction de callback à executer après le déplacement
        }

    }, 70);
}




function displayTooltip(evt, overlay, map) {
    var pixel = evt.pixel;
    var feature = map.forEachFeatureAtPixel(pixel, function(feature) {
        return feature;
    });
    tooltip.style.display = feature ? '' : 'none';
    if (feature && feature.get('type') === 'Point') {  //uniquement pour les marker de type Point
        overlay.setPosition(evt.coordinate);
        tooltip.innerHTML = feature.get('desc'); //Affichage de la description du marker
    }
}

function radians_to_degrees(radians)
{
  var pi = Math.PI;
  return radians * (180/pi);
}

function calculeAngle(long1,long2,lat1,lat2) {
     Long = (long2 - long1);

     y = Math.sin(Long) * Math.cos(lat2);
     x = Math.cos(lat1) * Math.sin(lat2) - Math.sin(lat1)* Math.cos(lat2) * Math.cos(Long);

     brng = Math.atan2(y, x);

    brng = radians_to_degrees(brng);
    brng = (brng + 360) % 360;
    brng = 360 - brng; // calculer les degrées dans le sens inverse des aiguilles d'une montre (enlever pour faire dans le sens ordinaire)
    alert(brng);
    return brng;
}


function assignPlane()
{
    //dans la table asso_avionParking, mettre le champ dateDepart à NULL.
}
