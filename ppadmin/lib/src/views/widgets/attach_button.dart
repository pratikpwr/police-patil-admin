import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ppadmin/src/config/constants.dart';

class AttachButton extends StatelessWidget {
  final String text;
  final IconData? icon;
  final VoidCallback onTap;

  const AttachButton(
      {Key? key, required this.text, required this.onTap, this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
        style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
              10,
            ))),
        onPressed: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              text,
              style: GoogleFonts.poppins(
                  color: PRIMARY_COLOR,
                  fontWeight: FontWeight.w500,
                  fontSize: 14),
            ),
            Icon(
              icon ?? Icons.upload_rounded,
              size: 28,
            )
          ],
        ));
  }
}
