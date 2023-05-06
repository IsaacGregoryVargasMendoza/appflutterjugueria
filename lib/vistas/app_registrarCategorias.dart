import 'package:app_jugueria/controladores/categoriaController.dart';
import 'package:app_jugueria/componentes/app_text.dart';
import 'package:app_jugueria/componentes/app_buttons.dart';
import 'package:app_jugueria/componentes/app_textFieldRound.dart';
import 'package:app_jugueria/componentes/app_drawer.dart';
import 'package:app_jugueria/vistas/app_listaCategorias.dart';
import 'package:flutter/material.dart';

class AppRegistroCategoria extends StatefulWidget {
  AppRegistroCategoria({Key? key}) : super(key: key);
  @override
  State<AppRegistroCategoria> createState() {
    return _AppRegistroCategoriaState();
  }
}

class _AppRegistroCategoriaState extends State<AppRegistroCategoria> {
  final myController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Registro Categoria"),
        backgroundColor: Colors.green.shade900,
      ),
      drawer: AppMenuDrawer(),
      body: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.only(top: 50),
        child: Column(
          children: [
            AppText(text: "Categoria", width: 320),
            AppTextFieldRound(
              width: 320,
              isPassword: false,
              funcion: () {},
              myController: myController,
            ),
            const SizedBox(height: 15),
            AppButtons(
              textColor: Colors.white,
              backgroundColor: Colors.blue,
              borderColor: Colors.blue,
              text: "Registrar",
              fontSize: 15,
              width: 130,
              height: 50,
              funcion: () async {
                CategoriaController categoriaCtrll = CategoriaController();
                await categoriaCtrll.addCategoria(myController.text);

                final lista = await categoriaCtrll.getCategorias();
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => AppListaCategoria(lista)));
              },
            ),
          ],
        ),
      ),
    );
  }
}
