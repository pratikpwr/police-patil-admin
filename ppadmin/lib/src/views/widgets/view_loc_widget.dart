import 'package:flutter/material.dart';
import 'package:ppadmin/src/views/views.dart';

class ViewLocWidget extends StatelessWidget {
  const ViewLocWidget(
      {Key? key, required this.id, required this.lat, required this.long})
      : super(key: key);
  final String id;
  final double lat;
  final double long;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(
        Icons.location_on_rounded,
        size: 24,
        color: Colors.redAccent,
      ),
      onPressed: () {
        showDialog(
            context: context,
            builder: (context) {
              return Dialog(
                child: Container(
                  padding: const EdgeInsets.all(8),
                  height: MediaQuery.of(context).size.height * 0.6,
                  width: MediaQuery.of(context).size.width * 0.45,
                  child: GoogleMapsWidget(
                    id: id,
                    lat: lat,
                    long: long,
                  ),
                ),
              );
            });
      },
    );
  }
}
