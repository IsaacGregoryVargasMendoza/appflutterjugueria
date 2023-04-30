import 'package:app_jugueria/controladores/mesaController.dart';
import 'package:app_jugueria/componentes/app_text.dart';
import 'package:app_jugueria/componentes/app_buttons.dart';
import 'package:app_jugueria/componentes/app_textFieldRound.dart';
import 'package:app_jugueria/componentes/app_drawer.dart';
import 'package:app_jugueria/vistas/app_listaMesas.dart';
import 'package:flutter/material.dart';

class AppRegistroMesa extends StatefulWidget {
  AppRegistroMesa({Key? key}) : super(key: key);
  @override
  State<AppRegistroMesa> createState() {
    return _AppRegistroMesaState();
  }
}

class _AppRegistroMesaState extends State<AppRegistroMesa> {
  final myController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Registrar mesa"),
        backgroundColor: Colors.blue,
      ),
      drawer: AppMenuDrawer(),
      body: Container(
        width: MediaQuery.of(context).size.width,
        // color: Colors.green,
        padding: EdgeInsets.only(top: 50),
        child: Column(
          children: [
            AppText(text: "Numero de mesa", width: 320),
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
                MesaController mesaCtrll = MesaController();
                await mesaCtrll.addMesa(myController.text);

                final lista = await mesaCtrll.getMesas();
                // Navigator.of(context).pop();
                Navigator.of(context).pop(MaterialPageRoute(
                    builder: (context) => AppListaMesa(lista)));
              },
            ),
          ],
        ),
      ),
    );
  }
}
