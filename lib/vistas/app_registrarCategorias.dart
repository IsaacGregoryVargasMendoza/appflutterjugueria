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
          title: Text("Registro Categoria"),
          backgroundColor: Colors.blue,
        ),
        drawer: AppMenuDrawer(),
        body: Container(
          width: MediaQuery.of(context).size.width,
          // color: Colors.green,
          padding: EdgeInsets.only(top: 50),
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
        )
        // body: GridView.builder(
        //   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        //     crossAxisCount: 2, // Dos columnas
        //     mainAxisSpacing: 10, // Espacio vertical entre los elementos
        //     crossAxisSpacing: 10, // Espacio horizontal entre los elementos
        //   ),
        //   itemCount: widget.data.length,
        //   itemBuilder: (context, index) {
        //     return GestureDetector(
        //       onTap: () {
        //         // print(data![index]);
        //       },
        //       child: Column(
        //         crossAxisAlignment: CrossAxisAlignment.stretch,
        //         children: <Widget>[
        //           const Expanded(
        //             child: Image(
        //               image: AssetImage("assets/mesa.jpg"),
        //               fit: BoxFit.fill,
        //               // height: 10,
        //             ),
        //             // child: Image.network(
        //             //   data[index]., // URL de la imagen
        //             //   fit: BoxFit.cover,
        //             // ),
        //           ),
        //           SizedBox(height: 5),
        //           Text(
        //             widget.data[index].numeroMesa,
        //             style: const TextStyle(
        //               fontSize: 16,
        //               fontWeight: FontWeight.bold,
        //             ),
        //             textAlign: TextAlign.center,
        //           ),
        //         ],
        //       ),
        //     );
        //   },
        // ),
        );
  }
}
