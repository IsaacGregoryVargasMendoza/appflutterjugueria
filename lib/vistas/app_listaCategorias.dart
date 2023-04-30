import 'package:app_jugueria/vistas/app_registrarCategorias.dart';
import 'package:app_jugueria/componentes/app_drawer.dart';
import 'package:app_jugueria/modelos/categoriaModel.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AppListaCategoria extends StatefulWidget {
  List<CategoriaModel> data;

  AppListaCategoria(this.data, {Key? key}) : super(key: key);
  @override
  State<AppListaCategoria> createState() {
    return _AppListaCategoriaState();
  }
}

class _AppListaCategoriaState extends State<AppListaCategoria> {
  // List<CategoriaModel>? data;

  // Future<List<CategoriaModel>> obtenerCategorias() async {
  //   CategoriaController categoriaCtrll = CategoriaController();
  //   final lista = categoriaCtrll.getCategorias();

  //   return lista;
  // }

  // void initState() {
  //   super.initState();
  //   obtenerCategorias().then((value) => {
  //         // data = List<CategoriaModel>;
  //         setState(() {
  //           // for (var elemento in value) {
  //           //   data elemento);
  //           // }
  //           data = value;
  //         })
  //       });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Lista de categorias"),
        backgroundColor: Colors.amber,
        actions: <Widget>[
          IconButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AppRegistroCategoria()));
            },
            icon: FaIcon(FontAwesomeIcons.plus),
            // hoverColor: Colors.black,
          ),
        ],
      ),
      drawer: AppMenuDrawer(),
      body: Stack(children: <Widget>[
        ListView.builder(
          // gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          //   crossAxisCount: 1, // Dos columnas
          //   mainAxisSpacing: 10, // Espacio vertical entre los elementos
          //   crossAxisSpacing: 10, // Espacio horizontal entre los elementos
          // ),
          padding: EdgeInsets.all(20),
          itemCount: widget.data.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                print(widget.data[index].id);
                print(widget.data[index].nombreCategoria);
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  // Flexible(
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding:
                        const EdgeInsetsDirectional.fromSTEB(20, 10, 0, 10),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      border: BorderDirectional(
                        bottom: BorderSide(width: 1),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "ID: ${widget.data[index].id} \nCategoria: ${widget.data[index].nombreCategoria}",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.start,
                        ),
                        // FaIcon(FontAwesomeIcons.pencil)
                      ],
                    ),
                  ),
                  // ),
                  // SizedBox(height: 5),
                  // Text(
                  //   "Producto ${data![index].nombreCategoria}",
                  //   style: const TextStyle(
                  //     fontSize: 16,
                  //     fontWeight: FontWeight.bold,
                  //   ),
                  //   textAlign: TextAlign.center,
                  // ),
                  // SizedBox(height: 15),
                ],
              ),
            );
          },
        ),
      ]),

      // body: Container(
      //   color: Colors.white,
      //   child: ListView.builder(
      //     itemCount: data!.length,
      //     itemBuilder: (BuildContext context, int index) {
      //       return Container(
      //         color: Colors.amber,
      //         child: Text(
      //           data![index].nombreCategoria,
      //           style: TextStyle(fontSize: 30),
      //         ),
      //       );
      //     },
      //   ),
      // ),
    );
  }
}
