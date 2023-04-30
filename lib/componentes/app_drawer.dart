import 'package:app_jugueria/vistas/app_listaMesas.dart';
import 'package:flutter/material.dart';
import 'package:app_jugueria/controladores/categoriaController.dart';
import 'package:app_jugueria/controladores/productoController.dart';
import 'package:app_jugueria/controladores/mesaController.dart';
import 'package:app_jugueria/controladores/clienteController.dart';
import 'package:app_jugueria/vistas/app_listaCategorias.dart';
import 'package:app_jugueria/vistas/app_listaProductos.dart';
import 'package:app_jugueria/vistas/app_listaClientes.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AppMenuDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(50.0)),
      child: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Color.fromRGBO(250, 250, 250, 0.4),
                border: Border(
                    bottom: BorderSide(
                        width: 0.2,
                        color: Colors.black,
                        style: BorderStyle.solid)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          // border: Border.all(width: 0.1),
                          borderRadius: BorderRadius.circular(100),
                          image: const DecorationImage(
                            image: AssetImage("assets/frutas_fondo.jpg"),
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 0, horizontal: 15),
                        child: const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "Isaac Vargas Mendoza",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "Editar perfil",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const FaIcon(FontAwesomeIcons.table),
              title: const Text(
                'Mesas',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              onTap: () async {
                MesaController mesaCtrll = MesaController();
                final lista = await mesaCtrll.getMesas();
                Navigator.of(context).pop();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AppListaMesa(lista)));
              },
            ),
            ListTile(
              leading: const FaIcon(FontAwesomeIcons.tags),
              title: const Text(
                'Categorias',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              onTap: () async {
                CategoriaController categoriaCtrll = CategoriaController();
                final lista = await categoriaCtrll.getCategorias();
                Navigator.of(context).pop();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AppListaCategoria(lista)));
              },
            ),
            ListTile(
              leading: const FaIcon(FontAwesomeIcons.bagShopping),
              title: const Text(
                'Productos',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              onTap: () async {
                ProductoController productoCtrll = ProductoController();
                final lista = await productoCtrll.getProductos();
                Navigator.of(context).pop();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AppListaProducto(lista)));
              },
            ),
            ListTile(
              leading: const FaIcon(FontAwesomeIcons.user),
              title: const Text(
                'Clientes',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              onTap: () async {
                ClienteController productoCtrll = ClienteController();
                final lista = await productoCtrll.getClientes();
                Navigator.of(context).pop();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AppListaCliente(lista)));
              },
            ),
            ListTile(
              leading: const FaIcon(FontAwesomeIcons.clipboardCheck),
              title: const Text(
                'Pedidos',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              onTap: () {},
            ),
            ListTile(
              leading: const FaIcon(FontAwesomeIcons.signOut),
              title: const Text(
                'Cerrar sesion',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
