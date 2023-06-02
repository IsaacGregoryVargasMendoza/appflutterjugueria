import 'package:flutter/material.dart';

class AppTextFieldRound extends StatelessWidget {
  final Color textColor = Colors.black;
  final Color backgroundColor = const Color.fromRGBO(217, 217, 217, 1);
  final double fontSize = 16;
  final double height = 45;
  final bool isPassword;
  double width;
  final VoidCallback funcion;
  final TextEditingController myController;
  String? texto;

  AppTextFieldRound(
      {Key? key,
      required this.width,
      required this.isPassword,
      required this.funcion,
      required this.myController,
      this.texto})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(0),
      padding: const EdgeInsets.all(0),
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: backgroundColor,
        ),
      ),
      child: Scrollbar(
        controller: ScrollController(),
        child: isPassword == true
            ? TextField(
                scrollController: ScrollController(),
                keyboardType: TextInputType.multiline,
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                style: TextStyle(
                  fontSize: fontSize,
                  height: 2,
                  fontWeight: FontWeight.normal,
                  color: textColor,
                ),
                decoration: const InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                    border: InputBorder.none),
                controller: myController,
              )
            : TextField(
                scrollController: ScrollController(),
                keyboardType: TextInputType.multiline,
                enableSuggestions: false,
                autocorrect: false,
                style: TextStyle(
                  fontSize: fontSize,

                  height: 2,
                  fontWeight: FontWeight.normal,
                  // backgroundColor: Colors.blue,
                  color: textColor,
                ),
                decoration: const InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                    border: InputBorder.none),
                controller: myController,
              ),
      ),
    );
  }
}
