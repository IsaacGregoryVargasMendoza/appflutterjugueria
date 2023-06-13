import 'dart:convert';

import 'package:app_jugueria/componentes/info_global.dart';
import 'package:app_jugueria/controladores/pedidoController.dart';
import 'package:app_jugueria/modelos/pedidoModel.dart';
import 'package:app_jugueria/modelos/productoModel.dart';
import 'package:app_jugueria/modelos/adicionalModel.dart';
import 'package:app_jugueria/modelos/comprobanteModel.dart';
import 'package:app_jugueria/componentes/app_textField.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:camera/camera.dart';
import 'package:intl/intl.dart';
import 'dart:io';

class AppConfirmarPedido extends StatefulWidget {
  List<ProductoModel>? productos;
  List<int>? cantidades;
  List<List<AdicionalModel>>? listaDetalle;
  double total;

  AppConfirmarPedido(
      {this.productos,
      this.cantidades,
      this.listaDetalle,
      required this.total,
      Key? key})
      : super(key: key);
  @override
  State<AppConfirmarPedido> createState() {
    return AppConfirmarPedidoState();
  }
}

enum WidgetState { NONE, LOADING, LOADED, ERROR }

const kAnalyzingTextStyle = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 20.0,
    color: Colors.black,
    decoration: TextDecoration.none);

const kPreguntaTextStyle = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 16.0,
    fontWeight: FontWeight.bold,
    color: Colors.red,
    decoration: TextDecoration.none);

class AppConfirmarPedidoState extends State<AppConfirmarPedido> {
  WidgetState _widgetState = WidgetState.LOADED;
  CameraImage? cameraImage;
  File? imagen;
  TextEditingController numeroDocumentoController = TextEditingController();
  TextEditingController denominacionClienteController = TextEditingController();
  TextEditingController direccionClienteController = TextEditingController();

  final picker = ImagePicker();
  int indice = -1;
  String preguntaActual = "¿DESEA CONFIRMAR PEDIDO?";
  List<AdicionalModel> listaAdicionales = [];
  List<List<AdicionalModel>> listaDetalle = [];

  int idComprobante = 0;
  List<ComprobanteModel>? comprobantes = [];
  String _serie = "";
  String _comprobante = "";

  @override
  void initState() {
    super.initState();
    listaDetalle = List<List<AdicionalModel>>.generate(
        widget.productos!.length, (index) => []);
    _cargarComprobante();
  }

  void _cargarComprobante() async {
    PedidoController pedidoCtrll = PedidoController();
    final lista = await pedidoCtrll.getComprobantes();
    setState(() {
      comprobantes = lista;
    });
  }

  void _obtenerSerieyCorrelativo(ComprobanteModel comprobante) {
    setState(() {
      _comprobante = comprobante.nombreComprobante!;
      _serie =
          "${comprobante.serieComprobante!.toString()}-${comprobante.correlativoComprobante.toString().padLeft(8, '0')}";
    });
  }

  Future<void> registrarVenta() async {
    setState(() {
      _widgetState = WidgetState.LOADING;
    });

    try {
      PedidoController pedidoCtrll = PedidoController();
      PedidoModel pedidoModel = PedidoModel(
        cliente: InfoGlobal.clienteModel,
        mesa: InfoGlobal.mesaModel,
        numeroDocumento: numeroDocumentoController.text,
        denominacionCliente: denominacionClienteController.text,
        direccionCliente: direccionClienteController.text,
        comprobante: ComprobanteModel(id: idComprobante),
        fechaPedido: DateFormat('dd/MM/yyyy hh:mm:ss').format(DateTime.now()),
        seriePedido: _serie.split("-")[0],
        correlativoPedido: _serie.split("-")[1],
        subTotalPedido: widget.total / 1.18,
        igvPedido: widget.total / 1.18 * 0.18,
        totalPedido: widget.total,
      );

      pedidoModel = pedidoCtrll.llenarPedido(pedidoModel, widget.productos!,
          widget.listaDetalle!, widget.cantidades!);

      var pedidoConfirmado = await pedidoCtrll.addPedido(pedidoModel);

      Navigator.pushNamed(context, '/mensaje-confirmacion',
          arguments: pedidoConfirmado);
      print("Se registro los datos con exito.");
      setState(() {
        _widgetState = WidgetState.LOADED;
      });
    } catch (e) {
      mostrarAlerta(context, "Error!", "No se pudo registrar la compra.");
      print("Excepcion capturada");
      print(e.toString());
      setState(() {
        _widgetState = WidgetState.ERROR;
      });
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

  @override
  Widget build(BuildContext context) {
    switch (_widgetState) {
      case WidgetState.NONE:
      case WidgetState.LOADING:
        return _buildScaffold(
            context,
            Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: Colors.amber.shade900),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Registrando...",
                      style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 20.0,
                          color: Colors.black,
                          decoration: TextDecoration.none),
                    )
                  ]),
            ));
      case WidgetState.LOADED:
        return _buildScaffold(
          context,
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: ListView(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "${preguntaActual}",
                      style: kPreguntaTextStyle,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                      margin: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                      // color: Colors.blue,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              const Text(
                                "Comprobante: ",
                                style: kPreguntaTextStyle,
                                textAlign: TextAlign.left,
                              ),
                              Container(
                                width: 150,
                                child: DropdownButtonFormField(
                                    decoration: const InputDecoration(
                                        border: InputBorder.none),
                                    //value: 1,
                                    borderRadius: BorderRadius.circular(15),
                                    items: comprobantes!.map((comprobante) {
                                      return DropdownMenuItem(
                                          child: Text(
                                              comprobante.nombreComprobante!),
                                          value: comprobante.id);
                                    }).toList(),
                                    onChanged: (value) async {
                                      idComprobante = value!;
                                      numeroDocumentoController.text = "";
                                      denominacionClienteController.text = "";
                                      direccionClienteController.text = "";
                                      PedidoController pedidoCtrll =
                                          PedidoController();
                                      var comprobante = await pedidoCtrll
                                          .getComprobante(value);
                                      _obtenerSerieyCorrelativo(comprobante);
                                    }),
                              )
                            ],
                          ),
                          (idComprobante > 1)
                              ? Container(
                                  child: Column(
                                    children: [
                                      const Row(
                                        children: [
                                          Text(
                                            "Datos del comprobante:",
                                            style: kPreguntaTextStyle,
                                            //textAlign: TextAlign.left,
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            (idComprobante == 2)
                                                ? "DNI: "
                                                : (idComprobante == 3)
                                                    ? "RUC: "
                                                    : "NINGUNO: ",
                                            style: kPreguntaTextStyle,
                                          ),
                                          AppTextField(
                                            backgroundColor: Colors.white,
                                            borderColor: const Color.fromRGBO(
                                                255, 255, 255, 1),
                                            fontSize: 14,
                                            height: 30,
                                            width: 150,
                                            funcion: () {},
                                            text: "",
                                            textColor: Colors.black,
                                            controlador:
                                                numeroDocumentoController,
                                          ),
                                          Container(
                                            margin: EdgeInsets.all(0),
                                            padding: EdgeInsets.all(0),
                                            decoration: BoxDecoration(
                                              color: Colors.green,
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            child: TextButton(
                                              onPressed: () async {
                                                PedidoController pedidoCtrll =
                                                    PedidoController();
                                                if (idComprobante == 2) {
                                                  String jsonString =
                                                      await pedidoCtrll.getPersona(
                                                          numeroDocumentoController
                                                              .text);
                                                  var json =
                                                      jsonDecode(jsonString);
                                                  denominacionClienteController
                                                          .text =
                                                      "${json["apellidoPaterno"]} ${json["apellidoMaterno"]} ${json["nombres"]}";
                                                  // " " +
                                                  // json["apellidoMaterno"] +
                                                  // " " +
                                                  // json["nombres"];
                                                } else if (idComprobante == 3) {
                                                  String jsonString =
                                                      await pedidoCtrll.getEmpresa(
                                                          numeroDocumentoController
                                                              .text);
                                                  var json =
                                                      jsonDecode(jsonString);
                                                  denominacionClienteController
                                                          .text =
                                                      json["razonSocial"];
                                                }
                                              },
                                              child: const Center(
                                                child: Text(
                                                  "Buscar",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            (idComprobante == 2)
                                                ? "Nombre: "
                                                : (idComprobante == 3)
                                                    ? "Razon Social: "
                                                    : "NINGUNO: ",
                                            style: kPreguntaTextStyle,
                                            textAlign: TextAlign.left,
                                          ),
                                          AppTextField(
                                            backgroundColor: Colors.white,
                                            borderColor: const Color.fromRGBO(
                                                255, 255, 255, 1),
                                            fontSize: 12,
                                            height: 30,
                                            width: 200,
                                            funcion: () {},
                                            text: "",
                                            textColor: Colors.black,
                                            controlador:
                                                denominacionClienteController,
                                          )
                                        ],
                                      ),
                                      (idComprobante > 2)
                                          ? Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                const Text(
                                                  "Direccion: ",
                                                  style: kPreguntaTextStyle,
                                                  textAlign: TextAlign.left,
                                                ),
                                                AppTextField(
                                                  backgroundColor: Colors.white,
                                                  borderColor:
                                                      const Color.fromRGBO(
                                                          255, 255, 255, 1),
                                                  fontSize: 14,
                                                  height: 30,
                                                  width: 200,
                                                  funcion: () {},
                                                  text: "",
                                                  textColor: Colors.black,
                                                  controlador:
                                                      direccionClienteController,
                                                )
                                              ],
                                            )
                                          : const SizedBox(
                                              height: 0,
                                            )
                                    ],
                                  ),
                                )
                              : const SizedBox(
                                  height: 0,
                                )
                        ],
                      ),
                    ),
                    Container(
                        padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                        margin: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.amber.shade300,
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                const Text(
                                  "Cliente: ",
                                  style: kPreguntaTextStyle,
                                  textAlign: TextAlign.left,
                                ),
                                Text(
                                  "${InfoGlobal.clienteModel!.nombreCliente} ${InfoGlobal.clienteModel!.apellidoCliente}",
                                  style: const TextStyle(
                                      fontFamily: 'Roboto',
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      decoration: TextDecoration.none),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                const Text(
                                  "Mesa: ",
                                  style: kPreguntaTextStyle,
                                ),
                                Text(
                                  "${InfoGlobal.mesaModel!.numeroMesa}",
                                  style: const TextStyle(
                                      fontFamily: 'Roboto',
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      decoration: TextDecoration.none),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                const Text(
                                  "Subtotal: ",
                                  style: kPreguntaTextStyle,
                                  textAlign: TextAlign.left,
                                ),
                                Text(
                                  "S/.${NumberFormat("#,##0.00").format(widget.total / 1.18)}",
                                  style: const TextStyle(
                                      fontFamily: 'Roboto',
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      decoration: TextDecoration.none),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                const Text(
                                  "IGV: ",
                                  style: kPreguntaTextStyle,
                                  textAlign: TextAlign.left,
                                ),
                                Text(
                                  "S/.${NumberFormat("#,##0.00").format(widget.total / 1.18 * 0.18)}",
                                  style: const TextStyle(
                                      fontFamily: 'Roboto',
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      decoration: TextDecoration.none),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                const Text(
                                  "Total: ",
                                  style: kPreguntaTextStyle,
                                  textAlign: TextAlign.left,
                                ),
                                Text(
                                  "S/.${NumberFormat("#,##0.00").format(widget.total)}",
                                  style: const TextStyle(
                                      fontFamily: 'Roboto',
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      decoration: TextDecoration.none),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                const Text(
                                  "Comprobante: ",
                                  style: kPreguntaTextStyle,
                                  textAlign: TextAlign.left,
                                ),
                                Text(
                                  "${_comprobante}",
                                  style: const TextStyle(
                                      fontFamily: 'Roboto',
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      decoration: TextDecoration.none),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                const Text(
                                  "Serie: ",
                                  style: kPreguntaTextStyle,
                                  textAlign: TextAlign.left,
                                ),
                                Text(
                                  "${_serie}",
                                  style: const TextStyle(
                                      fontFamily: 'Roboto',
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      decoration: TextDecoration.none),
                                ),
                              ],
                            ),
                          ],
                        )),
                    const SizedBox(
                      height: 10,
                    ),
                    DetalleProductos(
                      listaProductos: widget.productos!,
                      listaDetalle: widget.listaDetalle,
                      listaCantidades: widget.cantidades!,
                    ),
                    GestureDetector(
                      onTap: () async {
                        await registrarVenta();
                      },
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          image: const DecorationImage(
                            image: AssetImage("assets/ok.png"),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {},
                      child: const Text(
                        "Confirmar",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );

      case WidgetState.ERROR:
        return _buildScaffold(
            context,
            const Center(
              child: Text("No se pudo cargar los datos."),
            ));
    }
  }

  Widget _buildScaffold(BuildContext context, Widget body) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: body,
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
          return GestureDetector(
            onTap: () {
              // print(listaProductos[index].id);
              // print(listaProductos[index].nombreProducto);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "- ${listaDetalle[index].nombreAdicional}",
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                  textAlign: TextAlign.end,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
//Mostrare una lista de los productos con sus detalles ejemplo
//sanguche de pollo:
//Mayonesa, aji cebolla y apio

//jugo de papaya
//sin helar y sin azucar
class DetalleProductos extends StatelessWidget {
  final List<ProductoModel> listaProductos;
  final List<int> listaCantidades;
  final List<List<AdicionalModel>>? listaDetalle;

  DetalleProductos(
      {required this.listaProductos,
      required this.listaCantidades,
      required this.listaDetalle});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 300,
      margin: const EdgeInsets.fromLTRB(5, 0, 5, 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey.shade100,
      ),
      child: Stack(children: <Widget>[
        ListView.builder(
          padding: const EdgeInsets.all(2),
          itemCount: listaProductos.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                // print(listaProductos[index].id);
                // print(listaProductos[index].nombreProducto);
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding:
                        const EdgeInsetsDirectional.fromSTEB(20, 10, 20, 10),
                    decoration: const BoxDecoration(
                        // color: Colors.white,
                        // border: BorderDirectional(
                        //   bottom: BorderSide(width: 0.5),
                        // ),
                        ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: 170, // Ancho máximo permitido
                              child: Text(
                                "${listaProductos[index].nombreProducto}",
                                style: const TextStyle(
                                  fontSize: 16,
                                  // fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.start,
                                overflow: TextOverflow
                                    .ellipsis, // Recorta el texto y muestra puntos suspensivos al final
                                maxLines: 1, // Limita el texto a una sola línea
                              ),
                            ),
                            Text(
                              "S/.${listaProductos[index].precioProducto} x ${listaCantidades[index]} = S/.${listaProductos[index].precioProducto! * listaCantidades[index]}",
                              style: const TextStyle(
                                fontSize: 16,
                                // fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.start,
                              overflow: TextOverflow
                                  .ellipsis, // Recorta el texto y muestra puntos suspensivos al final
                              maxLines: 1, // Limita el texto a una sola línea
                            ),
                          ],
                        ),
                        (listaDetalle![index].isNotEmpty)
                            ? Detalle(
                                listaDetalle: listaDetalle![index],
                              )
                            : const Text(
                                "Sin Detalle",
                                style: TextStyle(
                                  fontSize: 16,
                                  // fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.start,
                              ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ]),
    );
  }
}
