import 'package:flutter/material.dart';

class AppButtons extends StatelessWidget {
  final Color textColor;
  final Color backgroundColor;
  final Color borderColor;
  final String text;
  double fontSize;
  double width;
  double height;
  final VoidCallback funcion;

  AppButtons(
      {Key? key,
      required this.textColor,
      required this.backgroundColor,
      required this.borderColor,
      required this.text,
      required this.fontSize,
      required this.width,
      required this.height,
      required this.funcion})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(0),
      padding: EdgeInsets.all(0),
      width: width,
      height: height,
      decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: borderColor,
            width: 1.0,
          )),
      child: TextButton(
        onPressed: funcion,
        child: Center(
          child: Text(
            text,
            style: TextStyle(
                color: textColor,
                fontSize: fontSize,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
