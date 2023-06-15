import 'package:app_jugueria/componentes/app_drawer.dart';
import 'package:app_jugueria/controladores/productoController.dart';
import 'package:app_jugueria/controladores/categoriaController.dart';
import 'package:app_jugueria/componentes/info_global.dart';
import 'package:app_jugueria/modelos/productoModel.dart';
import 'package:app_jugueria/modelos/categoriaModel.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

class AppListaProducto extends StatefulWidget {
  List<ProductoModel>? data;

  AppListaProducto({this.data, Key? key}) : super(key: key);
  @override
  State<AppListaProducto> createState() {
    return _AppListaProductoState();
  }
}

class _AppListaProductoState extends State<AppListaProducto> {
  // List<ProductoModel>? data;
  late List<ProductoModel> listAuxProductos;

// Future<List<CategoriaModel>>
  Future<List<ProductoModel>> obtenerProductos() async {
    ProductoController productoCtrll = ProductoController();
    final lista = productoCtrll.getProductos();

    return lista;
  }

  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    InfoGlobal.decrementarVentanas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Lista de productos"),
        backgroundColor: Colors.green.shade900,
        actions: <Widget>[
          IconButton(
            onPressed: () async {
              CategoriaController categoriaCtrll = CategoriaController();
              final lista = await categoriaCtrll.getCategorias();
              // List<CategoriaModel> lista = listaCategorias();
              Navigator.of(context).pop();
              Navigator.pushNamed(
                context,
                '/registrar-producto',
                arguments: lista,
              );
            },
            icon: const FaIcon(FontAwesomeIcons.plus),
          ),
        ],
      ),
      drawer: AppMenuDrawer(),
      body: Column(
        children: [
          Expanded(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height - 280,
              child: ListView.builder(
                itemCount: widget.data!.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () async {
                      CategoriaController categoriaCtrll =
                          CategoriaController();
                      final lista = await categoriaCtrll.getCategorias();
                      ProductoModel productoModel = ProductoModel(
                          id: widget.data![index].id,
                          nombreProducto: widget.data![index].nombreProducto,
                          descripcionProducto:
                              widget.data![index].descripcionProducto,
                          categoria: CategoriaModel(
                              id: widget.data![index].categoria!.id),
                          precioProducto: widget.data![index].precioProducto,
                          letraProducto: widget.data![index].letraProducto,
                          imagenProducto: widget.data![index].imagenProducto);
                      Navigator.pushNamed(
                        context,
                        '/editar-producto',
                        arguments: {
                          'lista': lista,
                          'productoModel': productoModel
                        },
                      );
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 110,
                      // color: Colors.amber,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 7,
                            offset:
                                Offset(0, 3), // cambia la posición de la sombra
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
                      margin: EdgeInsets.fromLTRB(10, 20, 10, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            margin: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              image: DecorationImage(
                                image: MemoryImage(
                                  base64.decode(
                                    widget.data![index].imagenProducto!,
                                  ),
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width - 181,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  "${widget.data![index].nombreProducto}",
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.start,
                                ),
                                Text(
                                  "Precio: ${widget.data![index].precioProducto.toString()}",
                                  style: const TextStyle(
                                    fontSize: 17,
                                  ),
                                  textAlign: TextAlign.start,
                                ),
                              ],
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              GestureDetector(
                                  onTap: () async {
                                    ProductoController productoCtrll =
                                        ProductoController();
                                    await productoCtrll.deleteProducto(
                                        widget.data![index].id!);
                                    List<ProductoModel> lista =
                                        await productoCtrll.getProductos();
                                    setState(() {
                                      widget.data = lista;
                                    });
                                  },
                                  child: const FaIcon(
                                    FontAwesomeIcons.trash,
                                    color: Colors.red,
                                  )),
                              GestureDetector(
                                  onTap: () {
                                    abrirModalDetalle(index);
                                  },
                                  child: FaIcon(
                                    FontAwesomeIcons.eye,
                                    color: Colors.blue.shade900,
                                  )),
                            ],
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
  }

  abrirModalDetalle(int index) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height,
          color: Colors.white,
          padding: const EdgeInsets.fromLTRB(0, 100, 0, 0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: 200,
                  height: 200,
                  margin: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image: DecorationImage(
                      image: MemoryImage(
                        base64.decode(
                          widget.data![index].imagenProducto!,
                        ),
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  // color: Colors.red,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width - 150,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "${widget.data![index].nombreProducto}",
                              style: const TextStyle(
                                  fontSize: 21,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red),
                              textAlign: TextAlign.start,
                            ),
                            Text(
                              "Categoria: ${widget.data![index].categoria!.nombreCategoria}\nDetalle: ${widget.data![index].descripcionProducto} \nLetra: ${widget.data![index].letraProducto}",
                              style: const TextStyle(
                                fontSize: 18,
                              ),
                              textAlign: TextAlign.start,
                            ),
                          ],
                        ),
                      ),
                      Text(
                        "S/.${widget.data![index].precioProducto.toString()}",
                        style: const TextStyle(
                          fontSize: 25,
                        ),
                        textAlign: TextAlign.start,
                      ),
                    ],
                  ),
                ),
                // Container(
                //   // color: Colors.blue,
                //   width: MediaQuery.of(context).size.width,
                //   padding: const EdgeInsets.fromLTRB(0, 20, 5, 0),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceAround,
                //     crossAxisAlignment: CrossAxisAlignment.center,
                //     children: [
                //       Container(
                //         width: MediaQuery.of(context).size.width - 180,
                //         // padding:
                //         //     EdgeInsets.fromLTRB(20, 0, 10, 0),
                //         // color: Colors.amber,
                //         child: const Text(
                //           "Cantidad:",
                //           style: TextStyle(
                //             fontSize: 21,
                //           ),
                //           textAlign: TextAlign.start,
                //         ),
                //       ),
                //       Container(
                //         width: 100,
                //         height: 40,
                //         child: Scrollbar(
                //           controller: ScrollController(),
                //           child: TextField(
                //             scrollController: ScrollController(),
                //             keyboardType: TextInputType.number,
                //             enableSuggestions: false,
                //             autocorrect: false,
                //             maxLength: 4,
                //             textAlign: TextAlign.end,
                //             style: const TextStyle(
                //               fontSize: 21,
                //               // height: 2,
                //               fontWeight: FontWeight.normal,
                //               color: Colors.black,
                //             ),
                //             decoration: const InputDecoration(
                //               // contentPadding:
                //               //     EdgeInsets.symmetric(
                //               //         horizontal,: 20,
                //               //         vertical: 0)
                //               border: OutlineInputBorder(
                //                   borderSide: BorderSide(width: 1)),
                //             ),
                //             // controller: tecPrecio,
                //           ),
                //         ),
                //       )
                //     ],
                //   ),
                // ),
                Container(
                  margin: EdgeInsets.all(0),
                  padding: EdgeInsets.all(0),
                  width: 130,
                  height: 50,
                  decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.green,
                        width: 1.0,
                      )),
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Center(
                      child: Text(
                        "Regresar",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
