import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps/google_maps.dart';
import 'package:ppadmin/src/config/constants.dart';
import 'package:ppadmin/src/utils/utils.dart';
import 'package:ppadmin/src/views/views.dart';

class IllegalLocMap extends StatelessWidget {
  IllegalLocMap({Key? key}) : super(key: key);

  List<LatLng> locations = [
    LatLng(18.5590, 73.7868),
    LatLng(19.2032, 73.8743),
    LatLng(18.5011, 73.188),
    LatLng(18.7584, 73.9828),
    LatLng(19.9042, 73.2763),
    LatLng(18.101, 73.6148),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: Colors.grey[200], borderRadius: BorderRadius.circular(15)),
        child: Column(
          children: [
            Text(
              ILLEGAL_WORKS,
              style: GoogleFonts.poppins(
                  fontSize: 16, fontWeight: FontWeight.w500),
            ),
            spacer(height: 8),
            MultiMapsWidget(id: "multi", locations: locations),
          ],
        ));
  }
}
