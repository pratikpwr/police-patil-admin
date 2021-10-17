import 'dart:html';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:google_maps/google_maps.dart';
import 'package:ppadmin/src/config/constants.dart';

class GoogleMapsWidget extends StatefulWidget {
  const GoogleMapsWidget(
      {Key? key, required this.id, required this.lat, required this.long})
      : super(key: key);
  final String id;
  final double lat;
  final double long;

  @override
  State<GoogleMapsWidget> createState() => _GoogleMapsWidgetState();
}

class _GoogleMapsWidgetState extends State<GoogleMapsWidget> {
  @override
  Widget build(BuildContext context) {
    String htmlId = widget.id;

    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(htmlId, (int viewId) {
      final myLatlng = LatLng(widget.lat, widget.long);

      final mapOptions = MapOptions()
        ..zoom = 10
        ..center = LatLng(widget.lat, widget.long);

      final elem = DivElement()
        ..id = htmlId
        ..style.width = "100%"
        ..style.height = "100%"
        ..style.border = 'none';

      final map = GMap(elem, mapOptions);

      Marker(MarkerOptions()
        ..position = myLatlng
        ..map = map
        ..title = CRIMES);

      return elem;
    });

    return Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: Colors.grey[200], borderRadius: BorderRadius.circular(15)),
        child: HtmlElementView(viewType: htmlId));
  }
}
