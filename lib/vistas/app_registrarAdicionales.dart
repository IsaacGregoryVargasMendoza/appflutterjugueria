import 'package:app_jugueria/controladores/adicionalController.dart';
import 'package:app_jugueria/componentes/app_text.dart';
import 'package:app_jugueria/componentes/app_buttons.dart';
import 'package:app_jugueria/componentes/app_textFieldRound.dart';
import 'package:app_jugueria/componentes/app_drawer.dart';
import 'package:app_jugueria/modelos/adicionalModel.dart';
import 'package:flutter/material.dart';

class AppRegistroAdicional extends StatefulWidget {
  AdicionalModel? adicional;
  AppRegistroAdicional({this.adicional, Key? key}) : super(key: key);
  @override
  State<AppRegistroAdicional> createState() {
    return AppRegistroAdicionalState();
  }
}

class AppRegistroAdicionalState extends State<AppRegistroAdicional> {
  late TextEditingController nombreAdicional;
  late TextEditingController letraAdicional;
  List<String> opciones = ['NO', 'SI'];
  bool _buttonDisabled = false;
  String valorRespuesta = "NO";

  @override
  void initState() {
    super.initState();
    if (widget.adicional != null) {
      nombreAdicional =
          TextEditingController(text: widget.adicional!.nombreAdicional);
      letraAdicional =
          TextEditingController(text: widget.adicional!.letraAdicional);

      if (widget.adicional!.visibleAdicional == 0) {
        valorRespuesta = "NO";
      } else {
        valorRespuesta = "SI";
      }
    } else {
      nombreAdicional = TextEditingController();
      letraAdicional = TextEditingController();
      valorRespuesta = "NO";
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
        title: (widget.adicional != null)
            ? const Text("Editar Adicional")
            : const Text("Registrar Adicional"),
        backgroundColor: Colors.green.shade900,
      ),
      drawer: AppMenuDrawer(),
      body: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.only(top: 50),
        child: Column(
          children: [
            AppText(text: "Adicional", width: 320),
            AppTextFieldRound(
              width: 320,
              isPassword: false,
              funcion: () {},
              myController: nombreAdicional,
            ),
            AppText(text: "Letra", width: 320),
            AppTextFieldRound(
              width: 320,
              isPassword: false,
              funcion: () {},
              myController: letraAdicional,
            ),
            const SizedBox(height: 15),
            AppText(text: "Visible", width: 320),
            Container(
              width: 320,
              padding: const EdgeInsets.fromLTRB(20, 5, 20, 0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: const Color.fromRGBO(217, 217, 217, 1),
              ),
              child: DropdownButtonFormField(
                  value: valorRespuesta,
                  decoration: const InputDecoration(border: InputBorder.none),
                  borderRadius: BorderRadius.circular(15),
                  items: opciones.map((opcion) {
                    return DropdownMenuItem<String>(
                        child: Text(opcion), value: opcion);
                  }).toList(),
                  onChanged: (value) {
                    valorRespuesta = value!;
                  }),
            ),
            const SizedBox(height: 15),
            AppButtons(
              textColor: Colors.white,
              backgroundColor: Colors.blue,
              borderColor: Colors.blue,
              text:
                  (widget.adicional != null) ? "Guardar cambios" : "Registrar",
              fontSize: 15,
              width: 160,
              height: 50,
              funcion: () async {
                if (_buttonDisabled) {
                  print("No hare nada porque ya precionaste una vez.");
                } else {
                  _disableButton();
                  if (widget.adicional != null) {
                    AdicionalController adicionalCtrll = AdicionalController();
                    AdicionalModel adicionalModel = AdicionalModel(
                        id: widget.adicional!.id,
                        nombreAdicional: nombreAdicional.text,
                        letraAdicional: letraAdicional.text,
                        visibleAdicional: (valorRespuesta == "NO") ? 0 : 1);

                    await adicionalCtrll.updateAdicional(adicionalModel);

                    final lista = await adicionalCtrll.getAdicionales();
                    Navigator.pushNamed(
                      context,
                      '/lista-adicionales',
                      arguments: lista,
                    );
                  } else {
                    AdicionalController adicionalCtrll = AdicionalController();
                    AdicionalModel adicionalModel = AdicionalModel(
                        nombreAdicional: nombreAdicional.text,
                        letraAdicional: letraAdicional.text,
                        visibleAdicional: (valorRespuesta == "NO") ? 0 : 1);

                    await adicionalCtrll.addAdicional(adicionalModel);

                    final lista = await adicionalCtrll.getAdicionales();
                    Navigator.pushNamed(
                      context,
                      '/lista-adicionales',
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