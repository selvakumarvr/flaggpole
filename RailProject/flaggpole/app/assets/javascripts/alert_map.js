var map;
//var layer;
var tableid = '0IMZAFCwR-t7jZnVzaW9udGFibGVzOjIxMDIxNw';

function initMap(geo_ids) {
  map = new google.maps.Map(document.getElementById('map_canvas'), {
    center: new google.maps.LatLng(0, 0),
    zoom: 15,
    mapTypeId: google.maps.MapTypeId.ROADMAP,
    disableDoubleClickZoom: true,
    draggable: false,
    scrollwheel: false,
    panControl: false,
    zoomControl: false
  });
  
  //layer = new google.maps.FusionTablesLayer(tableid);
  var query = countyQuery(geo_ids);
  //layer.setQuery(query);
  //layer.setMap(map);

  zoom2query(query);
}

function countyQuery(geo_ids)
{
  return "SELECT geometry FROM " + tableid + " WHERE GEO_ID IN(" + wrap_quotes(geo_ids).join(',') + ")";
}

function wrap_quotes(ary) {
  for(var i=0; i<ary.length; i++) {
    ary[i] = "'" + ary[i] + "'";
  }
  return ary;
}

function zoom2query(query) {
  // zoom and center map on query results
  var queryText = encodeURIComponent(query);
  var query = new google.visualization.Query('http://www.google.com/fusiontables/gvizdata?tq='  + queryText);

  // set the callback function
  query.send(polygonQueryCallback);
}

function polygonQueryCallback(response) {
  if (!response) {
    alert('no response');
    return;
  }
  if (response.isError()) {
    alert('Error in query: ' + response.getMessage() + ' ' + response.getDetailedMessage());
    return;
  }

  // for more information on the response object, see the documentation
  // http://code.google.com/apis/visualization/documentation/reference.html#QueryResponse
  var numRows = response.getDataTable().getNumberOfRows();
  var polygons = getPolygons(response);
  // add polygons to map
  for(var i=0; i<numRows; i++) {
    //polygons[i].setMap(null);
    polygons[i].setMap(map);
  }

  // find the bounds for all polygons
  var bounds = getBoundsPolygons(polygons);
  // zoom to the bounds
  map.fitBounds(bounds);
}

function getPolygons(response) {
  var numRows = response.getDataTable().getNumberOfRows();
  var polygons = [];
  for(var i=0; i<numRows; i++) {
    // create a geoXml3 parser
    var geoXml = new geoXML3.parser({
      map: map,
      zoom: false
    });

    var kml =  response.getDataTable().getValue(i,0);
    geoXml.parseKmlString("<Placemark>"+kml+"</Placemark>");
    var polygon = geoXml.docs[0].gpolygons[0];
    polygons.push(polygon);
  }
  return polygons;
}

function getBoundsPolygons(polygons) {
  var bounds = new google.maps.LatLngBounds();
  for(i = 0; i < polygons.length; i++) {
      // var point = new google.maps.LatLng(
      //     parseFloat(response.getDataTable().getValue(i, 0)),
      //     parseFloat(response.getDataTable().getValue(i, 1)));
      //bounds.extend(point);

      bounds.extend(polygons[i].bounds.getSouthWest());
      bounds.extend(polygons[i].bounds.getNorthEast());
  }
  return bounds;
}
