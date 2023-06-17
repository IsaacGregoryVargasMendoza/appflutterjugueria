import 'package:app_jugueria/modelos/tipoDocumentoModel.dart';
import 'package:app_jugueria/modelos/clienteModel.dart';
import 'package:app_jugueria/controladores/clienteController.dart';
import 'package:app_jugueria/modelos/usuarioModel.dart';
import 'package:flutter/material.dart';
import 'package:app_jugueria/componentes/app_buttons.dart';
import 'package:app_jugueria/componentes/app_textFieldRound.dart';
import 'package:app_jugueria/componentes/info_global.dart';

enum WidgetState { NONE, LOADING, LOADED, ERROR }

class AppRegistrarClienteLogin extends StatefulWidget {
  @override
  State<AppRegistrarClienteLogin> createState() {
    return AppRegistrarClienteLoginState();
  }
}

class AppRegistrarClienteLoginState extends State<AppRegistrarClienteLogin> {
  late TextEditingController tecNombre;
  late TextEditingController tecNumeroDocumento;
  late TextEditingController tecApellido;
  late TextEditingController tecTelefono;
  late TextEditingController tecEmail;
  late TextEditingController tecNombreUsuario;
  late TextEditingController tecContraseniaUsuario;
  List<TipoDocumentoModel>? listaDocumento = [];
  WidgetState _widgetState = WidgetState.LOADED;

  int idTipoDocumento = 0;

  _cargarTipoDocumento() async {
    setState(() {
      _widgetState = WidgetState.LOADING;
    });
    try {
      ClienteController clienteCtrll = ClienteController();
      final lista = await clienteCtrll.getTipoDocumentos();
      setState(() {
        listaDocumento = lista;
        _widgetState = WidgetState.LOADED;
      });
    } catch (e) {
      print(e.toString());
      setState(() {
        _widgetState = WidgetState.ERROR;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    tecNombre = TextEditingController();
    tecNumeroDocumento = TextEditingController();
    tecApellido = TextEditingController();
    tecTelefono = TextEditingController();
    tecEmail = TextEditingController();
    tecNombreUsuario = TextEditingController();
    tecContraseniaUsuario = TextEditingController();
    _cargarTipoDocumento();
  }

  @override
  void dispose() {
    super.dispose();
    InfoGlobal.decrementarVentanas();
  }

  Future<void> registrar() async {
    try {
      setState(() {
        _widgetState = WidgetState.LOADING;
      });

      if (idTipoDocumento == 0 || idTipoDocumento == 1) {
        mostrarAlerta(context, "Mensaje", "Seleccione el documento correcto.");
        setState(() {
          _widgetState = WidgetState.LOADED;
        });
        return;
      }

      if (tecNumeroDocumento.text.toString().trim().length < 8) {
        mostrarAlerta(
            context, "Mensaje", "Ingrese un numero de documento valido.");
        setState(() {
          _widgetState = WidgetState.LOADED;
        });
        return;
      }

      if (tecNombre.text.toString().trim().length < 2) {
        mostrarAlerta(context, "Mensaje", "Ingrese un nombre valido.");
        setState(() {
          _widgetState = WidgetState.LOADED;
        });
        return;
      }

      if (tecNombreUsuario.text.toString().trim().length < 2) {
        mostrarAlerta(
            context, "Mensaje", "El usuario debe tener mas de 2 caracteres.");
        setState(() {
          _widgetState = WidgetState.LOADED;
        });
        return;
      }

      if (tecContraseniaUsuario.text.toString().trim().length < 5) {
        mostrarAlerta(context, "Mensaje",
            "El contraseña debe tener mas de 5 caracteres.");
        setState(() {
          _widgetState = WidgetState.LOADED;
        });
        return;
      }

      ClienteController clienteCtrll = ClienteController();

      UsuarioModel usuarioModel = UsuarioModel(
          nombreUsuario: tecNombreUsuario.text,
          contraseniaUsuario: tecContraseniaUsuario.text);

      ClienteModel clienteModel = ClienteModel(
          tipoDocumentoModel: TipoDocumentoModel(id: idTipoDocumento),
          numeroDocumento: tecNumeroDocumento.text,
          nombreCliente: tecNombre.text,
          apellidoCliente: tecApellido.text,
          telefonoCliente: tecTelefono.text,
          emailCliente: tecEmail.text,
          usuario: usuarioModel);
      var respuesta = await clienteCtrll.addCliente(clienteModel);

      // bool respuesta = false;
      if (respuesta) {
        const snackBar = SnackBar(
          duration: Duration(seconds: 7),
          backgroundColor: Colors.green,
          content: Text('Se ha registrado correctamente'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);

        setState(() {
          _widgetState = WidgetState.LOADED;
        });

        Navigator.of(context).pop();
        Navigator.of(context).pop();
        Navigator.pushNamed(context, '/login-cliente');
      } else {
        const snackBar = SnackBar(
          duration: Duration(seconds: 7),
          backgroundColor: Colors.red,
          content: Text('No se logro registrar'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        setState(() {
          _widgetState = WidgetState.LOADED;
        });
      }
    } catch (e) {
      // print("Exception capturada.");
      // print(e.toString());
      const snackBar = SnackBar(
        duration: Duration(seconds: 7),
        backgroundColor: Colors.red,
        content: Text('ERROR!. No se pudo registrar'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

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
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              height: MediaQuery.of(context).size.height,
              padding: EdgeInsets.all(25),
              color: Colors.black.withOpacity(0.5),
              child: ListView(
                children: [
                  const SizedBox(height: 25),
                  const Text(
                    "Registrarse",
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 25),
                  Container(
                    margin: const EdgeInsets.all(0),
                    padding: const EdgeInsets.all(0),
                    width: 320,
                    height: 20,
                    child: const Text(
                      "Documento",
                      style: TextStyle(fontSize: 14, color: Colors.white),
                    ),
                  ),
                  Container(
                    width: 320,
                    padding: const EdgeInsets.fromLTRB(20, 5, 20, 0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: const Color.fromRGBO(217, 217, 217, 1),
                    ),
                    child: (idTipoDocumento != 0)
                        ? DropdownButtonFormField(
                            value: idTipoDocumento,
                            decoration:
                                const InputDecoration(border: InputBorder.none),
                            borderRadius: BorderRadius.circular(15),
                            items: listaDocumento!.map((tipoDocumento) {
                              return DropdownMenuItem(
                                value: tipoDocumento.id,
                                child: Text(tipoDocumento.nombreDocumento!),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                idTipoDocumento = value!;
                              });
                            })
                        : DropdownButtonFormField(
                            decoration:
                                const InputDecoration(border: InputBorder.none),
                            value: 1,
                            borderRadius: BorderRadius.circular(15),
                            items: listaDocumento!.map((tipoDocumento) {
                              return DropdownMenuItem(
                                value: tipoDocumento.id,
                                child: Text(tipoDocumento.nombreDocumento!),
                              );
                            }).toList(),
                            onChanged: (value) {
                              idTipoDocumento = value!;
                            }),
                  ),
                  const SizedBox(height: 15),
                  Container(
                    margin: const EdgeInsets.all(0),
                    padding: const EdgeInsets.all(0),
                    width: 320,
                    height: 20,
                    child: Text(
                      (idTipoDocumento == 2)
                          ? "DNI"
                          : (idTipoDocumento == 3)
                              ? "RUC"
                              : "N° TIpo documento",
                      style: const TextStyle(fontSize: 14, color: Colors.white),
                    ),
                  ),
                  AppTextFieldRound(
                    width: 320,
                    isPassword: false,
                    funcion: () {},
                    myController: tecNumeroDocumento,
                  ),
                  const SizedBox(height: 15),
                  Container(
                    margin: const EdgeInsets.all(0),
                    padding: const EdgeInsets.all(0),
                    width: 320,
                    height: 20,
                    child: Text(
                      (idTipoDocumento == 2)
                          ? "Nombres"
                          : (idTipoDocumento == 3)
                              ? "Razon social"
                              : "Nombres",
                      style: const TextStyle(fontSize: 14, color: Colors.white),
                    ),
                  ),
                  AppTextFieldRound(
                    width: 320,
                    isPassword: false,
                    funcion: () {},
                    myController: tecNombre,
                  ),
                  SizedBox(height: (idTipoDocumento != 3) ? 15 : 0),
                  (idTipoDocumento != 3)
                      ? Container(
                          margin: const EdgeInsets.all(0),
                          padding: const EdgeInsets.all(0),
                          width: 320,
                          height: 20,
                          child: const Text(
                            "Apellidos",
                            style: TextStyle(fontSize: 14, color: Colors.white),
                          ),
                        )
                      : SizedBox(height: 0),
                  (idTipoDocumento != 3)
                      ? AppTextFieldRound(
                          width: 320,
                          isPassword: false,
                          funcion: () {},
                          myController: tecApellido,
                        )
                      : SizedBox(height: 0),
                  const SizedBox(height: 15),
                  Container(
                    width: 320,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Column(
                            children: [
                              Container(
                                margin: const EdgeInsets.all(0),
                                padding: const EdgeInsets.all(0),
                                width: 150,
                                height: 20,
                                child: const Text(
                                  "Telefono",
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.white),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.all(0),
                                padding: const EdgeInsets.all(0),
                                width: 150,
                                height: 45,
                                decoration: BoxDecoration(
                                  color: const Color.fromRGBO(217, 217, 217, 1),
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(
                                    color:
                                        const Color.fromRGBO(217, 217, 217, 1),
                                  ),
                                ),
                                child: Scrollbar(
                                  controller: ScrollController(),
                                  child: TextField(
                                    scrollController: ScrollController(),
                                    keyboardType: TextInputType.number,
                                    enableSuggestions: false,
                                    autocorrect: false,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      height: 2,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.black,
                                    ),
                                    decoration: const InputDecoration(
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 0),
                                        border: InputBorder.none),
                                    controller: tecTelefono,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  Container(
                    margin: const EdgeInsets.all(0),
                    padding: const EdgeInsets.all(0),
                    width: 320,
                    height: 20,
                    child: const Text(
                      "Email",
                      style: TextStyle(fontSize: 14, color: Colors.white),
                    ),
                  ),
                  AppTextFieldRound(
                    width: 320,
                    isPassword: false,
                    funcion: () {},
                    myController: tecEmail,
                  ),
                  const SizedBox(height: 15),
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
                    myController: tecNombreUsuario,
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
                    myController: tecContraseniaUsuario,
                  ),
                  const SizedBox(height: 15),
                  AppButtons(
                    textColor: Colors.black,
                    backgroundColor: const Color.fromRGBO(241, 241, 241, 1),
                    borderColor: const Color.fromRGBO(241, 241, 241, 1),
                    text: "Registrarme",
                    fontSize: 15,
                    width: 130,
                    height: 50,
                    funcion: () async {
                      await registrar();
                    },
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "¿Tienes cuenta? ",
                        style: TextStyle(fontSize: 14, color: Colors.white),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                          Navigator.pushNamed(context, '/login-cliente');
                        },
                        child: const Text(
                          "Iniciar Sesion",
                          style: TextStyle(fontSize: 14, color: Colors.blue),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      case WidgetState.ERROR:
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
            child: const Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "ERROR!. Vuelve a intentarlo.",
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
