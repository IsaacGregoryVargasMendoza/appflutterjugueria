import 'package:app_jugueria/vistas/app_registrarPedidoConSenias.dart';
import 'package:app_jugueria/controladores/productoController.dart';
import 'package:app_jugueria/controladores/categoriaController.dart';
import 'package:app_jugueria/vistas/app_seleccionarProducto.dart';
import 'package:flutter/material.dart';
import 'package:app_jugueria/componentes/app_buttons.dart';
import 'package:app_jugueria/vistas/app_login.dart';

void main() {
  runApp(MaterialApp(home: MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/frutas_fondo1.jpg"),
            // opacity: 0.9,
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          color: Colors.black.withOpacity(0.5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppButtons(
                      textColor: Colors.black,
                      backgroundColor: Color.fromRGBO(241, 241, 241, 1),
                      borderColor: Color.fromRGBO(241, 241, 241, 1),
                      text: "Administrar",
                      fontSize: 15,
                      width: 250,
                      height: 50,
                      funcion: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AppLogin()));
                      }),
                  const SizedBox(height: 15),
                  AppButtons(
                    textColor: Colors.black,
                    backgroundColor: Color.fromRGBO(241, 241, 241, 1),
                    borderColor: Color.fromRGBO(241, 241, 241, 1),
                    text: "Comprar ahora",
                    fontSize: 15,
                    width: 250,
                    height: 50,
                    funcion: () async {
                      ProductoController productoCtrll = ProductoController();
                      final lista = await productoCtrll.getProductos();
                      CategoriaController categoriaCtrll =
                          CategoriaController();
                      final listaCategorias =
                          await categoriaCtrll.getCategorias();
                      // Navigator.of(context).pop();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  AppSeleccionarProducto(listaCategorias)));
                      //_myModal(context);
                      // Navigator.push(context,
                      // _myModal(context));
                      // MaterialPageRoute(builder: (context) => MyApp()));
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      // body:
    );
  }
}
