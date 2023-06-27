import 'package:app_jugueria/controladores/clienteController.dart';
import 'package:app_jugueria/componentes/app_drawer.dart';
import 'package:app_jugueria/componentes/info_global.dart';
import 'package:app_jugueria/modelos/clienteModel.dart';
import 'package:app_jugueria/modelos/tipoDocumentoModel.dart';
import 'package:app_jugueria/modelos/usuarioModel.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AppListaCliente extends StatefulWidget {
  List<ClienteModel>? data;

  AppListaCliente({this.data, Key? key}) : super(key: key);
  @override
  State<AppListaCliente> createState() {
    return _AppListaClienteState();
  }
}

class _AppListaClienteState extends State<AppListaCliente> {
  @override
  void dispose() {
    super.dispose();
    InfoGlobal.decrementarVentanas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Lista de clientes"),
        backgroundColor: Colors.green.shade900,
        actions: <Widget>[
          IconButton(
            onPressed: () async {
              ClienteController clienteCtrll = ClienteController();
              final lista = await clienteCtrll.getTipoDocumentos();
              // Navigator.of(context).pop();
              Navigator.pushNamed(context, '/registrar-cliente',
                  arguments: lista);
            },
            icon: const FaIcon(FontAwesomeIcons.plus),
          ),
        ],
      ),
      // drawer: AppMenuDrawer(),
      body: Stack(children: <Widget>[
        ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: widget.data!.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () async {
                ClienteController clienteCtrl = ClienteController();
                final listaTipoDocumento =
                    await clienteCtrl.getTipoDocumentos();
                ClienteModel cliente = ClienteModel(
                    id: widget.data![index].id,
                    tipoDocumentoModel: TipoDocumentoModel(
                      id: widget.data![index].tipoDocumentoModel!.id,
                    ),
                    numeroDocumento: widget.data![index].numeroDocumento,
                    nombreCliente: widget.data![index].nombreCliente,
                    apellidoCliente: widget.data![index].apellidoCliente,
                    telefonoCliente: widget.data![index].telefonoCliente,
                    emailCliente: widget.data![index].emailCliente,
                    usuario: UsuarioModel(
                        id: widget.data![index].usuario!.id,
                        nombreUsuario:
                            widget.data![index].usuario!.nombreUsuario,
                        contraseniaUsuario:
                            widget.data![index].usuario!.contraseniaUsuario));
                Navigator.pushNamed(
                  context,
                  '/editar-cliente',
                  arguments: {
                    'lista': listaTipoDocumento,
                    'clienteModel': cliente
                  },
                );
              },
              child: Container(
                margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
                padding: EdgeInsets.fromLTRB(0, 0, 10, 10),
                decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    borderRadius: BorderRadius.all(Radius.circular(10))),
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
                            "ID: ${widget.data![index].id} \n${widget.data![index].nombreCliente} ${widget.data![index].apellidoCliente}",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.start,
                          ),
                          Text(
                            "Email: ${widget.data![index].emailCliente} \nTelefono: ${widget.data![index].telefonoCliente}",
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.start,
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.red.shade600,
                      ),
                      onPressed: () async {
                        ClienteController clienteCtrll = ClienteController();
                        await clienteCtrll
                            .deleteCliente(widget.data![index].id!);
                        List<ClienteModel> lista =
                            await clienteCtrll.getClientes();
                        setState(() {
                          widget.data = lista;
                        });
                      },
                      child: FaIcon(FontAwesomeIcons.trash),
                    )
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
