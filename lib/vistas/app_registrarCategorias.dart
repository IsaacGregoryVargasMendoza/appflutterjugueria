import 'package:app_jugueria/controladores/categoriaController.dart';
import 'package:app_jugueria/componentes/app_text.dart';
import 'package:app_jugueria/componentes/app_buttons.dart';
import 'package:app_jugueria/componentes/app_textFieldRound.dart';
import 'package:app_jugueria/componentes/app_drawer.dart';
import 'package:app_jugueria/modelos/categoriaModel.dart';
import 'package:flutter/material.dart';

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
  bool _buttonDisabled = false;

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
        title: (widget.categoriaModel != null)
            ? Text("Editar Categoria")
            : Text("Registrar Categoria"),
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
                if (_buttonDisabled) {
                  print("No hare nada porque ya precionaste una vez.");
                } else {
                  _disableButton();
                  if (widget.categoriaModel != null) {
                    CategoriaController categoriaCtrll = CategoriaController();
                    CategoriaModel categoriaModel = CategoriaModel(
                        id: widget.categoriaModel!.id,
                        nombreCategoria: nombreCategoria.text,
                        letraCategoria: letraCategoria.text);

                    await categoriaCtrll.updateCategoria(categoriaModel);

                    final lista = await categoriaCtrll.getCategorias();
                    // Navigator.of(context).pop();
                    // Navigator.of(context).push(MaterialPageRoute(
                    //     builder: (context) => AppListaCategoria(lista)));
                    Navigator.pushNamed(
                      context,
                      '/lista-categorias',
                      arguments: lista,
                    );
                  } else {
                    CategoriaController categoriaCtrll = CategoriaController();
                    CategoriaModel categoriaModel = CategoriaModel(
                        nombreCategoria: nombreCategoria.text,
                        letraCategoria: letraCategoria.text);

                    await categoriaCtrll.addCategoria(categoriaModel);

                    final lista = await categoriaCtrll.getCategorias();
                    Navigator.pushNamed(
                      context,
                      '/lista-categorias',
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
