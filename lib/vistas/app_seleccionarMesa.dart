import 'package:app_jugueria/componentes/info_global.dart';
import 'package:app_jugueria/modelos/mesaModel.dart';
import 'package:app_jugueria/controladores/mesaController.dart';
import 'package:app_jugueria/controladores/productoController.dart';
import 'package:app_jugueria/componentes/app_drawer.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class AppSeleccionarMesa extends StatefulWidget {
  @override
  State<AppSeleccionarMesa> createState() {
    return AppSeleccionarMesaState();
  }
}

enum WidgetState { NONE, LOADING, LOADED, ERROR }

class AppSeleccionarMesaState extends State<AppSeleccionarMesa> {
  List<MesaModel>? listaMesas = [];
  WidgetState _widgetState = WidgetState.LOADED;
  Timer? consultaTimer;

  @override
  void dispose() {
    super.dispose();
    InfoGlobal.decrementarVentanas();
  }

  void iniciarConsultaPeriodica() {
    // Detener el Timer si ya está en ejecución
    // if (consultaTimer != null && consultaTimer!.isActive) {
    //   consultaTimer!.cancel();
    // }

    // Iniciar el Timer para ejecutar la consulta cada 5 segundos
    consultaTimer = Timer.periodic(Duration(seconds: 10), (timer) {
      _cargarMesas();
    });
  }

  _cargarMesas() async {
    setState(() {
      _widgetState = WidgetState.LOADING;
    });

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
    iniciarConsultaPeriodica();
  }

  Future<void> cargarNuevaInterfaz(MesaModel mesaModel) async {
    setState(() {
      _widgetState = WidgetState.LOADING;
    });

    InfoGlobal.mesaModel = mesaModel;
    ProductoController productoCtrll = ProductoController();
    final listaProductos = await productoCtrll.getProductos();

    Navigator.pushNamed(context, '/seleccionar-productos',
        arguments: listaProductos);
    setState(() {
      _widgetState = WidgetState.LOADED;
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (_widgetState) {
      case WidgetState.NONE:
      case WidgetState.LOADING:
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: const Text("Seleccionar mesa"),
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
            title: const Text("Seleccionar mesa"),
            backgroundColor: Colors.green.shade900,
            // actions: <Widget>[
            //   IconButton(
            //     onPressed: () {
            //       Navigator.of(context).pop();
            //       Navigator.pushNamed(context, '/registrar-mesa');
            //     },
            //     icon: const FaIcon(FontAwesomeIcons.plus),
            //     // hoverColor: Colors.black,
            //   ),
            // ],
          ),
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
                  if (listaMesas![index].ocupadoMesa == 0) {
                    print(listaMesas![index].numeroMesa);

                    // InfoGlobal.mesaModel = listaMesas![index];
                    // ProductoController productoCtrll = ProductoController();
                    // final listaProductos = await productoCtrll.getProductos();
                    // Navigator.pushNamed(context, '/seleccionar-productos',
                    //     arguments: listaProductos);

                    await cargarNuevaInterfaz(listaMesas![index]);
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
                                          (listaMesas![index].ocupadoMesa == 1)
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
