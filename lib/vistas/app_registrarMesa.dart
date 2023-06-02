import 'package:app_jugueria/controladores/mesaController.dart';
import 'package:app_jugueria/componentes/app_text.dart';
import 'package:app_jugueria/componentes/app_buttons.dart';
import 'package:app_jugueria/componentes/app_textFieldRound.dart';
import 'package:app_jugueria/componentes/app_drawer.dart';
import 'package:app_jugueria/modelos/mesaModel.dart';
import 'package:app_jugueria/vistas/app_listaMesas.dart';
import 'package:flutter/material.dart';

class AppRegistroMesa extends StatefulWidget {
  MesaModel? mesaModel;
  AppRegistroMesa({this.mesaModel, Key? key}) : super(key: key);
  @override
  State<AppRegistroMesa> createState() {
    return _AppRegistroMesaState();
  }
}

class _AppRegistroMesaState extends State<AppRegistroMesa> {
  late TextEditingController numeroMesa;
  bool _buttonDisabled = false;

  @override
  void initState() {
    super.initState();
    if (widget.mesaModel != null) {
      numeroMesa = TextEditingController(text: widget.mesaModel!.numeroMesa);
    } else {
      numeroMesa = TextEditingController();
    }
  }

  void _disableButton() {
    setState(() {
      _buttonDisabled = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: (widget.mesaModel != null)
            ? Text("Editar mesa")
            : Text("Registrar mesa"),
        backgroundColor: Colors.green.shade900,
      ),
      drawer: AppMenuDrawer(),
      body: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.only(top: 50),
        child: Column(
          children: [
            AppText(text: "Numero de mesa", width: 320),
            AppTextFieldRound(
              width: 320,
              isPassword: false,
              funcion: () {},
              myController: numeroMesa,
            ),
            const SizedBox(height: 15),
            AppButtons(
              textColor: Colors.white,
              backgroundColor: Colors.blue,
              borderColor: Colors.blue,
              text:
                  (widget.mesaModel != null) ? "Guardar cambios" : "Registrar",
              fontSize: 15,
              width: 140,
              height: 50,
              funcion: () async {
                if (_buttonDisabled) {
                  print("No hare nada porque ya precionaste una vez.");
                } else {
                  _disableButton();
                  if (widget.mesaModel != null) {
                    MesaController mesaCtrll = MesaController();
                    MesaModel mesa = MesaModel(numeroMesa: numeroMesa.text);
                    await mesaCtrll.updateMesa(mesa);

                    final lista = await mesaCtrll.getMesas();
                    Navigator.of(context).pop();
                    Navigator.pushNamed(
                      context,
                      '/lista-mesas',
                      arguments: lista,
                    );
                  } else {
                    MesaController mesaCtrll = MesaController();
                    await mesaCtrll.addMesa(numeroMesa.text);

                    final lista = await mesaCtrll.getMesas();
                    Navigator.of(context).pop();
                    Navigator.pushNamed(
                      context,
                      '/lista-mesas',
                      arguments: lista,
                    );
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
