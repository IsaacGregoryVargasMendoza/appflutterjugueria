import 'package:app_jugueria/controladores/mesaController.dart';
import 'package:app_jugueria/componentes/app_text.dart';
import 'package:app_jugueria/componentes/app_buttons.dart';
import 'package:app_jugueria/componentes/app_textFieldRound.dart';
import 'package:app_jugueria/componentes/app_drawer.dart';
import 'package:app_jugueria/componentes/info_global.dart';
import 'package:app_jugueria/modelos/mesaModel.dart';
import 'package:flutter/material.dart';

enum WidgetState { NONE, LOADING, LOADED, ERROR }

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
  WidgetState _widgetState = WidgetState.LOADED;

  @override
  void initState() {
    super.initState();
    if (widget.mesaModel != null) {
      numeroMesa = TextEditingController(text: widget.mesaModel!.numeroMesa);
    } else {
      numeroMesa = TextEditingController();
    }
  }

  @override
  void dispose() {
    super.dispose();
    InfoGlobal.decrementarVentanas();
  }

  Future<void> registrarActualizar() async {
    try {
      setState(() {
        _widgetState = WidgetState.LOADING;
      });

      if (numeroMesa.text.toString().trim().isEmpty) {
        InfoGlobal.mostrarAlerta(
            context, "Mensaje", "Ingrese un numero de mesa valido.");
        setState(() {
          _widgetState = WidgetState.LOADED;
        });
        return;
      }

      MesaController mesaCtrll = MesaController();

      if (widget.mesaModel != null) {
        MesaModel mesa =
            MesaModel(id: widget.mesaModel!.id, numeroMesa: numeroMesa.text);
        await mesaCtrll.updateMesa(mesa);
        InfoGlobal.mensajeConfirmacion(
            context, "Se ha actualizado correctamente.");
      } else {
        await mesaCtrll.addMesa(numeroMesa.text);
        InfoGlobal.mensajeConfirmacion(
            context, "Se ha registrado correctamente.");
      }

      final lista = await mesaCtrll.getMesas();

      Navigator.of(context).pop();
      Navigator.pushNamed(
        context,
        '/lista-mesas',
        arguments: lista,
      );

      setState(() {
        _widgetState = WidgetState.LOADED;
      });
    } catch (e) {
      InfoGlobal.mensajeFallo(context, "No se pudo registrar.");
      setState(() {
        _widgetState = WidgetState.LOADED;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    switch (_widgetState) {
      case WidgetState.NONE:
      case WidgetState.LOADING:
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: (widget.mesaModel != null)
                ? const Text("Editar mesa")
                : const Text("Registrar mesa"),
            backgroundColor: Colors.green.shade900,
          ),
          drawer: AppMenuDrawer(),
          body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: Colors.amber.shade900),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    "Cargando...",
                    style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 20.0,
                        color: Colors.black,
                        decoration: TextDecoration.none),
                  )
                ]),
          ),
        );
      case WidgetState.LOADED:
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: (widget.mesaModel != null)
                ? const Text("Editar mesa")
                : const Text("Registrar mesa"),
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
                  text: (widget.mesaModel != null)
                      ? "Guardar cambios"
                      : "Registrar",
                  fontSize: 15,
                  width: 140,
                  height: 50,
                  funcion: () async {
                    await registrarActualizar();
                  },
                ),
              ],
            ),
          ),
        );
      case WidgetState.ERROR:
        return const Scaffold(
          backgroundColor: Colors.white,
          body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "ERROR!. Vuelve a intentarlo.",
                    style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 20.0,
                        color: Colors.blueGrey,
                        decoration: TextDecoration.none),
                  )
                ]),
          ),
        );
    }
  }
}
