import 'package:app_jugueria/controladores/administradorController.dart';
import 'package:app_jugueria/componentes/app_drawer.dart';
import 'package:app_jugueria/modelos/usuarioModel.dart';
import 'package:app_jugueria/modelos/administradorModel.dart';
import 'package:app_jugueria/modelos/tipoDocumentoModel.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AppListaAdministradores extends StatefulWidget {
  List<AdministradorModel>? data;

  AppListaAdministradores({this.data, Key? key}) : super(key: key);
  @override
  State<AppListaAdministradores> createState() {
    return AppListaAdministradoresState();
  }
}

class AppListaAdministradoresState extends State<AppListaAdministradores> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Lista de administradores del sistema"),
        backgroundColor: Colors.green.shade900,
        actions: <Widget>[
          IconButton(
            onPressed: () async {
              //   ClienteController clienteCtrll = ClienteController();
              //   final lista = await clienteCtrll.getTipoDocumentos();
              //   Navigator.of(context).pop();
              //   Navigator.pushNamed(context, '/registrar-cliente',
              //       arguments: lista);
            },
            icon: const FaIcon(FontAwesomeIcons.plus),
          ),
        ],
      ),
      drawer: AppMenuDrawer(),
      body: Stack(children: <Widget>[
        ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: widget.data!.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () async {
                // ClienteController clienteCtrl = ClienteController();
                // final listaTipoDocumento =
                //     await clienteCtrl.getTipoDocumentos();
                // ClienteModel cliente = ClienteModel(
                //   id: widget.data![index].id,
                //   tipoDocumento: TipoDocumentoModel(
                //     id: widget.data![index].tipoDocumento!.id,
                //   ),
                //   numeroDocumento: widget.data![index].numeroDocumento,
                //   nombreCliente: widget.data![index].nombreCliente,
                //   apellidoCliente: widget.data![index].apellidoCliente,
                //   telefonoCliente: widget.data![index].telefonoCliente,
                //   emailCliente: widget.data![index].emailCliente,
                // );
                // Navigator.pushNamed(
                //   context,
                //   '/editar-cliente',
                //   arguments: {
                //     'lista': listaTipoDocumento,
                //     'clienteModel': cliente
                //   },
                // );
              },
              child: Container(
                margin: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                padding: const EdgeInsets.fromLTRB(0, 0, 10, 10),
                decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    borderRadius: const BorderRadius.all(Radius.circular(10))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(20, 10, 0, 10),
                      decoration: const BoxDecoration(
                        color: Colors.transparent,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "ID: ${widget.data![index].id} \n${widget.data![index].nombreAdministrador} ${widget.data![index].apellidoAdministrador}",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.start,
                          ),
                          Text(
                            "Email: ${widget.data![index].emailAdministrador} \nTelefono: ${widget.data![index].telefonoAdministrador}",
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.start,
                          ),
                        ],
                      ),
                    ),
                    // ElevatedButton(
                    //   style: ElevatedButton.styleFrom(
                    //     primary: Colors.red.shade600,
                    //   ),
                    //   onPressed: () async {
                    //     AdministradorController administradorCtrll =
                    //         AdministradorController();
                    //     await administradorCtrll
                    //         .deleteAdministrador(widget.data![index].id!);
                    //     List<AdministradorModel> lista =
                    //         await administradorCtrll.getAdministradores();
                    //     setState(() {
                    //       widget.data = lista;
                    //     });
                    //   },
                    //   child: const FaIcon(FontAwesomeIcons.trash),
                    // )
                  ],
                ),
              ),
            );
          },
        ),
      ]),
    );
  }
}
