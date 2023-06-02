import 'package:app_jugueria/controladores/pedidoController.dart';
import 'package:app_jugueria/componentes/app_drawer.dart';
import 'package:app_jugueria/modelos/adicionalModel.dart';
import 'package:app_jugueria/modelos/pedidoModel.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AppListaPedido extends StatefulWidget {
  List<PedidoModel>? data;

  AppListaPedido({this.data, Key? key}) : super(key: key);
  @override
  State<AppListaPedido> createState() {
    return AppListaPedidoState();
  }
}

class AppListaPedidoState extends State<AppListaPedido> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Lista de pedidos"),
        backgroundColor: Colors.green.shade900,
        actions: <Widget>[
          IconButton(
            onPressed: () async {
              // ClienteController clienteCtrll = ClienteController();
              // final lista = await clienteCtrll.getTipoDocumentos();
              // Navigator.of(context).pop();
              // Navigator.pushNamed(context, '/registrar-cliente',
              //     arguments: lista);
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
                PedidoController pedidoCtrll = PedidoController();
                final listaDetalle = await pedidoCtrll
                    .getListDetalleOfPedido(widget.data![index].id!);

                final listaAdicionales =
                    await pedidoCtrll.getListAdicionales(listaDetalle);

                abrirModalDetalle(listaDetalle, listaAdicionales);
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
                            "Codigo: ${widget.data![index].id}",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.start,
                          ),
                          Text(
                            "Fecha: ${widget.data![index].fechaPedido}",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.start,
                          ),
                          Text(
                            "Cliente: ${widget.data![index].cliente!.nombreCliente} ${widget.data![index].cliente!.apellidoCliente}",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.start,
                          ),
                          Text(
                            "Total: ${widget.data![index].totalPedido}",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.start,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ]),
    );
  }

  abrirModalDetalle(List<DetallePedidoModel> lista,
      List<List<AdicionalModel>> listaAdicionales) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height,
          //color: Colors.amber,
          child: Column(
            children: [
              Container(
                height: 60,
                padding: const EdgeInsets.all(10),
                child: Center(
                  child: Text(
                    "Lista de productos",
                    //MediaQuery.of(context).size.height.toString(),
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.green.shade600),
                    textAlign: TextAlign.start,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  //height: MediaQuery.of(context).size.height - 100,
                  //color: Colors.red,
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: ListView.builder(
                    padding: const EdgeInsets.all(10),
                    itemCount: lista.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () async {},
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(0, 0, 10, 10),
                          decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width,
                                child: Text(
                                  "${lista[index].producto!.nombreProducto}",
                                  style: const TextStyle(
                                    fontSize: 18,
                                    //fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.start,
                                ),
                              ),
                              (listaAdicionales[index].isNotEmpty)
                                  ? Detalle(
                                      listaDetalle: listaAdicionales[index])
                                  : const Text(
                                      "- SIN DETALLE",
                                      style: TextStyle(
                                          fontSize: 14,
                                          // fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                      textAlign: TextAlign.start,
                                    ),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                child: Text(
                                  "${lista[index].cantidadDetalle} x ${lista[index].precioDetalle} = ${lista[index].cantidadDetalle! * lista[index].precioDetalle!}",
                                  style: const TextStyle(
                                    fontSize: 18,
                                    //fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.end,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class Detalle extends StatelessWidget {
  List<AdicionalModel> listaDetalle;

  Detalle({required this.listaDetalle});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: (20 * listaDetalle.length).toDouble(),
      width: MediaQuery.of(context).size.width / 2,
      color: Colors.transparent,
      child: ListView.builder(
        itemCount: listaDetalle.length,
        itemBuilder: (context, index) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "- ${listaDetalle[index].nombreAdicional}",
                style: const TextStyle(fontSize: 14, color: Colors.black),
                textAlign: TextAlign.start,
              ),
            ],
          );
        },
      ),
    );
  }
}
