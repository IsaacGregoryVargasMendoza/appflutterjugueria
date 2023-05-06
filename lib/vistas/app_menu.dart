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
        backgroundColor: Colors.green.shade900,
      ),
      drawer: AppMenuDrawer(),
      body: Container(
        color: Colors.white,
        child: const Center(child: Text("Pantalla principal")),
      ),
    );
  }
}
