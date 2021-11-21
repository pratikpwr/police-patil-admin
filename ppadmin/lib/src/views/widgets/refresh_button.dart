import 'package:flutter/material.dart';
import 'package:ppadmin/src/config/constants.dart';
import 'package:ppadmin/src/utils/utils.dart';

class RefreshButton extends StatelessWidget {
  const RefreshButton({Key? key, required this.onTap}) : super(key: key);
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            const Icon(Icons.refresh_rounded),
            const SizedBox(
              width: 8,
            ),
            Text(DO_REFRESH, style: Styles.textButtonTextStyle())
          ],
        ),
      ),
    );
  }
}
