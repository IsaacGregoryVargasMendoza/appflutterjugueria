import 'package:app_jugueria/controladores/manualController.dart';
import 'package:app_jugueria/controladores/productoController.dart';
import 'package:app_jugueria/controladores/categoriaController.dart';
import 'package:app_jugueria/componentes/info_global.dart';
import 'package:app_jugueria/modelos/manualModel.dart';
import 'package:app_jugueria/modelos/productoModel.dart';
import 'package:app_jugueria/modelos/categoriaModel.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

class AppManualCliente extends StatefulWidget {
  // List<ProductoModel>? data;

  AppManualCliente({Key? key}) : super(key: key);
  @override
  State<AppManualCliente> createState() {
    return AppManualClienteState();
  }
}

class AppManualClienteState extends State<AppManualCliente> {
  List<ManualModel> data = [];
  late List<ProductoModel> listAuxProductos;

  // Future<List<CategoriaModel>>
  Future<void> obtenerInstrucciones() async {
    ManualController manualCtrll = ManualController();
    final lista = await manualCtrll.getManualClientes();

    data = lista;
    setState(() {});
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Manual de usuario"),
        backgroundColor: Colors.green.shade900,
        actions: <Widget>[
          IconButton(
            onPressed: () async {
              // CategoriaController categoriaCtrll = CategoriaController();
              // final lista = await categoriaCtrll.getCategorias();
              // // List<CategoriaModel> lista = listaCategorias();
              // // Navigator.of(context).pop();
              // Navigator.pushNamed(
              //   context,
              //   '/registrar-producto',
              //   arguments: lista,
              // );
            },
            icon: const FaIcon(FontAwesomeIcons.plus),
          ),
        ],
      ),
      // drawer: AppMenuDrawer(),
      body: Column(
        children: [
          Expanded(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height - 280,
              // margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                itemCount: data.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () async {},
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 20),
                      // height: 500,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            // color: Colors.red,
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
                      margin: const EdgeInsets.fromLTRB(10, 20, 10, 0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        // crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width - 100,
                            height: MediaQuery.of(context).size.width - 100,
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
                            width: MediaQuery.of(context).size.width - 100,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("PASO ${data[index].pasoManual!}",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.left),
                                Text("${data[index].descripcionManual!}"),
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
                          data![index].imagenManual!,
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
                      // Container(
                      //   width: MediaQuery.of(context).size.width - 150,
                      //   child: Column(
                      //     crossAxisAlignment: CrossAxisAlignment.start,
                      //     mainAxisAlignment: MainAxisAlignment.center,
                      //     children: <Widget>[
                      //       Text(
                      //         "${widget.data![index].nombreProducto}",
                      //         style: const TextStyle(
                      //             fontSize: 21,
                      //             fontWeight: FontWeight.bold,
                      //             color: Colors.red),
                      //         textAlign: TextAlign.start,
                      //       ),
                      //       Text(
                      //         "Categoria: ${widget.data![index].categoria!.nombreCategoria}\nDetalle: ${widget.data![index].descripcionProducto} \nLetra: ${widget.data![index].letraProducto}",
                      //         style: const TextStyle(
                      //           fontSize: 18,
                      //         ),
                      //         textAlign: TextAlign.start,
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      Text(
                        "S/.${data![index].descripcionManual.toString()}",
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
