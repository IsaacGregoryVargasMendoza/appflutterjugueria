import 'package:app_jugueria/controladores/adicionalController.dart';
import 'package:app_jugueria/componentes/info_global.dart';
import 'package:app_jugueria/modelos/categoriaModel.dart';
import 'package:app_jugueria/controladores/categoriaController.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

enum WidgetState { NONE, LOADING, LOADED, ERROR }

class AppListaCategoria extends StatefulWidget {
  List<CategoriaModel>? data;

  AppListaCategoria({this.data, Key? key}) : super(key: key);
  @override
  State<AppListaCategoria> createState() {
    return AppListaCategoriaState();
  }
}

class AppListaCategoriaState extends State<AppListaCategoria> {
  WidgetState _widgetState = WidgetState.LOADED;
  // String mensajeCargando = "";

  @override
  void dispose() {
    super.dispose();
    InfoGlobal.decrementarVentanas();
  }

  @override
  Widget build(BuildContext context) {
    switch (_widgetState) {
      case WidgetState.NONE:
      case WidgetState.LOADING:
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: const Text("Lista de categorias"),
            backgroundColor: Colors.green.shade900,
          ),
          body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            margin: const EdgeInsets.all(0),
            padding: const EdgeInsets.all(0),
            child: Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: Colors.amber.shade900),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      "Cargando adicionales...",
                      style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 20.0,
                          color: Colors.black,
                          decoration: TextDecoration.none),
                    )
                  ]),
            ),
          ),
        );
      case WidgetState.LOADED:
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: const Text("Lista de categorias"),
            backgroundColor: Colors.green.shade900,
            actions: <Widget>[
              IconButton(
                onPressed: () {
                  // Navigator.of(context).pop();
                  Navigator.pushNamed(context, '/registrar-categoria');
                },
                icon: const FaIcon(FontAwesomeIcons.plus),
              ),
            ],
          ),
          body: Stack(children: <Widget>[
            ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: widget.data!.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    CategoriaModel categoriaModel = CategoriaModel(
                        id: widget.data![index].id,
                        nombreCategoria: widget.data![index].nombreCategoria,
                        letraCategoria: widget.data![index].letraCategoria);
                    Navigator.pushNamed(
                      context,
                      '/editar-categoria',
                      arguments: categoriaModel,
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
                    padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                    decoration: BoxDecoration(
                        color: Colors.green.shade100,
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              20, 10, 0, 10),
                          decoration: const BoxDecoration(
                            color: Colors.transparent,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${widget.data![index].nombreCategoria}",
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    softWrap: true,
                                    textAlign: TextAlign.start,
                                  ),
                                  Text(
                                    "Letra: ${widget.data![index].letraCategoria}",
                                    style: const TextStyle(
                                      fontSize: 16,
                                    ),
                                    softWrap: true,
                                    textAlign: TextAlign.start,
                                  ),
                                ],
                              ),
                              Container(
                                child: Column(
                                  children: [
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        // shadowColor: Colors.red,
                                        primary: Colors.green.shade600,
                                      ),
                                      onPressed: () async {
                                        // setState(() {
                                        //   _widget = WidgetState.LOADING;
                                        // });
                                        // setState(() {
                                        //     _widget = WidgetState.LOADING;
                                        //   });
                                        // Navigator.of(context).pop();

                                        debugPrint("cambios");
                                        debugPrint(
                                            widget.data!.length.toString());
                                        try {
                                          int idCategoria =
                                              widget.data![index].id!;

                                          CategoriaModel categoria =
                                              CategoriaModel(
                                                  id: idCategoria,
                                                  nombreCategoria:
                                                      widget.data![index]
                                                          .nombreCategoria,
                                                  letraCategoria: widget
                                                      .data![index]
                                                      .letraCategoria);
                                          // setState(() {
                                          //   _widgetState = WidgetState.LOADING;
                                          // });
                                          AdicionalController adicionalCtrll =
                                              AdicionalController();
                                          final adicionales =
                                              await adicionalCtrll
                                                  .getAdicionales();
                                          final adicionalesAsignados =
                                              await adicionalCtrll
                                                  .getAdicionalesPorCategoria(
                                                      idCategoria);
                                          // setState(() {
                                          //   _widget = WidgetState.LOADED;
                                          // });
                                          // setState(() {
                                          //   _widgetState = WidgetState.LOADED;
                                          // });
                                          // Navigator.pushNamed(context,"/");

                                          // Navigator.pushNamed(
                                          //     context, '/asignar-adicionales',
                                          //     arguments: {
                                          //       'categoria': categoria,
                                          //       'adicionales': adicionales,
                                          //       'adicionalesAsignados':
                                          //           adicionalesAsignados
                                          //     });
                                          Navigator.pushNamed(
                                            context,
                                            '/asignar-adicionales',
                                            arguments: {
                                              'categoria': categoria,
                                              'adicionales': adicionales,
                                              'adicionalesAsignados':
                                                  adicionalesAsignados
                                            },
                                          );
                                        } catch (e) {
                                          debugPrint(e.toString());
                                        }

                                        // setState(() {
                                        //   _widgetState = WidgetState.LOADED;
                                        // });
                                      },
                                      child: FaIcon(FontAwesomeIcons.pepperHot),
                                    ),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        // shadowColor: Colors.red,
                                        primary: Colors.red.shade600,
                                      ),
                                      onPressed: () async {
                                        CategoriaController categoriaCtrll =
                                            CategoriaController();

                                        var listaProductos =
                                            await categoriaCtrll
                                                .getProductosConCategoria(
                                                    widget.data![index].id!);

                                        if (listaProductos.isEmpty) {
                                          await categoriaCtrll.deleteCategoria(
                                              widget.data![index].id!);
                                          List<CategoriaModel> lista =
                                              await categoriaCtrll
                                                  .getCategorias();
                                          // setState(() {
                                          //   widget.data = lista;
                                          // });
                                        } else {
                                          InfoGlobal.mensajeFallo(
                                              context,
                                              "No se puede eliminar la categoria porque tiene asociado productos.",
                                              3);
                                        }
                                      },
                                      child: FaIcon(FontAwesomeIcons.trash),
                                    ),
                                  ],
                                ),
                              )
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
      case WidgetState.ERROR:
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: const Text("Lista de categorias"),
            backgroundColor: Colors.green.shade900,
          ),
          body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            margin: const EdgeInsets.all(0),
            padding: const EdgeInsets.all(0),
            child: const Center(
              child: Text(
                "Ha ocurrido un error!!",
                style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 20.0,
                    color: Colors.red,
                    decoration: TextDecoration.none),
              ),
            ),
          ),
        );
    }
  }
}
