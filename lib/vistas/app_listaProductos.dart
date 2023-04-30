import 'package:app_jugueria/componentes/app_drawer.dart';
import 'package:app_jugueria/controladores/productoController.dart';
import 'package:app_jugueria/controladores/categoriaController.dart';
import 'package:app_jugueria/vistas/app_registrarProductos.dart';
import 'package:app_jugueria/modelos/productoModel.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

class AppListaProducto extends StatefulWidget {
  List<ProductoModel> data;

  AppListaProducto(this.data, {Key? key}) : super(key: key);
  @override
  State<AppListaProducto> createState() {
    return _AppListaProductoState();
  }
}

class _AppListaProductoState extends State<AppListaProducto> {
  // List<ProductoModel>? data;

// Future<List<CategoriaModel>>
  Future<List<ProductoModel>> obtenerProductos() async {
    ProductoController productoCtrll = ProductoController();
    final lista = productoCtrll.getProductos();

    return lista;
    // print(lista);
    // print(lista);
    // var datos = jsonDecode(lista);
    // CategoriaModel.fromJson(lista);
  }

  void initState() {
    super.initState();
    obtenerProductos().then((value) => {
          // data = List<CategoriaModel>;
          setState(() {
            // for (var elemento in value) {
            //   data elemento);
            // }
            widget.data = value;
          })
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Lista de productos"),
        backgroundColor: Colors.amber,
        actions: <Widget>[
          IconButton(
            onPressed: () async {
              CategoriaController categoriaCtrll = CategoriaController();
              final lista = await categoriaCtrll.getCategorias();
              Navigator.of(context).pop();
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AppRegistroProducto(lista)));
            },
            icon: FaIcon(FontAwesomeIcons.plus),
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
        padding: const EdgeInsets.all(15),
        itemCount: widget.data.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {},
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(
                  child: Image.memory(
                    base64.decode(widget.data[index].imagenProducto),
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  widget.data[index].nombreProducto,
                  style: const TextStyle(
                    fontSize: 15,
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  "Precio: ${widget.data[index].precioProducto.toString()}",
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
