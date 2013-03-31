# To force HTTPS
MarkerClusterer.prototype.MARKER_CLUSTER_IMAGE_PATH_ =
    'https://google-maps-utility-library-v3.googlecode.com/svn/trunk/markerclusterer/' +
    'images/m';

jQuery(document).ready ($) ->
  map = new google.maps.Map $('#map')[0],
    mapTypeId: google.maps.MapTypeId.ROADMAP
  geocoder = new google.maps.Geocoder()
  geocoder.geocode address: 'United States of America', (results, status) -> 
    map.fitBounds results[0].geometry.viewport
  clusterer = new MarkerClusterer map, [], maxZoom: 10
  for subscriber in subscribers
    do (subscriber) ->
      marker = new google.maps.Marker
        position: new google.maps.LatLng(subscriber['LATITUDE'], subscriber['LONGITUDE'])
      delete subscriber['LATITUDE']; delete subscriber['LONGITUDE']
      html = $.map subscriber, (value, key) -> "<tr><th><span>#{key}</span></th><td>#{value}</td></tr>"
      html = "<table class=\"subscriber\">#{html.join('')}</table>"
      win = new google.maps.InfoWindow content: html
      google.maps.event.addListener marker, 'click', -> win.open map, marker
      clusterer.addMarker marker
