import 'package:app_jugueria/componentes/app_text.dart';
import 'package:app_jugueria/componentes/app_buttons.dart';
import 'package:app_jugueria/componentes/app_textFieldRound.dart';
import 'package:app_jugueria/componentes/app_drawer.dart';
import 'package:app_jugueria/componentes/info_global.dart';
import 'package:app_jugueria/modelos/clienteModel.dart';
import 'package:app_jugueria/modelos/tipoDocumentoModel.dart';
import 'package:app_jugueria/controladores/clienteController.dart';
import 'package:app_jugueria/modelos/usuarioModel.dart';
import 'package:flutter/material.dart';

enum WidgetState { NONE, LOADING, LOADED, ERROR }

class AppRegistroCliente extends StatefulWidget {
  List<TipoDocumentoModel>? listaTipoDocumento;
  ClienteModel? clienteModel;
  AppRegistroCliente({this.listaTipoDocumento, this.clienteModel, Key? key})
      : super(key: key);
  @override
  State<AppRegistroCliente> createState() {
    return _AppRegistroClienteState();
  }
}

class _AppRegistroClienteState extends State<AppRegistroCliente> {
  late TextEditingController tecNombre;
  late TextEditingController tecNumeroDocumento;
  late TextEditingController tecApellido;
  late TextEditingController tecTelefono;
  late TextEditingController tecEmail;
  late TextEditingController tecNombreUsuario;
  late TextEditingController tecContraseniaUsuario;
  WidgetState _widgetState = WidgetState.LOADED;
  int idTipoDocumento = 0;

  @override
  void initState() {
    super.initState();
    if (widget.clienteModel != null) {
      tecNombre =
          TextEditingController(text: widget.clienteModel!.nombreCliente);
      tecNumeroDocumento =
          TextEditingController(text: widget.clienteModel!.numeroDocumento);
      tecApellido =
          TextEditingController(text: widget.clienteModel!.apellidoCliente);
      tecTelefono =
          TextEditingController(text: widget.clienteModel!.telefonoCliente);
      tecEmail = TextEditingController(text: widget.clienteModel!.emailCliente);
      tecNombreUsuario = TextEditingController(
          text: widget.clienteModel!.usuario!.nombreUsuario);
      tecContraseniaUsuario = TextEditingController(
          text: widget.clienteModel!.usuario!.contraseniaUsuario);
      idTipoDocumento = widget.clienteModel!.tipoDocumentoModel!.id!;
    } else {
      tecNombre = TextEditingController();
      tecNumeroDocumento = TextEditingController();
      tecApellido = TextEditingController();
      tecTelefono = TextEditingController();
      tecEmail = TextEditingController();
      tecNombreUsuario = TextEditingController();
      tecContraseniaUsuario = TextEditingController();
    }
  }

  @override
  void dispose() {
    super.dispose();
    InfoGlobal.decrementarVentanas();
  }

  Future<void> registrarActualizar() async {
    try {
      setState(() {
        _widgetState = WidgetState.LOADING;
      });
      ClienteController clienteCtrll = ClienteController();

      if (widget.clienteModel != null) {
        UsuarioModel usuarioModel = UsuarioModel(
            id: widget.clienteModel!.usuario!.id,
            nombreUsuario: tecNombreUsuario.text,
            contraseniaUsuario: tecContraseniaUsuario.text);

        ClienteModel clienteModel = ClienteModel(
            id: widget.clienteModel!.id,
            tipoDocumentoModel: TipoDocumentoModel(id: idTipoDocumento),
            numeroDocumento: tecNumeroDocumento.text,
            nombreCliente: tecNombre.text,
            apellidoCliente: tecApellido.text,
            telefonoCliente: tecTelefono.text,
            emailCliente: tecEmail.text,
            usuario: usuarioModel);
        await clienteCtrll.updateCliente(clienteModel);

      } else {
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
        await clienteCtrll.addCliente(clienteModel);
      }

      final lista = await clienteCtrll.getClientes();
      Navigator.of(context).pop();
      Navigator.pushNamed(
        context,
        '/lista-clientes',
        arguments: lista,
      );

      setState(() {
        _widgetState = WidgetState.LOADED;
      });
    } catch (e) {
      print("Exception capturada.");
      print(e.toString());
      setState(() {
        _widgetState = WidgetState.NONE;
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
          appBar: AppBar(
            title: (widget.clienteModel != null)
                ? const Text("Editar cliente")
                : const Text("Registro cliente"),
            backgroundColor: Colors.green.shade900,
          ),
          drawer: AppMenuDrawer(),
          body: Center(
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
                        color: Colors.black,
                        decoration: TextDecoration.none),
                  )
                ]),
          ),
        );
      case WidgetState.LOADED:
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: (widget.clienteModel != null)
                ? const Text("Editar cliente")
                : const Text("Registro cliente"),
            backgroundColor: Colors.green.shade900,
          ),
          drawer: AppMenuDrawer(),
          body: ListView(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.only(top: 50),
                child: Column(
                  children: [
                    AppText(text: "Documento", width: 320),
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
                              decoration: const InputDecoration(
                                  border: InputBorder.none),
                              borderRadius: BorderRadius.circular(15),
                              items: widget.listaTipoDocumento!
                                  .map((tipoDocumento) {
                                return DropdownMenuItem(
                                    child: Text(tipoDocumento.nombreDocumento!),
                                    value: tipoDocumento.id);
                              }).toList(),
                              onChanged: (value) {
                                idTipoDocumento = value!;
                              })
                          : DropdownButtonFormField(
                              decoration: const InputDecoration(
                                  border: InputBorder.none),
                              value: 1,
                              borderRadius: BorderRadius.circular(15),
                              items: widget.listaTipoDocumento!
                                  .map((tipoDocumento) {
                                return DropdownMenuItem(
                                    child: Text(tipoDocumento.nombreDocumento!),
                                    value: tipoDocumento.id);
                              }).toList(),
                              onChanged: (value) {
                                idTipoDocumento = value!;
                              }),
                    ),
                    AppText(text: "N° documento", width: 320),
                    AppTextFieldRound(
                      width: 320,
                      isPassword: false,
                      funcion: () {},
                      myController: tecNumeroDocumento,
                    ),
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
                    Container(
                      width: 320,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            child: Column(
                              children: [
                                AppText(text: "Telefono", width: 150),
                                Container(
                                  margin: const EdgeInsets.all(0),
                                  padding: const EdgeInsets.all(0),
                                  width: 150,
                                  height: 45,
                                  decoration: BoxDecoration(
                                    color:
                                        const Color.fromRGBO(217, 217, 217, 1),
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(
                                      color: const Color.fromRGBO(
                                          217, 217, 217, 1),
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
                    AppText(text: "Email", width: 320),
                    AppTextFieldRound(
                      width: 320,
                      isPassword: false,
                      funcion: () {},
                      myController: tecEmail,
                    ),
                    const SizedBox(height: 15),
                    AppText(text: "Usuario", width: 320),
                    AppTextFieldRound(
                      width: 320,
                      isPassword: false,
                      funcion: () {},
                      myController: tecNombreUsuario,
                    ),
                    const SizedBox(height: 15),
                    AppText(text: "Contraseña", width: 320),
                    AppTextFieldRound(
                      width: 320,
                      isPassword: true,
                      funcion: () {},
                      myController: tecContraseniaUsuario,
                    ),
                    const SizedBox(height: 15),
                    AppButtons(
                      textColor: Colors.white,
                      backgroundColor: Colors.blue,
                      borderColor: Colors.blue,
                      text: (widget.clienteModel != null)
                          ? "Guardar Cambios"
                          : "Registrar",
                      fontSize: 15,
                      width: 140,
                      height: 50,
                      funcion: () async {
                        await registrarActualizar();
                      },
                    ),
                    const SizedBox(height: 15),
                  ],
                ),
              ),
            ],
          ),
        );
      case WidgetState.ERROR:
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: const Text("Seleccionar mesa"),
            backgroundColor: Colors.green.shade900,
          ),
          drawer: AppMenuDrawer(),
          body: const Center(
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
}
