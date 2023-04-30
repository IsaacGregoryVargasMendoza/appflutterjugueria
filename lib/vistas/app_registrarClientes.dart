import 'dart:convert';
import 'package:app_jugueria/componentes/app_text.dart';
import 'package:app_jugueria/componentes/app_buttons.dart';
import 'package:app_jugueria/componentes/app_textFieldRound.dart';
import 'package:app_jugueria/componentes/app_drawer.dart';
import 'package:app_jugueria/modelos/categoriaModel.dart';
import 'package:app_jugueria/vistas/app_listaClientes.dart';
import 'package:app_jugueria/controladores/clienteController.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AppRegistroCliente extends StatefulWidget {
  AppRegistroCliente({Key? key}) : super(key: key);
  @override
  State<AppRegistroCliente> createState() {
    return _AppRegistroClienteState();
  }
}

class _AppRegistroClienteState extends State<AppRegistroCliente> {
  final tecNombre = TextEditingController();
  final tecApellido = TextEditingController();
  final tecTelefono = TextEditingController();
  final tecEmail = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Registro cliente"),
        backgroundColor: Colors.blue,
      ),
      drawer: AppMenuDrawer(),
      body: ListView(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.only(top: 50),
            child: Column(
              children: [
                AppText(text: "Nombres", width: 320),
                AppTextFieldRound(
                  width: 320,
                  isPassword: false,
                  funcion: () {},
                  myController: tecNombre,
                ),
                const SizedBox(height: 15),
                AppText(text: "Apellidos", width: 320),
                AppTextFieldRound(
                  width: 320,
                  isPassword: false,
                  funcion: () {},
                  myController: tecApellido,
                ),
                const SizedBox(height: 15),
                AppText(text: "Telefono", width: 320),
                AppTextFieldRound(
                  width: 320,
                  isPassword: false,
                  funcion: () {},
                  myController: tecTelefono,
                ),
                const SizedBox(height: 15),
                AppText(text: "Email", width: 320),
                AppTextFieldRound(
                  width: 320,
                  isPassword: false,
                  funcion: () {},
                  myController: tecEmail,
                ),
                const SizedBox(height: 15),
                AppButtons(
                  textColor: Colors.white,
                  backgroundColor: Colors.blue,
                  borderColor: Colors.blue,
                  text: "Registrar",
                  fontSize: 15,
                  width: 130,
                  height: 50,
                  funcion: () async {
                    ClienteController clienteCtrll = ClienteController();
                    await clienteCtrll.addCliente(tecNombre.text,
                        tecApellido.text, tecTelefono.text, tecEmail.text);

                    final lista = await clienteCtrll.getClientes();
                    Navigator.of(context).pop();
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => AppListaCliente(lista)));
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
