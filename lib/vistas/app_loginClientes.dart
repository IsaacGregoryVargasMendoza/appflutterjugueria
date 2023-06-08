import 'package:app_jugueria/modelos/tipoDocumentoModel.dart';
import 'package:app_jugueria/modelos/usuarioModel.dart';
import 'package:flutter/material.dart';
import 'package:app_jugueria/componentes/app_buttons.dart';
import 'package:app_jugueria/componentes/app_textFieldRound.dart';
import 'package:app_jugueria/componentes/info_global.dart';
import 'package:app_jugueria/modelos/clienteModel.dart';
import 'package:app_jugueria/controladores/clienteController.dart';

enum WidgetState { NONE, LOADING, LOADED, ERROR }

class AppLoginCliente extends StatefulWidget {
  @override
  State<AppLoginCliente> createState() {
    return AppLoginClienteState();
  }
}

class AppLoginClienteState extends State<AppLoginCliente> {
  final nombreUsuario = TextEditingController();
  final contraseniaUsuario = TextEditingController();
  WidgetState _widgetState = WidgetState.LOADED;

  Future<void> validarLogin() async {
    try {
      setState(() {
        _widgetState = WidgetState.LOADING;
      });

      ClienteController clienteCtrll = ClienteController();

      UsuarioModel usuarioModel = UsuarioModel(
          nombreUsuario: nombreUsuario.text,
          contraseniaUsuario: contraseniaUsuario.text);

      ClienteModel clienteModel = ClienteModel();

      List<ClienteModel> respuesta =
          await clienteCtrll.validarLogin(usuarioModel);

      print(respuesta[0].id);
      if (respuesta.length == 1) {
        clienteModel.id = respuesta[0].id;
        clienteModel.nombreCliente = respuesta[0].nombreCliente;
        clienteModel.apellidoCliente = respuesta[0].apellidoCliente;
        clienteModel.numeroDocumento = respuesta[0].numeroDocumento;
        clienteModel.tipoDocumentoModel =
            TipoDocumentoModel(id: respuesta[0].tipoDocumentoModel!.id);
        clienteModel.telefonoCliente = respuesta[0].telefonoCliente;
        clienteModel.emailCliente = respuesta[0].emailCliente;

        usuarioModel.id = respuesta[0].usuario!.id;
        clienteModel.usuario = usuarioModel;

        InfoGlobal.clienteModel = clienteModel;

        Navigator.pushNamed(context, '/seleccionar-mesas');
        setState(() {
          _widgetState = WidgetState.LOADED;
        });
      } else {
        mostrarAlerta(context, "Mensaje", "Usuario y/o contraseña incorrecto.");
        setState(() {
          _widgetState = WidgetState.LOADED;
        });
      }
    } catch (e) {
      mostrarAlerta(context, "Error",
          "Ha ocurrido un error al intentar logearse\n ${e.toString()}");
      setState(() {
        _widgetState = WidgetState.LOADED;
      });
    }
  }

  Future<void> obtenerClientesVarios() async {
    try {
      setState(() {
        _widgetState = WidgetState.LOADING;
      });

      ClienteController clienteCtrll = ClienteController();
      UsuarioModel usuarioModel = UsuarioModel();
      ClienteModel clienteModel = ClienteModel();

      ClienteModel respuesta = await clienteCtrll.obtenerClientesVarios();
      clienteModel.id = respuesta.id;
      clienteModel.nombreCliente = respuesta.nombreCliente;
      clienteModel.apellidoCliente = respuesta.apellidoCliente;
      clienteModel.numeroDocumento = respuesta.numeroDocumento;
      clienteModel.tipoDocumentoModel =
          TipoDocumentoModel(id: respuesta.tipoDocumentoModel!.id);
      clienteModel.telefonoCliente = respuesta.telefonoCliente;
      clienteModel.emailCliente = respuesta.emailCliente;

      usuarioModel.id = respuesta.usuario!.id;
      usuarioModel.nombreUsuario = respuesta.usuario!.nombreUsuario;
      usuarioModel.contraseniaUsuario = respuesta.usuario!.contraseniaUsuario;
      clienteModel.usuario = usuarioModel;

      InfoGlobal.clienteModel = clienteModel;

      Navigator.pushNamed(context, '/seleccionar-mesas');
      setState(() {
        _widgetState = WidgetState.LOADED;
      });
    } catch (e) {
      mostrarAlerta(context, "Error",
          "Ha ocurrido un error al intentar ingresar\n ${e.toString()}");
      setState(() {
        _widgetState = WidgetState.ERROR;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    switch (_widgetState) {
      case WidgetState.NONE:
      case WidgetState.LOADING:
        return Scaffold(
          backgroundColor: Colors.white,
          body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            margin: const EdgeInsets.all(0),
            padding: const EdgeInsets.all(0),
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/frutas_fondo1.jpg"),
                fit: BoxFit.cover,
              ),
            ),
            child: Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: Colors.amber.shade900),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      "Cargando...",
                      style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 20.0,
                          color: Colors.white,
                          decoration: TextDecoration.none),
                    )
                  ]),
            ),
          ),
        );
      case WidgetState.LOADED:
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
            child: ListView(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height,
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
                                style: TextStyle(
                                    fontSize: 14, color: Colors.white),
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
                                style: TextStyle(
                                    fontSize: 14, color: Colors.white),
                              ),
                            ),
                            AppTextFieldRound(
                              width: 320,
                              isPassword: true,
                              funcion: () {},
                              myController: contraseniaUsuario,
                            ),
                            const SizedBox(height: 15),
                            Container(
                              width: 320,
                              child: GestureDetector(
                                onTap: () {},
                                child: const Text(
                                  "¿Olvidaste tu contraseña?",
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.white),
                                ),
                              ),
                            ),
                            const SizedBox(height: 15),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                AppButtons(
                                  textColor: Colors.black,
                                  backgroundColor:
                                      const Color.fromRGBO(241, 241, 241, 1),
                                  borderColor:
                                      const Color.fromRGBO(241, 241, 241, 1),
                                  text: "Iniciar sesion",
                                  fontSize: 15,
                                  width: 130,
                                  height: 50,
                                  funcion: () async {
                                    await validarLogin();
                                  },
                                ),
                                AppButtons(
                                  textColor: Colors.black,
                                  backgroundColor:
                                      const Color.fromRGBO(241, 241, 241, 1),
                                  borderColor:
                                      const Color.fromRGBO(241, 241, 241, 1),
                                  text: "Omitir",
                                  fontSize: 15,
                                  width: 130,
                                  height: 50,
                                  funcion: () async {
                                    await obtenerClientesVarios();
                                  },
                                ),
                              ],
                            ),

                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                //Text("¿No tengo cuenta?"),
                                const Text(
                                  "¿No tengo cuenta?",
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.white),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, '/registrar-cliente-login');
                                  },
                                  child: const Text(
                                    "Registrarme",
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.blue),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Container(
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                              width: 150,
                              child: Image.asset("assets/devesoft_blanco.png"),
                            ),
                            const SizedBox(height: 30),
                            //const SizedBox(height: 50),
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
      case WidgetState.ERROR:
        return const Scaffold(
          backgroundColor: Colors.white,
          body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "ERROR!. Vuelve a intentarlo.",
                    style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 20.0,
                        color: Colors.blueGrey,
                        decoration: TextDecoration.none),
                  )
                ]),
          ),
        );
    }
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
