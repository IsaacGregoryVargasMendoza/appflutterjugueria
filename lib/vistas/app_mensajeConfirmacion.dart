import 'package:flutter/material.dart';
import 'package:app_jugueria/componentes/info_global.dart';
import 'package:app_jugueria/modelos/pedidoModel.dart';
import 'package:intl/intl.dart';

class AppMensajeConfirmacion extends StatefulWidget {
  PedidoModel pedidoModel;

  AppMensajeConfirmacion({required this.pedidoModel, Key? key})
      : super(key: key);
  @override
  State<AppMensajeConfirmacion> createState() {
    return AppMensajeConfirmacionState();
  }
}

class AppMensajeConfirmacionState extends State<AppMensajeConfirmacion> {
  @override
  void dispose() {
    super.dispose();
    cargarMesas();
  }

  cargarMesas() {
    Navigator.pop(context);
    Navigator.pop(context);
    Navigator.pop(context);
    Navigator.pop(context);
    Navigator.pop(context);
    InfoGlobal.decrementarVentanas();
    InfoGlobal.decrementarVentanas();
    InfoGlobal.decrementarVentanas();
    InfoGlobal.decrementarVentanas();
    Navigator.pushNamed(context, '/seleccionar-mesas');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.orange.shade600,
                Colors.green.shade700
              ], // Colores degradados
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(0, 70, 0, 0),
                width: MediaQuery.of(context).size.width / 4,
                child: Image.asset("assets/logo.png"),
              ),
              Container(
                width: MediaQuery.of(context).size.width / 4 * 3,
                height: MediaQuery.of(context).size.height / 4 * 2.5,
                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                // color: Colors.white,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadiusDirectional.only(
                        topStart: Radius.elliptical(40, 180),
                        topEnd: Radius.elliptical(180, 40),
                        bottomEnd: Radius.elliptical(10, 10),
                        bottomStart: Radius.elliptical(10, 10))),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "¡Pedido confirmado!",
                      style: TextStyle(
                          fontSize: 22,
                          color: Colors.green.shade700,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.end,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "S/${NumberFormat("#,##0.00").format(widget.pedidoModel.totalPedido)}",
                      style: TextStyle(
                          fontSize: 40,
                          color: Colors.green.shade700,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.end,
                    ),
                    const SizedBox(height: 15),
                    Flexible(
                      child: Text(
                        "${widget.pedidoModel.cliente!.nombreCliente} ${widget.pedidoModel.cliente!.apellidoCliente}",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      "${widget.pedidoModel.fechaPedido}",
                      style: TextStyle(fontSize: 16, color: Colors.black),
                      textAlign: TextAlign.end,
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                          border: BorderDirectional(
                        bottom:
                            BorderSide(width: 1, color: Colors.grey.shade500),
                        top: BorderSide(width: 1, color: Colors.grey.shade500),
                      )),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "N° pedido:",
                            style: TextStyle(
                                fontSize: 16, color: Colors.grey.shade500),
                            textAlign: TextAlign.end,
                          ),
                          Text(
                            "${widget.pedidoModel.id}",
                            style: TextStyle(fontSize: 16, color: Colors.black),
                            textAlign: TextAlign.end,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "¡Gracias por su compra!",
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.green.shade700,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.end,
                    ),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        cargarMesas();
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
                    )
                  ],
                ),
              ),
            ],
          )),
    );
  }
}
