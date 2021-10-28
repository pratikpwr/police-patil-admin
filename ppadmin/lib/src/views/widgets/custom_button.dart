import 'package:flutter/material.dart';
import 'package:ppadmin/src/config/constants.dart';
import 'package:ppadmin/src/utils/utils.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const CustomButton({Key? key, required this.text, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 32),
            primary: PRIMARY_COLOR,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10))),
        onPressed: onTap,
        child: Text(
          text,
          style: Styles.buttonTextStyle(),
        ));
  }
}
