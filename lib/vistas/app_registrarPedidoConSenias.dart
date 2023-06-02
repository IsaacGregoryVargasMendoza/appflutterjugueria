import 'package:app_jugueria/componentes/app_drawer.dart';
import 'package:app_jugueria/componentes/app_text.dart';
import 'package:app_jugueria/controladores/productoController.dart';
import 'package:app_jugueria/controladores/categoriaController.dart';
import 'package:app_jugueria/vistas/app_registrarProductos.dart';
import 'package:app_jugueria/modelos/productoModel.dart';
import 'package:app_jugueria/modelos/categoriaModel.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

class AppRegistrarProductoConSenias extends StatefulWidget {
  List<ProductoModel> data;
  List<ProductoModel>? listAuxProductos;
  List<CategoriaModel> listaCategorias;

  AppRegistrarProductoConSenias(
      this.data, this.listAuxProductos, this.listaCategorias,
      {Key? key})
      : super(key: key);
  @override
  State<AppRegistrarProductoConSenias> createState() {
    return _AppRegistrarProductoConSeniasState();
  }
}

class _AppRegistrarProductoConSeniasState
    extends State<AppRegistrarProductoConSenias> {
  Future<List<ProductoModel>> obtenerProductos() async {
    ProductoController productoCtrll = ProductoController();
    final lista = productoCtrll.getProductos();

    return lista;
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
        title: const Text("Catalogo"),
        backgroundColor: Colors.green.shade900,
        actions: <Widget>[
          IconButton(
            onPressed: () async {
              CategoriaController categoriaCtrll = CategoriaController();
              final lista = await categoriaCtrll.getCategorias();
              Navigator.of(context).pop();
              // Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //         builder: (context) => AppRegistroProducto(lista)));
              Navigator.pushNamed(
                context,
                '/registrar-producto',
                arguments: {'lista': lista},
              );
            },
            icon: const FaIcon(FontAwesomeIcons.cartShopping),
            // icon: const FaIcon(FontAwesomeIcons.cartShopping,
            //     color: Colors.green, size: 30),
          ),
        ],
      ),
      drawer: AppMenuDrawer(),
      body: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: 150,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              image: DecorationImage(
                image: AssetImage("assets/frutas2.jpg"),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              color: Colors.black.withOpacity(0.5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 0, 0, 15),
                    padding: const EdgeInsets.all(0),
                    width: 360,
                    height: 20,
                    child: Text(
                      "Filtrar",
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(0),
                    padding: const EdgeInsets.all(0),
                    width: 320,
                    height: 20,
                    child: Text(
                      "Categoria",
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Container(
                    width: 320,
                    padding: const EdgeInsets.fromLTRB(20, 5, 20, 0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white,
                    ),
                    child: DropdownButtonFormField(
                      decoration:
                          const InputDecoration(border: InputBorder.none),
                      borderRadius: BorderRadius.circular(15),
                      items: widget.listaCategorias.map((categoria) {
                        return DropdownMenuItem(
                            child: Text(categoria.nombreCategoria!),
                            value: categoria.id);
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          // for (var elemento in value) {
                          //   data elemento);
                          // }
                          List<ProductoModel> nuevaLista = [];
                          for (var producto in widget.data) {
                            print(producto.categoria!.id);
                            // print(producto.categoria.id == value);
                            if (producto.categoria!.id == value) {
                              nuevaLista.add(producto);
                            }
                          }
                          print("");
                          widget.listAuxProductos = nuevaLista;
                        });
                        // idCategoria = value!;
                        //print(value);
                      },
                    ),
                  ),
                ],
              ),
            ),
            // color: Colors.green.shade900,
            // child:
          ),
          Expanded(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height - 280,
              child: ListView.builder(
                itemCount: widget.listAuxProductos!.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
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
                                            widget.listAuxProductos![index]
                                                .imagenProducto!,
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              150,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Text(
                                                "${widget.listAuxProductos![index].nombreProducto}",
                                                style: const TextStyle(
                                                    fontSize: 21,
                                                    fontWeight:
                                                        FontWeight.bold),
                                                textAlign: TextAlign.start,
                                              ),
                                              Text(
                                                "Detalle: ${widget.data[index].descripcionProducto}",
                                                style: const TextStyle(
                                                  fontSize: 18,
                                                ),
                                                textAlign: TextAlign.start,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Text(
                                          "S/.${widget.listAuxProductos![index].precioProducto.toString()}",
                                          style: const TextStyle(
                                            fontSize: 25,
                                          ),
                                          textAlign: TextAlign.start,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    // color: Colors.blue,
                                    width: MediaQuery.of(context).size.width,
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 20, 5, 0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              180,
                                          // padding:
                                          //     EdgeInsets.fromLTRB(20, 0, 10, 0),
                                          // color: Colors.amber,
                                          child: const Text(
                                            "Cantidad:",
                                            style: TextStyle(
                                              fontSize: 21,
                                            ),
                                            textAlign: TextAlign.start,
                                          ),
                                        ),
                                        Container(
                                          width: 100,
                                          height: 40,
                                          child: Scrollbar(
                                            controller: ScrollController(),
                                            child: TextField(
                                              scrollController:
                                                  ScrollController(),
                                              keyboardType:
                                                  TextInputType.number,
                                              enableSuggestions: false,
                                              autocorrect: false,
                                              maxLength: 4,
                                              textAlign: TextAlign.end,
                                              style: const TextStyle(
                                                fontSize: 21,
                                                // height: 2,
                                                fontWeight: FontWeight.normal,
                                                color: Colors.black,
                                              ),
                                              decoration: const InputDecoration(
                                                // contentPadding:
                                                //     EdgeInsets.symmetric(
                                                //         horizontal,: 20,
                                                //         vertical: 0)
                                                border: OutlineInputBorder(
                                                    borderSide:
                                                        BorderSide(width: 1)),
                                              ),
                                              // controller: tecPrecio,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
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
                                      onPressed: () {},
                                      child: Center(
                                        child: Text(
                                          "Agregar",
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
                        // shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(
                          style: BorderStyle.solid,
                          width: 0.5,
                          color: Colors.white,
                        ),
                        color: Colors.white,

                        // color: Color.fromARGB(255, 234, 251, 159),
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
                                    widget.listAuxProductos![index]
                                        .imagenProducto!,
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
                                // const SizedBox(width: 10),
                                Text(
                                  "${widget.listAuxProductos![index].nombreProducto}",
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.start,
                                ),
                                Text(
                                  "Precio: ${widget.listAuxProductos![index].precioProducto.toString()}",
                                  style: const TextStyle(
                                    fontSize: 17,
                                  ),
                                  textAlign: TextAlign.start,
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
      // body: ListView.builder(
      //   itemCount: widget.data.length,
      //   itemBuilder: (context, index) {
      //     return GestureDetector(
      //       onTap: () {},
      //       child: Container(
      //         width: MediaQuery.of(context).size.width,
      //         height: 110,
      //         // color: Colors.amber,
      //         decoration: BoxDecoration(
      //           boxShadow: [
      //             BoxShadow(
      //               color: Colors.grey.withOpacity(0.5),
      //               spreadRadius: 2,
      //               blurRadius: 7,
      //               offset: Offset(0, 3), // cambia la posición de la sombra
      //             ),
      //           ],
      //           // shape: BoxShape.rectangle,
      //           borderRadius: BorderRadius.circular(25),
      //           border: Border.all(
      //             style: BorderStyle.solid,
      //             width: 0.5,
      //             color: Colors.white,
      //           ),
      //           color: Colors.white,

      //           // color: Color.fromARGB(255, 234, 251, 159),
      //         ),
      //         margin: EdgeInsets.fromLTRB(10, 20, 10, 0),
      //         child: Row(
      //           mainAxisAlignment: MainAxisAlignment.start,
      //           children: [
      //             Container(
      //               width: 100,
      //               height: 100,
      //               margin: EdgeInsets.all(5),
      //               decoration: BoxDecoration(
      //                 borderRadius: BorderRadius.circular(50),
      //                 image: DecorationImage(
      //                   image: MemoryImage(
      //                     base64.decode(
      //                       widget.data[index].imagenProducto,
      //                     ),
      //                   ),
      //                   fit: BoxFit.cover,
      //                 ),
      //               ),
      //               // child: Expanded(
      //               //   child: Image.memory(
      //               //     base64.decode(
      //               //       widget.data[index].imagenProducto,
      //               //     ),
      //               //   ),
      //               // ),
      //             ),
      //             // const SizedBox(width: 10),
      //             Container(
      //               width: MediaQuery.of(context).size.width - 181,
      //               // color: Colors.red,
      //               child: Column(
      //                 crossAxisAlignment: CrossAxisAlignment.start,
      //                 mainAxisAlignment: MainAxisAlignment.center,
      //                 children: <Widget>[
      //                   // const SizedBox(width: 10),
      //                   Text(
      //                     "${widget.data[index].nombreProducto}",
      //                     style: const TextStyle(
      //                         fontSize: 18, fontWeight: FontWeight.bold),
      //                     textAlign: TextAlign.start,
      //                   ),
      //                   // Text(
      //                   //   "Detalle: ${widget.data[index].descripcionProducto}",
      //                   //   style: const TextStyle(
      //                   //     fontSize: 15,
      //                   //   ),
      //                   //   textAlign: TextAlign.start,
      //                   // ),
      //                   Text(
      //                     "Precio: ${widget.data[index].precioProducto.toString()}",
      //                     style: const TextStyle(
      //                       fontSize: 17,
      //                     ),
      //                     textAlign: TextAlign.start,
      //                   ),
      //                 ],
      //               ),
      //             ),
      //           ],
      //         ),
      //       ),
      //     );
      //   },
      // ),
    );
  }
}
