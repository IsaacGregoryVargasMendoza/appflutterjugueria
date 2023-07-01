import 'dart:convert';
import 'package:app_jugueria/componentes/app_text.dart';
import 'package:app_jugueria/componentes/app_buttons.dart';
import 'package:app_jugueria/componentes/app_textFieldRound.dart';
import 'package:app_jugueria/componentes/info_global.dart';
import 'package:app_jugueria/controladores/manualController.dart';
import 'package:app_jugueria/modelos/categoriaModel.dart';
import 'package:app_jugueria/modelos/manualModel.dart';
import 'package:app_jugueria/modelos/productoModel.dart';
import 'package:app_jugueria/controladores/productoController.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';

enum WidgetState { NONE, LOADING, LOADED, ERROR }

class AppRegistroManual extends StatefulWidget {
  AppRegistroManual({Key? key}) : super(key: key);
  @override
  State<AppRegistroManual> createState() {
    return AppRegistroManualState();
  }
}

class AppRegistroManualState extends State<AppRegistroManual> {
  late TextEditingController tecPaso;
  late TextEditingController tecDescripcion;
  List<(String, int)> tipos = [("CLIENTE", 0), ("ADMINISTRADOR", 1)];
  WidgetState _widgetState = WidgetState.LOADED;

  int idTipo = 0;
  File? imagen;
  final picker = ImagePicker();

  Future<File> convertirUint8ListAFile(
      Uint8List bytes, String nombreArchivo) async {
    final tempDir =
        await getTemporaryDirectory(); // Obtener directorio temporal
    final archivo = File('${tempDir.path}/$nombreArchivo'); // Crear objeto File
    await archivo.writeAsBytes(bytes); // Escribir bytes en el archivo

    return archivo;
  }

  // cargarimagen() async {
  //   try {
  //     if (imagen == null) {
  //       print("Cargar imagen.");
  //       var img = await convertirUint8ListAFile(
  //           base64.decode(widget.productoModel!.imagenProducto!),
  //           "${widget.productoModel!.id}${DateTime.now().millisecondsSinceEpoch}archivo.png");
  //       setState(() {
  //         imagen = img;
  //       });
  //     } else {
  //       print("Metodo else");
  //     }
  //   } catch (e) {
  //     print("ocurrio una excepcion.");
  //   }
  // }

  @override
  void initState() {
    super.initState();
    tecPaso = TextEditingController();
    tecDescripcion = TextEditingController();
    // if (widget.productoModel != null) {
    //   print(widget.productoModel!.categoria!.id!);
    //   tecNombreProducto =
    //       TextEditingController(text: widget.productoModel!.nombreProducto);
    //   tecDescripcion = TextEditingController(
    //       text: widget.productoModel!.descripcionProducto);
    //   tecPrecio = TextEditingController(
    //       text: widget.productoModel!.precioProducto.toString());
    //   tecLetra =
    //       TextEditingController(text: widget.productoModel!.letraProducto);
    //   idCategoria = widget.productoModel!.categoria!.id!;
    //   cargarimagen();
    // } else {
    //   tecPaso = TextEditingController();
    //   tecDescripcion = TextEditingController();
    // }
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

      if (tecPaso.text.toString().trim().isEmpty) {
        InfoGlobal.mostrarAlerta(
            context, "Mensaje", "Ingrese un nombre de producto valido.");
        setState(() {
          _widgetState = WidgetState.LOADED;
        });
        return;
      }

      if (tecDescripcion.text.toString().trim() == "0") {
        InfoGlobal.mostrarAlerta(
            context, "Mensaje", "Ingrese una descrpcion valido.");
        setState(() {
          _widgetState = WidgetState.LOADED;
        });
        return;
      }

      ManualController manualCtrll = ManualController();

      List<int> bytes = await imagen!.readAsBytesSync();
      String _imagen64 = base64.encode(bytes);

      ManualModel manualModel = ManualModel(
          pasoManual: int.parse(tecPaso.text),
          descripcionManual: tecDescripcion.text,
          tipoManual: idTipo,
          imagenManual: _imagen64);
      await manualCtrll.addManual(manualModel);
      InfoGlobal.mensajeConfirmacion(
          context, "Se ha registrado correctamente.");

      // if (widget.productoModel != null) {
      //   List<int> bytes = await imagen!.readAsBytesSync();
      //   String _imagen64 = base64.encode(bytes);

      //   ProductoModel productoModel = ProductoModel(
      //       id: widget.productoModel!.id,
      //       nombreProducto: tecNombreProducto.text,
      //       categoria: CategoriaModel(id: idCategoria),
      //       descripcionProducto: tecDescripcion.text,
      //       precioProducto: double.parse(tecPrecio.text),
      //       imagenProducto: _imagen64,
      //       letraProducto: tecLetra.text);
      //   await productoCtrll.updateProducto(productoModel);
      //   InfoGlobal.mensajeConfirmacion(
      //       context, "Se ha actualizado correctamente.");
      // } else {
      //   List<int> bytes = await imagen!.readAsBytesSync();
      //   String _imagen64 = base64.encode(bytes);

      //   ProductoModel productoModel = ProductoModel(
      //       nombreProducto: tecNombreProducto.text,
      //       categoria: CategoriaModel(id: idCategoria),
      //       descripcionProducto: tecDescripcion.text,
      //       precioProducto: double.parse(tecPrecio.text),
      //       imagenProducto: _imagen64,
      //       letraProducto: tecLetra.text);
      //   await productoCtrll.addProducto(productoModel);
      //   InfoGlobal.mensajeConfirmacion(
      //       context, "Se ha registrado correctamente.");
      // }
      // final lista = await productoCtrll.getProductos();

      // Navigator.of(context).pop();
      // Navigator.of(context).pop();
      // Navigator.pushNamed(
      //   context,
      //   '/lista-productos',
      //   arguments: lista,
      // );

      setState(() {
        _widgetState = WidgetState.LOADED;
      });
    } catch (e) {
      InfoGlobal.mensajeFallo(context, "No se pudo registrar.", 5);
      setState(() {
        _widgetState = WidgetState.NONE;
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
          // appBar: AppBar(
          //   title: (widget.productoModel != null)
          //       ? const Text("Editar producto")
          //       : const Text("Registro producto"),
          //   backgroundColor: Colors.green.shade900,
          // ),
          appBar: AppBar(
            title: const Text("Registro instrucciones"),
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
        //(widget.productoModel != null) ? cargarimagen() : print("nada");
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: const Text("Registro instrucciones"),
            backgroundColor: Colors.green.shade900,
          ),
          // drawer: AppMenuDrawer(),
          body: ListView(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.only(top: 50),
                child: Column(
                  children: [
                    InkWell(
                      onTap: () {
                        opciones(context);
                      },
                      child: Container(
                        // color: Colors.amber,
                        width: 250,
                        height: 300,
                        child: imagen == null
                            ? const Image(
                                image:
                                    AssetImage("assets/producto_sin_foto.png"))
                            : Image.file(imagen!),
                      ),
                    ),
                    const SizedBox(height: 15),
                    AppText(text: "Tipo", width: 320),
                    Container(
                      width: 320,
                      padding: const EdgeInsets.fromLTRB(20, 5, 20, 0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: const Color.fromRGBO(217, 217, 217, 1),
                      ),
                      child: (idTipo != 0)
                          ? DropdownButtonFormField(
                              value: idTipo,
                              decoration: const InputDecoration(
                                  border: InputBorder.none),
                              borderRadius: BorderRadius.circular(15),
                              items: tipos.map((tipo) {
                                return DropdownMenuItem(
                                    child: Text(tipo.$1), value: tipo.$2);
                              }).toList(),
                              onChanged: (value) {
                                idTipo = value!;
                              })
                          : DropdownButtonFormField(
                              decoration: const InputDecoration(
                                  border: InputBorder.none),
                              borderRadius: BorderRadius.circular(15),
                              items: tipos.map((tipo) {
                                return DropdownMenuItem(
                                    child: Text(tipo.$1), value: tipo.$2);
                              }).toList(),
                              onChanged: (value) {
                                idTipo = value!;
                              }),
                    ),
                    const SizedBox(height: 15),
                    AppText(text: "Descripcion", width: 320),
                    AppTextFieldRound(
                      width: 320,
                      isPassword: false,
                      funcion: () {},
                      myController: tecDescripcion,
                    ),
                    Container(
                      margin: const EdgeInsets.all(0),
                      padding: const EdgeInsets.all(0),
                      width: 150,
                      height: 250,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: Colors.blue,
                        ),
                      ),
                      child: TextField(
                        scrollController: ScrollController(),
                        keyboardType: TextInputType.multiline,
                        enableSuggestions: false,
                        autocorrect: false,
                        onSubmitted: (value) {
                          print("estoy terminando");
                        },
                        style: TextStyle(
                          fontSize: 14,

                          height: 2,
                          fontWeight: FontWeight.normal,
                          // backgroundColor: Colors.blue,
                          color: Colors.white,
                        ),
                        decoration: const InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 0),
                            border: InputBorder.none),
                        controller: TextEditingController(),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Container(
                      width: 320,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            child: Column(
                              children: [
                                AppText(text: "N° Orden", width: 150),
                                Container(
                                  margin: const EdgeInsets.all(0),
                                  padding: const EdgeInsets.all(0),
                                  width: 150,
                                  height: 45,
                                  decoration: BoxDecoration(
                                    color:
                                        const Color.fromRGBO(217, 217, 217, 1),
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(
                                      color: const Color.fromRGBO(
                                          217, 217, 217, 1),
                                    ),
                                  ),
                                  child: Scrollbar(
                                    controller: ScrollController(),
                                    child: TextField(
                                      scrollController: ScrollController(),
                                      keyboardType: TextInputType.number,
                                      enableSuggestions: false,
                                      autocorrect: false,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        height: 2,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.black,
                                      ),
                                      decoration: const InputDecoration(
                                          contentPadding: EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 0),
                                          border: InputBorder.none),
                                      controller: tecPaso,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 15),
                    const SizedBox(height: 15),
                    AppButtons(
                      textColor: Colors.white,
                      backgroundColor: Colors.blue,
                      borderColor: Colors.blue,
                      text: "Registrar",
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
            ],
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

  Future setImagen(opcion) async {
    var pickedFile;

    if (opcion == 1) {
      pickedFile = await picker.pickImage(source: ImageSource.camera);
    } else {
      pickedFile = await picker.pickImage(source: ImageSource.gallery);
    }

    setState(() {
      if (pickedFile != null) {
        imagen = File(pickedFile.path);
      } else {
        print("No seleccionaste ninguna foto");
      }
    });

    Navigator.of(context).pop();
  }

  opciones(context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(0),
          content: SingleChildScrollView(
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    setImagen(1);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    child: const Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Tomar una foto",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        FaIcon(FontAwesomeIcons.camera),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    setImagen(2);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    child: const Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Seleccionar una foto",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        FaIcon(FontAwesomeIcons.image),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
