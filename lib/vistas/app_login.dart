import 'package:flutter/material.dart';
import 'package:app_jugueria/componentes/app_buttons.dart';
import 'package:app_jugueria/componentes/app_textFieldRound.dart';
import 'package:app_jugueria/componentes/app_text.dart';

import 'package:app_jugueria/vistas/app_menu.dart';

class AppLogin extends StatefulWidget {
  @override
  State<AppLogin> createState() {
    return _AppLoginState();
  }
}

class _AppLoginState extends State<AppLogin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/frutas_fondo1.jpg"),
            // opacity: 0.9,
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          color: Colors.black.withOpacity(0.5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    margin: const EdgeInsets.all(0),
                    padding: const EdgeInsets.all(0),
                    width: 320,
                    height: 20,
                    child: const Text(
                      "Correo electronico",
                      style: TextStyle(fontSize: 14, color: Colors.white),
                    ),
                  ),
                  AppTextFieldRound(
                    width: 320,
                    isPassword: false,
                    funcion: () {},
                    myController: TextEditingController(),
                  ),
                  const SizedBox(height: 15),
                  Container(
                    margin: const EdgeInsets.all(0),
                    padding: const EdgeInsets.all(0),
                    width: 320,
                    height: 20,
                    child: const Text(
                      "Contraseña",
                      style: TextStyle(fontSize: 14, color: Colors.white),
                    ),
                  ),
                  AppTextFieldRound(
                    width: 320,
                    isPassword: true,
                    funcion: () {},
                    myController: TextEditingController(),
                  ),
                  const SizedBox(height: 15),
                  AppButtons(
                    textColor: Colors.black,
                    backgroundColor: const Color.fromRGBO(241, 241, 241, 1),
                    borderColor: const Color.fromRGBO(241, 241, 241, 1),
                    text: "Iniciar sesion",
                    fontSize: 15,
                    width: 130,
                    height: 50,
                    funcion: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => AppMenu()));
                    },
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
