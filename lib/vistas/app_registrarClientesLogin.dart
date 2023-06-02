import 'package:app_jugueria/modelos/tipoDocumentoModel.dart';
import 'package:app_jugueria/modelos/clienteModel.dart';
import 'package:app_jugueria/controladores/clienteController.dart';
import 'package:app_jugueria/modelos/usuarioModel.dart';
import 'package:flutter/material.dart';
import 'package:app_jugueria/componentes/app_buttons.dart';
import 'package:app_jugueria/componentes/app_text.dart';
import 'package:app_jugueria/componentes/app_textFieldRound.dart';

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

  int idTipoDocumento = 0;
  bool _buttonDisabled = false;

  _cargarTipoDocumento() async {
    ClienteController clienteCtrll = ClienteController();
    final lista = await clienteCtrll.getTipoDocumentos();
    //MesaController mesaCtrll = Controller();
    //final lista = await mesaCtrll.getMesas();
    setState(() {
      listaDocumento = lista;
      //listaMesas = lista;
    });
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
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.all(25),
          color: Colors.black.withOpacity(0.5),
          child: ListView(
            children: [
              //AppText(text: "Documento", width: 320),
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
                          idTipoDocumento = value!;
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
              //AppText(text: "N° documento", width: 320),
              const SizedBox(height: 15),
              Container(
                margin: const EdgeInsets.all(0),
                padding: const EdgeInsets.all(0),
                width: 320,
                height: 20,
                child: const Text(
                  "N° documento",
                  style: TextStyle(fontSize: 14, color: Colors.white),
                ),
              ),
              AppTextFieldRound(
                width: 320,
                isPassword: false,
                funcion: () {},
                myController: tecNumeroDocumento,
              ),
              //AppText(text: "Nombres", width: 320),
              const SizedBox(height: 15),
              Container(
                margin: const EdgeInsets.all(0),
                padding: const EdgeInsets.all(0),
                width: 320,
                height: 20,
                child: const Text(
                  "Nombres",
                  style: TextStyle(fontSize: 14, color: Colors.white),
                ),
              ),
              AppTextFieldRound(
                width: 320,
                isPassword: false,
                funcion: () {},
                myController: tecNombre,
              ),
              const SizedBox(height: 15),
              //AppText(text: "Apellidos", width: 320),
              Container(
                margin: const EdgeInsets.all(0),
                padding: const EdgeInsets.all(0),
                width: 320,
                height: 20,
                child: const Text(
                  "Apellidos",
                  style: TextStyle(fontSize: 14, color: Colors.white),
                ),
              ),
              AppTextFieldRound(
                width: 320,
                isPassword: false,
                funcion: () {},
                myController: tecApellido,
              ),
              const SizedBox(height: 15),
              Container(
                width: 320,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: Column(
                        children: [
                          //AppText(text: "Telefono", width: 150),
                          Container(
                            margin: const EdgeInsets.all(0),
                            padding: const EdgeInsets.all(0),
                            width: 150,
                            height: 20,
                            child: const Text(
                              "Telefono",
                              style:
                                  TextStyle(fontSize: 14, color: Colors.white),
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
                                color: const Color.fromRGBO(217, 217, 217, 1),
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
              //AppText(text: "Email", width: 320),
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
              //AppText(text: "Usuario", width: 320),
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
              //AppText(text: "Contraseña", width: 320),
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
                  ClienteController clienteCtrll = ClienteController();

                  UsuarioModel usuarioModel = UsuarioModel(
                      nombreUsuario: tecNombreUsuario.text,
                      contraseniaUsuario: tecContraseniaUsuario.text);

                  ClienteModel clienteModel = ClienteModel(
                      tipoDocumentoModel:
                          TipoDocumentoModel(id: idTipoDocumento),
                      numeroDocumento: tecNumeroDocumento.text,
                      nombreCliente: tecNombre.text,
                      apellidoCliente: tecApellido.text,
                      telefonoCliente: tecTelefono.text,
                      emailCliente: tecEmail.text,
                      usuario: usuarioModel);
                  await clienteCtrll.addCliente(clienteModel);

                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                  Navigator.pushNamed(context, '/login-cliente');
                },
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //Text("¿No tengo cuenta?"),
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
