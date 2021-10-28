import 'package:flutter/material.dart';
import 'package:ppadmin/src/config/constants.dart';
import 'package:ppadmin/src/utils/utils.dart';

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
            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 32),
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
              style: Styles.textButtonTextStyle(),
            ),
            Icon(
              icon ?? Icons.upload_rounded,
              size: 28,
              color: PRIMARY_COLOR,
            )
          ],
        ));
  }
}
