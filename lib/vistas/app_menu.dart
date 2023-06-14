import 'package:app_jugueria/controladores/categoriaController.dart';
import 'package:app_jugueria/controladores/productoController.dart';
import 'package:app_jugueria/controladores/mesaController.dart';
import 'package:app_jugueria/controladores/clienteController.dart';
import 'package:app_jugueria/controladores/administradorController.dart';
import 'package:app_jugueria/controladores/adicionalController.dart';
import 'package:app_jugueria/componentes/info_global.dart';
import 'package:app_jugueria/componentes/app_drawer.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';

class AppMenu extends StatefulWidget {
  @override
  State<AppMenu> createState() {
    return _AppMenuState();
  }
}

class MyGridItem {
  final String text;
  final Future<void> onPressed;
  BuildContext contexto;

  MyGridItem(
      {required this.text, required this.contexto, required this.onPressed});
}

class _AppMenuState extends State<AppMenu> {
  late BuildContext contextFunction;

  final List<String> items = [
    'Adicionales',
    'Categorias',
    'Clientes',
    'Productos',
    'Mesas',
    'Usuarios'
  ];

  final List<IconData> listaIconos = [
    FontAwesomeIcons.pepperHot,
    FontAwesomeIcons.tags,
    FontAwesomeIcons.user,
    FontAwesomeIcons.bagShopping,
    FontAwesomeIcons.table,
    FontAwesomeIcons.userShield,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.green.shade900,
      ),
      drawer: AppMenuDrawer(),
      body: Container(
        padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
        child: GridView.count(
            crossAxisCount: 2,
            mainAxisSpacing: 15.0,
            crossAxisSpacing: 15.0,
            children: <Widget>[
              GestureDetector(
                onTap: () async {
                  AdicionalController adicionalCtrll = AdicionalController();
                  final lista = await adicionalCtrll.getAdicionales();
                  InfoGlobal.incrementarVentanas();

                  Navigator.pushNamed(
                    context,
                    '/lista-adicionales',
                    arguments: lista,
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.green.shade500,
                      borderRadius: BorderRadius.circular(20)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        items[0],
                        style: const TextStyle(
                            fontSize: 24.0,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10.0),
                      FaIcon(
                        listaIconos[0],
                        size: 60,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                // onTap: itemTappedFunctions![index],
                onTap: () async {
                  CategoriaController categoriaCtrll = CategoriaController();
                  final lista = await categoriaCtrll.getCategorias();
                  InfoGlobal.incrementarVentanas();
                  Navigator.pushNamed(
                    context,
                    '/lista-categorias',
                    arguments: lista,
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.green.shade500,
                      borderRadius: BorderRadius.circular(20)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        items[1],
                        style: const TextStyle(
                            fontSize: 24.0,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10.0),
                      FaIcon(
                        listaIconos[1],
                        size: 60,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                // onTap: itemTappedFunctions![index],
                onTap: () async {
                  ClienteController productoCtrll = ClienteController();
                  final lista = await productoCtrll.getClientes();
                  InfoGlobal.incrementarVentanas();
                  Navigator.pushNamed(
                    context,
                    '/lista-clientes',
                    arguments: lista,
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.green.shade500,
                      borderRadius: BorderRadius.circular(20)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        items[2],
                        style: const TextStyle(
                            fontSize: 24.0,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10.0),
                      FaIcon(
                        listaIconos[2],
                        size: 60,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () async {
                  ProductoController productoCtrll = ProductoController();
                  final lista = await productoCtrll.getProductos();
                  InfoGlobal.incrementarVentanas();
                  Navigator.pushNamed(
                    context,
                    '/lista-productos',
                    arguments: lista,
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.green.shade500,
                      borderRadius: BorderRadius.circular(20)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        items[3],
                        style: const TextStyle(
                            fontSize: 24.0,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10.0),
                      FaIcon(
                        listaIconos[3],
                        size: 60,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                // onTap: itemTappedFunctions![index],
                onTap: () async {
                  MesaController mesaCtrll = MesaController();
                  final lista = await mesaCtrll.getMesas();
                  InfoGlobal.incrementarVentanas();
                  Navigator.pushNamed(
                    context,
                    '/lista-mesas',
                    arguments: lista,
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.green.shade500,
                      borderRadius: BorderRadius.circular(20)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        items[4],
                        style: const TextStyle(
                            fontSize: 24.0,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10.0),
                      FaIcon(
                        listaIconos[4],
                        size: 60,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                // onTap: itemTappedFunctions![index],
                onTap: () async {
                  AdministradorController administradorCtrll =
                      AdministradorController();
                  final lista = await administradorCtrll.getAdministradores();
                  InfoGlobal.incrementarVentanas();
                  Navigator.pushNamed(
                    context,
                    '/lista-administradores',
                    arguments: lista,
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.green.shade500,
                      borderRadius: BorderRadius.circular(20)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        items[5],
                        style: const TextStyle(
                            fontSize: 24.0,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10.0),
                      FaIcon(
                        listaIconos[5],
                        size: 60,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
            ]),
      ),
    );
  }
}
