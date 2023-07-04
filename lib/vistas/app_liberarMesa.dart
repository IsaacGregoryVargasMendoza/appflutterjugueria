import 'package:app_jugueria/componentes/info_global.dart';
import 'package:app_jugueria/modelos/mesaModel.dart';
import 'package:app_jugueria/controladores/mesaController.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:app_jugueria/componentes/app_drawer.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class AppLiberarMesa extends StatefulWidget {
  @override
  State<AppLiberarMesa> createState() {
    return AppLiberarMesaState();
  }
}

enum WidgetState { NONE, LOADING, LOADED, ERROR }

class AppLiberarMesaState extends State<AppLiberarMesa> {
  List<MesaModel>? listaMesas = [];
  WidgetState _widgetState = WidgetState.LOADED;
  Timer? consultaTimer;
  DateTime? lastBackPressed;

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
              'Liberar',
              style: TextStyle(color: Colors.black),
            ),
          ),
          // ),
        ),
        const SizedBox(
          height: 5,
        ),
        // Container(
        //   color: Colors.amber,
        //   width: MediaQuery.of(context).size.width,
        //   child: TextButton(
        //     onPressed: () {
        //       Navigator.of(context).pop('Opción 2');
        //     },
        //     child: Text(
        //       'Punto final',
        //       style: TextStyle(color: Colors.black),
        //     ),
        //   ),
        // ),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
    InfoGlobal.decrementarVentanas();
    consultaTimer?.cancel();
  }

  void iniciarConsultaPeriodica() {
    // Detener el Timer si ya está en ejecución
    if (consultaTimer != null && consultaTimer!.isActive) {
      consultaTimer!.cancel();
    }

    // Iniciar el Timer para ejecutar la consulta cada 5 segundos
    consultaTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      debugPrint("Se cargo las mesas");
      _cargarMesas();
    });
  }

  _cargarMesas() async {
    setState(() {
      _widgetState = WidgetState.LOADING;
    });

    listaMesas = [];

    try {
      MesaController mesaCtrll = MesaController();
      final lista = await mesaCtrll.getMesas();
      setState(() {
        listaMesas = lista;
        _widgetState = WidgetState.LOADED;
      });
    } catch (e) {
      setState(() {
        _widgetState = WidgetState.ERROR;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _cargarMesas();
    //iniciarConsultaPeriodica();
  }

  Future<void> liberarMesa(int idMesa) async {
    MesaController mesaController = MesaController();
    await mesaController.freeMesa(idMesa);
    InfoGlobal.mensajeConfirmacion(context, "Mesa liberada correctamente.");
    _cargarMesas();
  }

  // Future<void> cargarNuevaInterfaz(MesaModel mesaModel) async {
  //   setState(() {
  //     _widgetState = WidgetState.LOADING;
  //   });

  //   InfoGlobal.mesaModel = mesaModel;
  //   ProductoController productoCtrll = ProductoController();
  //   final listaProductos = await productoCtrll.getProductos();

  //   Navigator.pushNamed(context, '/seleccionar-productos',
  //       arguments: listaProductos);
  //   setState(() {
  //     _widgetState = WidgetState.LOADED;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    switch (_widgetState) {
      case WidgetState.NONE:
      case WidgetState.LOADING:
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: const Text("Liberar mesa"),
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
        return WillPopScope(
          onWillPop: () async {
            debugPrint("se preciono dos vecsdadsaes");
            InfoGlobal.mensajeInformativo(
                context, "Preciona 2 veces para salir.",
                duracion: 1);

            bool isDoubleBackPressed = false;
            DateTime currentTime = DateTime.now();

            if (lastBackPressed != null &&
                currentTime.difference(lastBackPressed!) <=
                    Duration(milliseconds: 500)) {
              debugPrint("Entro");
              isDoubleBackPressed = true;
            }

            lastBackPressed = currentTime;

            if (isDoubleBackPressed) {
              SystemChannels.platform.invokeMethod('SystemNavigator.pop');
              //Navigator.of(context).pop();
              // Navigator.of(context).pop();
            }

            return false;
          },
          child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: const Text("Liberar mesa"),
              backgroundColor: Colors.green.shade900,
              actions: <Widget>[
                IconButton(
                  onPressed: () {
                    _cargarMesas();
                  },
                  icon: const FaIcon(FontAwesomeIcons.spinner),
                  // hoverColor: Colors.black,
                ),
              ],
            ),
            drawer: AppMenuDrawer(),
            body: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Dos columnas
                mainAxisSpacing: 10, // Espacio vertical entre los elementos
                crossAxisSpacing: 10, // Espacio horizontal entre los elementos
              ),
              itemCount: listaMesas!.length,
              padding: const EdgeInsets.all(20),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () async {
                    if (listaMesas![index].ocupadoMesa == 1) {
                      print(listaMesas![index].numeroMesa);

                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return seleccionarPunto(context);
                        },
                      ).then((value) {
                        if (value == 'Opción 1') {
                          liberarMesa(listaMesas![index].id!);
                          debugPrint("Liberar mesa");
                          //onTab(latLng);
                        } else if (value == 'Opción 2') {
                          debugPrint("nada");
                        }
                      });

                      // InfoGlobal.mesaModel = listaMesas![index];
                      // ProductoController productoCtrll = ProductoController();
                      // final listaProductos = await productoCtrll.getProductos();
                      // Navigator.pushNamed(context, '/seleccionar-productos',
                      //     arguments: listaProductos);

                      //await cargarNuevaInterfaz(listaMesas![index]);
                    }
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Expanded(
                        child: Stack(
                          children: [
                            const Center(
                              child: Image(
                                image: AssetImage("assets/mesa.jpg"),
                                fit: BoxFit.fill,
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: (listaMesas![index].ocupadoMesa == 1)
                                    ? Colors.white.withOpacity(0.5)
                                    : Colors.transparent,
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height,
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      listaMesas![index].numeroMesa!,
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color:
                                            (listaMesas![index].ocupadoMesa ==
                                                    1)
                                                ? Colors.black.withOpacity(0.5)
                                                : Colors.black,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ]),
                            ),
                          ],
                        ),
                      ),
                      // const SizedBox(height: 5),
                      // Text(
                      //   listaMesas![index].numeroMesa!,
                      //   style: const TextStyle(
                      //     fontSize: 16,
                      //     fontWeight: FontWeight.bold,
                      //   ),
                      //   textAlign: TextAlign.center,
                      // ),
                    ],
                  ),
                );
              },
            ),
            //: Text("Sin datos"),
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
