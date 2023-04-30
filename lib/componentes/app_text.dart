import 'package:flutter/material.dart';

class AppText extends StatelessWidget {
  final String text;
  double width;

  AppText({
    Key? key,
    required this.text,
    required this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(0),
      padding: const EdgeInsets.all(0),
      width: width,
      height: 20,
      child: Text(
        text,
        style: const TextStyle(fontSize: 14),
      ),
    );
  }
}
