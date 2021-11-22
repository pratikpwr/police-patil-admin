import 'dart:html';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:google_maps/google_maps.dart';
import 'package:ppadmin/src/config/constants.dart';

class MultiMapsWidget extends StatefulWidget {
  const MultiMapsWidget({Key? key, required this.id, required this.locations})
      : super(key: key);
  final String id;
  final List<LatLng> locations;

  @override
  State<MultiMapsWidget> createState() => _MultiMapsWidgetState();
}

class _MultiMapsWidgetState extends State<MultiMapsWidget> {
  @override
  Widget build(BuildContext context) {
    String htmlId = widget.id;

    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(htmlId, (int viewId) {
      final myLatLng = LatLng(18.5204, 73.8567);
      final puneLatLong = LatLng(18.5204, 73.8567);
      final mapOptions = MapOptions()
        ..zoom = 10
        ..center = puneLatLong;

      final elem = DivElement()
        ..id = htmlId
        ..style.width = "100%"
        ..style.height = "100%"
        ..style.border = 'none';

      final map = GMap(elem, mapOptions);

      // Code to create multiple markers
      for (int i = 0; i < widget.locations.length; i++) {
        Marker(MarkerOptions()
          ..position = widget.locations[i]
          ..map = map
          ..title = CRIMES);
      }

      Marker(MarkerOptions()
        ..position = puneLatLong
        ..map = map
        ..title = CRIMES);

      return elem;
    });

    return Container(
        padding: const EdgeInsets.all(8),
        height: MediaQuery.of(context).size.height * 0.8,
        width: double.infinity,
        child: HtmlElementView(viewType: htmlId));
  }
}
