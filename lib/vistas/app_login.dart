import 'package:app_jugueria/modelos/tipoDocumentoModel.dart';
import 'package:app_jugueria/modelos/usuarioModel.dart';
import 'package:app_jugueria/modelos/administradorModel.dart';
import 'package:flutter/material.dart';
import 'package:app_jugueria/componentes/app_buttons.dart';
import 'package:app_jugueria/componentes/app_textFieldRound.dart';
import 'package:app_jugueria/componentes/info_global.dart';
import 'package:app_jugueria/controladores/administradorController.dart';

import 'package:app_jugueria/vistas/app_menu.dart';

class AppLogin extends StatefulWidget {
  @override
  State<AppLogin> createState() {
    return _AppLoginState();
  }
}

class _AppLoginState extends State<AppLogin> {
  final nombreUsuario = TextEditingController();
  final contraseniaUsuario = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      //appBar: AppBar(),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        margin: EdgeInsets.all(0),
        padding: EdgeInsets.all(0),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/frutas_fondo1.jpg"),
            // opacity: 0.9,
            fit: BoxFit.cover,
          ),
        ),
        child: ListView(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              margin: EdgeInsets.all(0),
              color: Colors.black.withOpacity(0.5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(0, 70, 0, 0),
                    width: MediaQuery.of(context).size.width / 3,
                    child: Image.asset("assets/logo.png"),
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          margin: const EdgeInsets.all(0),
                          padding: const EdgeInsets.all(0),
                          width: 320,
                          height: 20,
                          child: const Text(
                            "Usuario",
                            style: TextStyle(fontSize: 14, color: Colors.white),
                          ),
                        ),
                        AppTextFieldRound(
                          width: 320,
                          isPassword: false,
                          funcion: () {},
                          myController: nombreUsuario,
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
                          myController: contraseniaUsuario,
                        ),
                        const SizedBox(height: 20),
                        AppButtons(
                          textColor: Colors.black,
                          backgroundColor:
                              const Color.fromRGBO(241, 241, 241, 1),
                          borderColor: const Color.fromRGBO(241, 241, 241, 1),
                          text: "Iniciar sesion",
                          fontSize: 15,
                          width: 130,
                          height: 50,
                          funcion: () async {
                            try {
                              AdministradorController administradorCtrl =
                                  AdministradorController();

                              UsuarioModel usuarioModel = UsuarioModel(
                                  nombreUsuario: nombreUsuario.text,
                                  contraseniaUsuario: contraseniaUsuario.text);

                              AdministradorModel administradorModel =
                                  AdministradorModel();

                              List<AdministradorModel> respuesta =
                                  await administradorCtrl
                                      .validarLogin(usuarioModel);

                              if (respuesta.length == 1) {
                                administradorModel.nombreAdministrador =
                                    respuesta[0].nombreAdministrador;
                                administradorModel.apellidoAdministrador =
                                    respuesta[0].apellidoAdministrador;
                                administradorModel.numeroDocumento =
                                    respuesta[0].numeroDocumento;
                                administradorModel.tipoDocumentoModel =
                                    TipoDocumentoModel(
                                        id: respuesta[0]
                                            .tipoDocumentoModel!
                                            .id);
                                administradorModel.telefonoAdministrador =
                                    respuesta[0].telefonoAdministrador;
                                administradorModel.emailAdministrador =
                                    respuesta[0].emailAdministrador;

                                usuarioModel.id = respuesta[0].usuario!.id;
                                administradorModel.usuario = usuarioModel;
                                InfoGlobal.administradorModel =
                                    administradorModel;
                                Navigator.pushNamed(
                                    context, '/menu-administrador');
                              } else {
                                mostrarAlerta(context, "Mensaje",
                                    "Usuario y/o contraseña incorrecto.");
                              }
                            } catch (e) {
                              mostrarAlerta(context, "Error",
                                  "Ha ocurrido un error al intentar logearse\n ${e.toString()}");
                            }
                          },
                        ),
                        const SizedBox(height: 15),
                        Container(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                          width: 150,
                          child: Image.asset("assets/devesoft-blanco.png"),
                        ),
                        const SizedBox(height: 50),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void mostrarAlerta(BuildContext context, String cabecera, String mensaje) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(cabecera),
          content: Text(mensaje),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
