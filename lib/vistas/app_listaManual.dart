import 'package:app_jugueria/controladores/manualController.dart';
import 'package:app_jugueria/componentes/info_global.dart';
import 'package:app_jugueria/modelos/manualModel.dart';
import 'package:app_jugueria/modelos/productoModel.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

enum WidgetState { NONE, LOADING, LOADED, ERROR }

class AppListaManual extends StatefulWidget {
  AppListaManual({Key? key}) : super(key: key);
  @override
  State<AppListaManual> createState() {
    return AppListaManualState();
  }
}

class AppListaManualState extends State<AppListaManual> {
  List<ManualModel> data = [];
  late List<ProductoModel> listAuxProductos;
  WidgetState _widgetState = WidgetState.LOADED;

  Future<void> obtenerInstrucciones() async {
    setState(() {
      _widgetState = WidgetState.LOADING;
    });

    ManualController manualCtrll = ManualController();
    final lista = await manualCtrll.getManualClientes();

    setState(() {
      data = lista;
      _widgetState = WidgetState.LOADED;
    });
  }

  void initState() {
    super.initState();
    obtenerInstrucciones();
  }

  @override
  void dispose() {
    super.dispose();
    InfoGlobal.decrementarVentanas();
  }

  Widget seleccionarPunto(BuildContext context) {
    return AlertDialog(
      title: Text('Acciones'),
      actions: [
        Container(
          color: Colors.yellow.shade600,
          width: MediaQuery.of(context).size.width,
          child: TextButton(
            onPressed: () {
              Navigator.of(context).pop('Opción 1');
            },
            child: const Text(
              'Editar',
              style: TextStyle(color: Colors.black),
            ),
          ),
          // ),
        ),
        const SizedBox(
          height: 5,
        ),
        Container(
          color: Colors.red.shade400,
          width: MediaQuery.of(context).size.width,
          child: TextButton(
            onPressed: () {
              Navigator.of(context).pop('Opción 2');
            },
            child: const Text(
              'Eliminar',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    switch (_widgetState) {
      case WidgetState.NONE:
      case WidgetState.LOADING:
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: const Text("Manual de usuario"),
            backgroundColor: Colors.green.shade900,
          ),
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
            title: const Text("Manual de usuario"),
            backgroundColor: Colors.green.shade900,
            actions: <Widget>[
              IconButton(
                onPressed: () async {
                  Navigator.of(context).pushNamed("/registrar-manual");
                },
                icon: const FaIcon(FontAwesomeIcons.plus),
              ),
            ],
          ),
          body: Column(
            children: [
              Expanded(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height - 280,
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () async {
                          debugPrint("dasdasda");
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return seleccionarPunto(context);
                            },
                          ).then((value) {
                            if (value == 'Opción 1') {
                              Navigator.pushNamed(context, "/editar-manual",
                                  arguments: data[index]);
                              
                              debugPrint("Liberar mesa");
                            } else if (value == 'Opción 2') {
                              debugPrint("nada");
                            }
                          });
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 7,
                                offset: const Offset(
                                    0, 3), // cambia la posición de la sombra
                              ),
                            ],
                            borderRadius: BorderRadius.circular(25),
                            border: Border.all(
                              style: BorderStyle.solid,
                              width: 0.5,
                              color: Colors.white,
                            ),
                            color: Colors.white,
                          ),
                          margin: const EdgeInsets.fromLTRB(10, 20, 10, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 100,
                                height: 100,
                                margin: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                    image: MemoryImage(
                                      base64.decode(
                                        data[index].imagenManual!,
                                      ),
                                    ),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width - 150,
                                height: 100,
                                padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                                // color: Colors.blue,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("PASO ${data[index].pasoManual!}",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.left),
                                    Flexible(
                                      child: Text(
                                        "${data[index].descripcionManual!}",
                                        style: const TextStyle(
                                          color: Colors.black,
                                        ),
                                        textAlign: TextAlign.left,
                                      ),
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
                ),
              ),
            ],
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
}
