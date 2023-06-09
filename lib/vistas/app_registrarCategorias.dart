import 'package:app_jugueria/controladores/categoriaController.dart';
import 'package:app_jugueria/componentes/app_text.dart';
import 'package:app_jugueria/componentes/app_buttons.dart';
import 'package:app_jugueria/componentes/app_textFieldRound.dart';
import 'package:app_jugueria/componentes/app_drawer.dart';
import 'package:app_jugueria/componentes/info_global.dart';
import 'package:app_jugueria/modelos/categoriaModel.dart';
import 'package:flutter/material.dart';

enum WidgetState { NONE, LOADING, LOADED, ERROR }

class AppRegistroCategoria extends StatefulWidget {
  CategoriaModel? categoriaModel;
  AppRegistroCategoria({this.categoriaModel, Key? key}) : super(key: key);
  @override
  State<AppRegistroCategoria> createState() {
    return _AppRegistroCategoriaState();
  }
}

class _AppRegistroCategoriaState extends State<AppRegistroCategoria> {
  late TextEditingController nombreCategoria;
  late TextEditingController letraCategoria;
  WidgetState _widgetState = WidgetState.LOADED;

  @override
  void initState() {
    super.initState();
    if (widget.categoriaModel != null) {
      nombreCategoria =
          TextEditingController(text: widget.categoriaModel!.nombreCategoria);
      letraCategoria =
          TextEditingController(text: widget.categoriaModel!.letraCategoria);
    } else {
      nombreCategoria = TextEditingController();
      letraCategoria = TextEditingController();
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

      if (nombreCategoria.text.toString().trim().length < 3) {
        InfoGlobal.mostrarAlerta(
            context, "Mensaje", "Ingrese una categoria valido.");
        setState(() {
          _widgetState = WidgetState.LOADED;
        });
        return;
      }

      if (letraCategoria.text.toString().trim().length != 1) {
        InfoGlobal.mostrarAlerta(
            context, "Mensaje", "Ingrese una letra valida.");
        setState(() {
          _widgetState = WidgetState.LOADED;
        });
        return;
      }

      CategoriaController categoriaCtrll = CategoriaController();
      if (widget.categoriaModel != null) {
        CategoriaModel categoriaModel = CategoriaModel(
            id: widget.categoriaModel!.id,
            nombreCategoria: nombreCategoria.text,
            letraCategoria: letraCategoria.text);

        await categoriaCtrll.updateCategoria(categoriaModel);
        InfoGlobal.mensajeConfirmacion(
            context, "Se ha actualizado correctamente.");
      } else {
        CategoriaModel categoriaModel = CategoriaModel(
            nombreCategoria: nombreCategoria.text,
            letraCategoria: letraCategoria.text);

        await categoriaCtrll.addCategoria(categoriaModel);
        InfoGlobal.mensajeConfirmacion(
            context, "Se ha registrado correctamente.");
      }

      final lista = await categoriaCtrll.getCategorias();
      InfoGlobal.incrementarVentanas();

      Navigator.of(context).pop();
      Navigator.of(context).pop();
      Navigator.pushNamed(
        context,
        '/lista-categorias',
        arguments: lista,
      );

      setState(() {
        _widgetState = WidgetState.LOADED;
      });
    } catch (e) {
      InfoGlobal.mensajeFallo(context, "No se pudo registrar.",5);
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
            title: (widget.categoriaModel != null)
                ? const Text("Editar Categoria")
                : const Text("Registrar Categoria"),
            backgroundColor: Colors.green.shade900,
          ),
          // drawer: AppMenuDrawer(),
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
            title: (widget.categoriaModel != null)
                ? const Text("Editar Categoria")
                : const Text("Registrar Categoria"),
            backgroundColor: Colors.green.shade900,
          ),
          // drawer: AppMenuDrawer(),
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
                  myController: nombreCategoria,
                ),
                AppText(text: "Letra", width: 320),
                AppTextFieldRound(
                  width: 320,
                  isPassword: false,
                  funcion: () {},
                  myController: letraCategoria,
                ),
                const SizedBox(height: 15),
                AppButtons(
                  textColor: Colors.white,
                  backgroundColor: Colors.blue,
                  borderColor: Colors.blue,
                  text: (widget.categoriaModel != null)
                      ? "Guardar cambios"
                      : "Registrar",
                  fontSize: 15,
                  width: 160,
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
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: const Text("Seleccionar mesa"),
            backgroundColor: Colors.green.shade900,
          ),
          // drawer: AppMenuDrawer(),
          body: const Center(
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
