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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Lista de categorias"),
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
            icon: const FaIcon(FontAwesomeIcons.plus),
          ),
        ],
      ),
      drawer: AppMenuDrawer(),
      body: Stack(children: <Widget>[
        ListView.builder(
          padding: const EdgeInsets.all(20),
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
