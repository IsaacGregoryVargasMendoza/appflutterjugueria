import 'package:app_jugueria/componentes/app_drawer.dart';
import 'package:flutter/material.dart';

class AppMenu extends StatefulWidget {
  @override
  State<AppMenu> createState() {
    return _AppMenuState();
  }
}

class _AppMenuState extends State<AppMenu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.amber,
      ),
      drawer: AppMenuDrawer(),
      body: Container(
        color: Colors.white,
        // decoration: const BoxDecoration(
        //   image: DecorationImage(
        //     image: AssetImage("assets/frutas_fondo1.jpg"),
        //     opacity: 0.9,
        //     fit: BoxFit.cover,
        //   ),
        // ),
        child: Center(child: const Text("Pantalla principal")),
      ),
    );
  }
}
