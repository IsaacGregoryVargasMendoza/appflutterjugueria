import 'dart:convert';
import 'package:app_jugueria/componentes/app_text.dart';
import 'package:app_jugueria/componentes/app_buttons.dart';
import 'package:app_jugueria/componentes/app_textFieldRound.dart';
import 'package:app_jugueria/componentes/app_drawer.dart';
import 'package:app_jugueria/modelos/categoriaModel.dart';
import 'package:app_jugueria/modelos/productoModel.dart';
import 'package:app_jugueria/vistas/app_listaProductos.dart';
import 'package:app_jugueria/controladores/productoController.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';

class AppRegistroProducto extends StatefulWidget {
  List<CategoriaModel>? listaCategorias;
  ProductoModel? productoModel;

  AppRegistroProducto({this.listaCategorias, this.productoModel, Key? key})
      : super(key: key);
  @override
  State<AppRegistroProducto> createState() {
    return _AppRegistroProductoState();
  }
}

class _AppRegistroProductoState extends State<AppRegistroProducto> {
  late TextEditingController tecNombreProducto;
  late TextEditingController tecCategoria;
  late TextEditingController tecDescripcion;
  late TextEditingController tecPrecio;
  late TextEditingController tecLetra;
  int idCategoria = 0;
  File? imagen;
  final picker = ImagePicker();
  bool _buttonDisabled = false;

  Future<File> convertirUint8ListAFile(
      Uint8List bytes, String nombreArchivo) async {
    final tempDir =
        await getTemporaryDirectory(); // Obtener directorio temporal
    final archivo = File('${tempDir.path}/$nombreArchivo'); // Crear objeto File
    await archivo.writeAsBytes(bytes); // Escribir bytes en el archivo

    return archivo;
  }

  cargarimagen() async {
    try {
      if (imagen == null) {
        print("Cargar imagen.");
        var img = await convertirUint8ListAFile(
            base64.decode(widget.productoModel!.imagenProducto!),
            "${widget.productoModel!.id}${DateTime.now().millisecondsSinceEpoch}archivo.png");
        setState(() {
          imagen = img;
        });
      } else {
        print("Metodo else");
      }
    } catch (e) {
      print("ocurrio una excepcion.");
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.productoModel != null) {
      tecNombreProducto =
          TextEditingController(text: widget.productoModel!.nombreProducto);
      tecDescripcion = TextEditingController(
          text: widget.productoModel!.descripcionProducto);
      tecPrecio = TextEditingController(
          text: widget.productoModel!.precioProducto.toString());
      tecLetra =
          TextEditingController(text: widget.productoModel!.letraProducto);
      idCategoria = widget.productoModel!.categoria!.id!;
      cargarimagen();
    } else {
      tecNombreProducto = TextEditingController();
      tecDescripcion = TextEditingController();
      tecPrecio = TextEditingController();
      tecLetra = TextEditingController();
    }
  }

  void _disableButton() {
    setState(() {
      _buttonDisabled = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    (widget.productoModel != null) ? cargarimagen() : print("nada");
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: (widget.productoModel != null)
            ? Text("Editar producto")
            : Text("Registro producto"),
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
                AppText(text: "Producto", width: 320),
                AppTextFieldRound(
                  width: 320,
                  isPassword: false,
                  funcion: () {},
                  myController: tecNombreProducto,
                ),
                const SizedBox(height: 15),
                AppText(text: "Categoria", width: 320),
                Container(
                  width: 320,
                  padding: const EdgeInsets.fromLTRB(20, 5, 20, 0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: const Color.fromRGBO(217, 217, 217, 1),
                  ),
                  child: (idCategoria != 0)
                      ? DropdownButtonFormField(
                          value: idCategoria,
                          decoration:
                              const InputDecoration(border: InputBorder.none),
                          borderRadius: BorderRadius.circular(15),
                          items: widget.listaCategorias!.map((categoria) {
                            return DropdownMenuItem(
                                child: Text(categoria.nombreCategoria!),
                                value: categoria.id);
                          }).toList(),
                          onChanged: (value) {
                            idCategoria = value!;
                            //print(value);
                          })
                      : DropdownButtonFormField(
                          decoration:
                              const InputDecoration(border: InputBorder.none),
                          borderRadius: BorderRadius.circular(15),
                          items: widget.listaCategorias!.map((categoria) {
                            return DropdownMenuItem(
                                child: Text(categoria.nombreCategoria!),
                                value: categoria.id);
                          }).toList(),
                          onChanged: (value) {
                            idCategoria = value!;
                            //print(value);
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
                const SizedBox(height: 15),
                Container(
                  width: 320,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: Column(
                          children: [
                            AppText(text: "Precio", width: 150),
                            Container(
                              margin: const EdgeInsets.all(0),
                              padding: const EdgeInsets.all(0),
                              width: 150,
                              height: 45,
                              decoration: BoxDecoration(
                                color: const Color.fromRGBO(217, 217, 217, 1),
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(
                                  color: const Color.fromRGBO(217, 217, 217, 1),
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
                                  controller: tecPrecio,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        child: Column(
                          children: [
                            AppText(text: "Letra", width: 150),
                            Container(
                              margin: const EdgeInsets.all(0),
                              padding: const EdgeInsets.all(0),
                              width: 150,
                              height: 45,
                              decoration: BoxDecoration(
                                color: const Color.fromRGBO(217, 217, 217, 1),
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(
                                  color: const Color.fromRGBO(217, 217, 217, 1),
                                ),
                              ),
                              child: Scrollbar(
                                controller: ScrollController(),
                                child: TextField(
                                  scrollController: ScrollController(),
                                  keyboardType: TextInputType.text,
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
                                  controller: tecLetra,
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
                InkWell(
                  onTap: () {
                    opciones(context);
                  },
                  child: Container(
                    width: 180,
                    height: 200,
                    child: imagen == null
                        ? const Image(
                            image: AssetImage("assets/producto_sin_foto.png"))
                        : Image.file(imagen!),
                  ),
                ),
                const SizedBox(height: 15),
                AppButtons(
                  textColor: Colors.white,
                  backgroundColor: Colors.blue,
                  borderColor: Colors.blue,
                  text: (widget.productoModel != null)
                      ? "Guardar cambios"
                      : "Registrar",
                  fontSize: 15,
                  width: 140,
                  height: 50,
                  funcion: () async {
                    if (_buttonDisabled) {
                      print("No hare nada porque ya precionaste una vez.");
                    } else {
                      _disableButton();
                      ProductoController productoCtrll = ProductoController();
                      if (widget.productoModel != null) {
                        List<int> bytes = await imagen!.readAsBytesSync();
                        String _imagen64 = base64.encode(bytes);

                        ProductoModel productoModel = ProductoModel(
                            id: widget.productoModel!.id,
                            nombreProducto: tecNombreProducto.text,
                            categoria: CategoriaModel(id: idCategoria),
                            descripcionProducto: tecDescripcion.text,
                            precioProducto: double.parse(tecPrecio.text),
                            imagenProducto: _imagen64,
                            letraProducto: tecLetra.text);
                        await productoCtrll.updateProducto(productoModel);
                      } else {
                        List<int> bytes = await imagen!.readAsBytesSync();
                        String _imagen64 = base64.encode(bytes);

                        ProductoModel productoModel = ProductoModel(
                            nombreProducto: tecNombreProducto.text,
                            categoria: CategoriaModel(id: idCategoria),
                            descripcionProducto: tecDescripcion.text,
                            precioProducto: double.parse(tecPrecio.text),
                            imagenProducto: _imagen64,
                            letraProducto: tecLetra.text);
                        await productoCtrll.addProducto(productoModel);
                      }
                      final lista = await productoCtrll.getProductos();

                      // Navigator.of(context).pop();
                      // Navigator.of(context).push(MaterialPageRoute(
                      //     builder: (context) => AppListaProducto(lista)));
                      Navigator.pushNamed(
                        context,
                        '/lista-productos',
                        arguments: lista,
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
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
