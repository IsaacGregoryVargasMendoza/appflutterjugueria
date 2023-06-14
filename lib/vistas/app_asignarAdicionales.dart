import 'package:app_jugueria/controladores/adicionalController.dart';
import 'package:app_jugueria/controladores/categoriaController.dart';
import 'package:app_jugueria/modelos/adicionalModel.dart';
import 'package:app_jugueria/componentes/app_text.dart';
import 'package:app_jugueria/componentes/app_buttons.dart';
import 'package:app_jugueria/componentes/app_textFieldRound.dart';
import 'package:app_jugueria/componentes/app_drawer.dart';
import 'package:app_jugueria/componentes/info_global.dart';
import 'package:app_jugueria/modelos/categoriaModel.dart';
import 'package:flutter/material.dart';

class AppAsignarAdicional extends StatefulWidget {
  CategoriaModel? categoria;
  List<AdicionalModel>? adicionales;
  List<AdicionalModel>? adicionalesAsignados;

  AppAsignarAdicional(
      {this.categoria, this.adicionales, this.adicionalesAsignados, Key? key})
      : super(key: key);
  @override
  State<AppAsignarAdicional> createState() {
    return AppAsignarAdicionalState();
  }
}

class AppAsignarAdicionalState extends State<AppAsignarAdicional> {
  late TextEditingController nombreCategoria;
  bool _buttonDisabled = false;
  //List<AdicionalModel> adicionalesAsignados = [];
  static List<bool> isSelected = [];

  //String _estado = 'Estado inicial';

  void actualizarListaAdicionales(List<AdicionalModel> nuevaLista) {
    setState(() {
      widget.adicionalesAsignados = nuevaLista;
    });
  }

  @override
  void initState() {
    super.initState();
    isSelected =
        List<bool>.generate(widget.adicionales!.length, (index) => false);
    if (widget.categoria != null) {
      nombreCategoria =
          TextEditingController(text: widget.categoria!.nombreCategoria);
    } else {
      nombreCategoria = TextEditingController();
    }
  }

  void _disableButton() {
    setState(() {
      _buttonDisabled = true;
    });
  }

  @override
  void dispose() {
    super.dispose();
    InfoGlobal.decrementarVentanas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Asignar Adicionales"),
        backgroundColor: Colors.green.shade900,
      ),
      drawer: AppMenuDrawer(),
      body: ListView(
        children: [
          Container(
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
                const SizedBox(height: 15),
                AppText(text: "Adicionales", width: 320),
                GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) => ModalAdicionales(
                        adicionales: widget.adicionales,
                        adicionalesAsignados: widget.adicionalesAsignados,
                        actualizarEstado: actualizarListaAdicionales,
                      ),
                    );
                    //abrirModalAdicionales();
                  },
                  child: const Text(
                    "+ Agregar adicional",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.red),
                    textAlign: TextAlign.start,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    //border: Border.all(color: Colors.grey, width: 1.5),
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.grey.shade300,
                  ),
                  width: 320,
                  height: 350,
                  child: ListView.builder(
                    itemCount: widget.adicionalesAsignados!.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () async {},
                        child: Container(
                          width: 150,
                          height: 35,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                spreadRadius: 2,
                                blurRadius: 7,
                                offset: Offset(
                                    0, 3), // cambia la posición de la sombra
                              ),
                            ],
                            borderRadius: BorderRadius.circular(20),
                            //borderRadius: BorderRadius.circular(0),
                            border: Border.all(
                              style: BorderStyle.solid,
                              width: 0.5,
                              color: Colors.white,
                            ),
                            color: Colors.white,
                          ),
                          margin: const EdgeInsets.fromLTRB(10, 20, 10, 0),
                          child: Center(
                            child: Text(
                              "${widget.adicionalesAsignados![index].nombreAdicional}",
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 15),
                AppButtons(
                  textColor: Colors.white,
                  backgroundColor: Colors.blue,
                  borderColor: Colors.blue,
                  text: "Guardar cambios",
                  fontSize: 15,
                  width: 160,
                  height: 50,
                  funcion: () async {
                    AdicionalController adicionalCtrll = AdicionalController();
                    if (widget.adicionalesAsignados!.isNotEmpty) {
                      List<CategoriaAdicionalModel> lista = [];

                      for (int i = 0; i < isSelected.length; i++) {
                        if (isSelected[i]) {
                          CategoriaAdicionalModel value =
                              CategoriaAdicionalModel(
                                  idAdicional: widget.adicionales![i].id,
                                  idCategoria: widget.categoria!.id,
                                  estaActivo: 1);
                          lista.add(value);
                        }
                      }
                      await adicionalCtrll
                          .deleteCategoriaAdicional(widget.categoria!.id!);
                      await adicionalCtrll.addCategoriaAdicional(lista);
                    } else {
                      await adicionalCtrll
                          .deleteCategoriaAdicional(widget.categoria!.id!);
                    }

                    CategoriaController categoriaCtrll = CategoriaController();
                    final listaCategorias =
                        await categoriaCtrll.getCategorias();
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                    Navigator.pushNamed(
                      context,
                      '/lista-categorias',
                      arguments: listaCategorias,
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void showRegistrationSuccessMessage(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Registration successful!'),
      ),
    );
  }

  abrirModalAdicionales() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height,
          color: Colors.red,
          padding: const EdgeInsets.fromLTRB(0, 100, 0, 0),
          child: ListView.builder(
            itemCount: widget.adicionales!.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () async {
                  setState(() {
                    isSelected[index] = !isSelected[index];
                  });
                },
                child: Container(
                  width: 150,
                  //height: 50,
                  //color: Colors.amber,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: isSelected[index]
                            ? const Color.fromRGBO(76, 175, 80, 1)
                            : Colors.white, //Colors.grey.withOpacity(0.1),
                        spreadRadius: 2,
                        blurRadius: 7,
                        offset: Offset(0, 3), // cambia la posición de la sombra
                      ),
                    ],
                    border: Border.all(
                      style: BorderStyle.solid,
                      width: 0.5,
                      color: Colors.white,
                    ),
                    color: Colors.white,
                  ),
                  margin: const EdgeInsets.fromLTRB(10, 20, 10, 0),
                  child: Text(
                    "${widget.adicionales![index].nombreAdicional}",
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class ModalAdicionales extends StatefulWidget {
  List<AdicionalModel>? adicionales;
  List<AdicionalModel>? adicionalesAsignados;
  final Function(List<AdicionalModel>)? actualizarEstado;

  ModalAdicionales(
      {this.adicionales,
      this.adicionalesAsignados,
      this.actualizarEstado,
      Key? key})
      : super(key: key);

  @override
  ModalAdicionalesState createState() => ModalAdicionalesState();
}

class ModalAdicionalesState extends State<ModalAdicionales> {
  int counter = 0;
  //List<AdicionalModel>? adicionalesAsignados = [];

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < widget.adicionales!.length; i++) {
      final rpta = widget.adicionalesAsignados!
          .where((element) => element.id == widget.adicionales![i].id);
      if (rpta.isNotEmpty) {
        setState(() {
          AppAsignarAdicionalState.isSelected[i] = true;
        });
      }
    }
  }

  void incrementCounter() {
    setState(() {
      counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      //color: Colors.red,
      padding: const EdgeInsets.fromLTRB(0, 100, 0, 0),
      child: ListView.builder(
        itemCount: widget.adicionales!.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () async {
              setState(() {
                AppAsignarAdicionalState.isSelected[index] =
                    !AppAsignarAdicionalState.isSelected[index];
              });
              if (AppAsignarAdicionalState.isSelected[index]) {
                widget.adicionalesAsignados!.add(widget.adicionales![index]);
              } else {
                widget.adicionalesAsignados!.removeWhere((adicional) =>
                    adicional.id == widget.adicionales![index].id);
              }
              widget.actualizarEstado!(widget.adicionalesAsignados!);
            },
            child: Container(
              width: 150,
              height: 40,
              //color: Colors.amber,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 2,
                    blurRadius: 7,
                    offset: Offset(0, 3), // cambia la posición de la sombra
                  ),
                ],
                border: Border.all(
                  style: BorderStyle.solid,
                  width: 0.5,
                  color: Colors.white,
                ),
                borderRadius: BorderRadius.circular(25),
                color: AppAsignarAdicionalState.isSelected[index]
                    ? const Color.fromRGBO(76, 175, 80, 1)
                    : Colors.white,
              ),
              margin: const EdgeInsets.fromLTRB(10, 20, 10, 0),
              child: Center(
                child: Text(
                  "${widget.adicionales![index].nombreAdicional}",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.normal,
                      color: AppAsignarAdicionalState.isSelected[index]
                          ? Colors.white
                          : Colors.black),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
