import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ppadmin/src/config/constants.dart';

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  CustomAppBar({required this.title, this.image});

  final String title;
  String? image;

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
      ),
    );
  }
}
