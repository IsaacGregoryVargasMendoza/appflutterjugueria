import 'package:flutter/material.dart';
import 'package:app_jugueria/controladores/categoriaController.dart';
import 'package:app_jugueria/controladores/productoController.dart';
import 'package:app_jugueria/controladores/mesaController.dart';
import 'package:app_jugueria/controladores/clienteController.dart';
import 'package:flutter/widgets.dart' as widgets;
import 'package:app_jugueria/controladores/pedidoController.dart';
import 'package:app_jugueria/componentes/info_global.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
                            image:
                                AssetImage("assets/usuario_administrador.png"),
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 0, horizontal: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "${InfoGlobal.administradorModel!.nombreAdministrador} \n${InfoGlobal.administradorModel!.apellidoAdministrador}",
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "${InfoGlobal.administradorModel!.numeroDocumento}",
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                print("click en editar.");
                                //                               int openNavigatorCount = 0;

                                // widgets.WidgetsBinding.instance!.addPostFrameCallback((_) {
                                //   final context = widgets.WidgetsBinding.instance!.rootElement?;
                                //   if (context != null) {
                                //     final navigatorState = Navigator.of(context).restorationScope?.navigatorState;
                                //     if (navigatorState != null && !navigatorState.mounted) {
                                //       openNavigatorCount++;
                                //     }
                                //   }
                                // });
                              },
                              child: const Text(
                                "Editar perfil",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 11,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const FaIcon(FontAwesomeIcons.cartShopping),
              title: const Text(
                'Ventas',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              onTap: (){
                // Navigator.of(context).pop();
                // Navigator.of(context).pop();
                InfoGlobal.incrementarVentanas();
                debugPrint("Ventas");
                Navigator.of(context).pushReplacementNamed("/dashboard-pedidos");
                // Navigator.pushNamed(context, '/dashboard-pedidos');
              },
            ),
            ListTile(
              leading: const FaIcon(FontAwesomeIcons.gears),
              title: const Text(
                'Mantenedores',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              onTap: () {
                // Navigator.of(context).pop();
                // Navigator.of(context).pop();
                InfoGlobal.incrementarVentanas();
                // Navigator.pushNamed(context, '/menu-administrador');
                Navigator.of(context).pushReplacementNamed("/menu-administrador");
              },
            ),
            ListTile(
              leading: const FaIcon(FontAwesomeIcons.tableCells),
              title: const Text(
                'Liberar mesas',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              onTap: () {
                // Navigator.of(context).pop();
                // Navigator.of(context).pop();
                InfoGlobal.incrementarVentanas();
                // Navigator.pushNamed(context, '/liberar-mesas');
                Navigator.of(context).pushReplacementNamed("/liberar-mesas");
              },
            ),
            ListTile(
              leading: const FaIcon(FontAwesomeIcons.clipboardCheck),
              title: const Text(
                'Pedidos',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              onTap: () async {
                PedidoController pedidoCtrll = PedidoController();
                final lista = await pedidoCtrll.getPedidosDesc();
                // Navigator.of(context).pop();
                // Navigator.of(context).pop();
                InfoGlobal.incrementarVentanas();
                Navigator.of(context).pushReplacementNamed("/lista-pedidos",arguments: lista);
                // Navigator.pushNamed(
                //   context,
                //   '/lista-pedidos',
                //   arguments: lista,
                // );
              },
            ),
            ListTile(
              leading: const FaIcon(FontAwesomeIcons.signOut),
              title: const Text(
                'Cerrar sesion',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              onTap: () async {
                final SharedPreferences prefs =
                    await SharedPreferences.getInstance();
                await prefs.remove('usuarioAdministrador');
                await prefs.remove('contraseniaAdministrador');
                Navigator.of(context).pushReplacementNamed("/");
              },
            ),
          ],
        ),
      ),
    );
  }
}
