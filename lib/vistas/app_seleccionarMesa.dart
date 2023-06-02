import 'package:app_jugueria/componentes/info_global.dart';
import 'package:app_jugueria/modelos/mesaModel.dart';
import 'package:app_jugueria/controladores/mesaController.dart';
import 'package:app_jugueria/controladores/productoController.dart';
import 'package:app_jugueria/componentes/app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AppSeleccionarMesa extends StatefulWidget {
  //List<MesaModel>? data;

  //AppSeleccionarMesa({this.data, Key? key}) : super(key: key);
  @override
  State<AppSeleccionarMesa> createState() {
    return AppSeleccionarMesaState();
  }
}

class AppSeleccionarMesaState extends State<AppSeleccionarMesa> {
  List<MesaModel>? listaMesas = [];

  _cargarMesas() async {
    MesaController mesaCtrll = MesaController();
    final lista = await mesaCtrll.getMesas();
    setState(() {
      listaMesas = lista;
    });
  }

  @override
  void initState() {
    super.initState();
    _cargarMesas();
    //loadModel();
    // _loadClassifier();
    // inicializarCamara();
  }

  @override
  Widget build(BuildContext context) {
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

                InfoGlobal.mesaModel = listaMesas![index];
                ProductoController productoCtrll = ProductoController();
                final listaProductos = await productoCtrll.getProductos();
                Navigator.pushNamed(context, '/seleccionar-productos',
                    arguments: listaProductos);
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
                                  color: (listaMesas![index].ocupadoMesa == 1)
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
  }
}
