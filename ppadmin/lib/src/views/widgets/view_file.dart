import 'package:flutter/material.dart';

class ViewFileWidget extends StatelessWidget {
  const ViewFileWidget({Key? key, required this.url}) : super(key: key);
  final String url;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(
        Icons.remove_red_eye_rounded,
        size: 24,
        color: Colors.blueAccent,
      ),
      onPressed: () {
        showDialog(
            context: context,
            builder: (context) {
              return Dialog(
                child: Container(
                  padding: const EdgeInsets.all(32),
                  height: MediaQuery.of(context).size.height * 0.8,
                  width: MediaQuery.of(context).size.width * 0.45,
                  child: Stack(
                    children: [
                      Image.asset("https://$url"),
                      Positioned(
                        right: 16,
                        top: 16,
                        child: IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(
                              Icons.cancel_outlined,
                              size: 28,
                            )),
                      ),
                    ],
                  ),
                ),
              );
            });
      },
    );
  }
}
