import 'dart:convert';
import 'package:app_jugueria/componentes/app_drawer.dart';
import 'package:app_jugueria/componentes/info_global.dart';
import 'package:app_jugueria/modelos/productoModel.dart';
import 'package:app_jugueria/controladores/productoController.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:camera/camera.dart';
import 'package:app_jugueria/classifier/classifier.dart';
import 'dart:io';
import 'dart:async';

late List<CameraDescription> _cameras;

class AppSeleccionarProducto extends StatefulWidget {
  List<ProductoModel>? listaProductos;

  AppSeleccionarProducto({this.listaProductos, Key? key}) : super(key: key);
  @override
  State<AppSeleccionarProducto> createState() {
    return _AppSeleccionarProductoState();
  }
}

enum WidgetState { NONE, LOADING, LOADED, ERROR }

enum _ResultStatus {
  notStarted,
  notFound,
  found,
}

const kAnalyzingTextStyle = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 20.0,
    color: Colors.black,
    decoration: TextDecoration.none);

const kPreguntaTextStyle = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 20.0,
    fontWeight: FontWeight.bold,
    color: Colors.red,
    decoration: TextDecoration.none);

class _AppSeleccionarProductoState extends State<AppSeleccionarProducto> {
  WidgetState _widgetState = WidgetState.NONE;
  late List<CameraDescription> _camaras;
  late CameraController _cameraController;
  List<String> preguntas = ["¿QUE PRODUCTO DESEA?", "¿QUE CANTIDAD DESEA?"];
  CameraImage? cameraImage;

  //Nueva forma de leer la imagen
  late Classifier _classifierLetras;
  late Classifier _classifierNumeros;
  final String _labelsFileName = 'assets/labels.txt';
  final String _modelFileName = 'model.tflite';
  final String _labelsFileNameNumeros = 'assets/labels_numeros.txt';
  final String _modelFileNameNumeros = 'model_numeros.tflite';
  final picker = ImagePicker();
  File? _selectedImageFile;
  String _plantLabel = ''; // Name of Error Message
  double _accuracy = 0.0;
  String _letra = "";
  bool _isAnalyzing = false;
  ProductoModel? _producto;
  File? imagen;
  List<ProductoModel> listaProductos = [];
  List<int> listaCantidades = [];
  List<double> listaSubtotales = [];
  double total = 0;
  int indice = -1;
  String preguntaActual = "¿QUE PRODUCTO DESEA?";

  @override
  void initState() {
    super.initState();
    //loadModel();
    _loadClassifier();
    inicializarCamara();
  }

  @override
  void dispose() {
    super.dispose();
    InfoGlobal.decrementarVentanas();
  }

  void _setAnalyzing(bool flag) {
    setState(() {
      _isAnalyzing = flag;
    });
  }

  void _analyzeImageProducto(File image) async {
    _setAnalyzing(true);

    final imageInput = img.decodeImage(image.readAsBytesSync())!;
    //final imageInput = imgds;

    final resultCategory = _classifierLetras.predict(imageInput);

    final result = resultCategory.score >= 0.6
        ? _ResultStatus.found
        : _ResultStatus.notFound;
    final plantLabel = resultCategory.label;
    final accuracy = resultCategory.score;

    print("Producto");
    print(plantLabel);
    print(accuracy);

    ProductoController productoCtrll = ProductoController();

    var producto = await productoCtrll.getProductoWithLetter(plantLabel);

    if (producto.length > 0) {
      if (listaProductos.length > 0) {
        int index = listaProductos.indexWhere((p) => p.id == producto[0].id);

        if (index > -1) {
          indice = index;
          _producto = listaProductos[indice];
        } else {
          _producto = producto[0];
          listaProductos.add(_producto!);
          listaCantidades.add(1);
          listaSubtotales.add(_producto!.precioProducto! * 1);
        }
      } else {
        _producto = producto[0];
        listaProductos.add(_producto!);
        listaCantidades.add(1);
        listaSubtotales.add(_producto!.precioProducto! * 1);
      }

      total = listaSubtotales
          .reduce((valorAnterior, valorActual) => valorAnterior + valorActual);

      _setAnalyzing(false);
      setState(() {
        preguntaActual = "¿QUE CANTIDAD DESEA?";
        _plantLabel = plantLabel;
        _accuracy = accuracy;
        _letra = plantLabel;
      });
    } else {
      _setAnalyzing(false);
    }
  }

  void _analyzeImageCantidad(File image) async {
    final imageInput = img.decodeImage(image.readAsBytesSync())!;

    final resultCategory = _classifierNumeros.predict(imageInput);

    final plantLabel = resultCategory.label;
    final accuracy = resultCategory.score;

    print("Cantidad");
    print(plantLabel);
    print(accuracy);

    int cantidad = 0;

    switch (plantLabel) {
      case "UNO":
        cantidad = 1;
        break;
      case "DOS":
        cantidad = 2;
        break;
      case "TRES":
        cantidad = 3;
        break;
      case "CUATRO":
        cantidad = 4;
        break;
      case "CINCO":
        cantidad = 5;
        break;
      case "SEIS":
        cantidad = 6;
        break;
      case "SIETE":
        cantidad = 7;
        break;
      case "OCHO":
        cantidad = 8;
        break;
      case "NUEVE":
        cantidad = 9;
        break;
      default:
        cantidad = 1;
        break;
    }

    if (indice > -1) {
      listaCantidades[indice] = cantidad;
      listaSubtotales[indice] = _producto!.precioProducto! * cantidad;
      indice = -1;
    } else {
      listaCantidades[listaCantidades.length - 1] = cantidad;
      listaSubtotales[listaSubtotales.length - 1] =
          _producto!.precioProducto! * cantidad;
    }

    total = listaSubtotales
        .reduce((valorAnterior, valorActual) => valorAnterior + valorActual);

    _setAnalyzing(false);
    setState(() {
      preguntaActual = "¿QUE PRODUCTO DESEA?";
      _producto = null;
      //_resultStatus = result;
      _plantLabel = plantLabel;
      _accuracy = accuracy;
      _letra = plantLabel;
    });
  }

  Future<void> _loadClassifier() async {
    debugPrint(
      'Start loading of Classifier with '
      'labels at $_labelsFileName, '
      'model at $_modelFileName',
    );

    final classifierLetras = await Classifier.loadWith(
      labelsFileName: _labelsFileName,
      modelFileName: _modelFileName,
    );

    final classifierNumeros = await Classifier.loadWith(
      labelsFileName: _labelsFileNameNumeros,
      modelFileName: _modelFileNameNumeros,
    );

    _classifierLetras = classifierLetras!;
    _classifierNumeros = classifierNumeros!;
  }

  @override
  Widget build(BuildContext context) {
    switch (_widgetState) {
      case WidgetState.NONE:
      case WidgetState.LOADING:
        return _buildScaffold(
            context,
            Center(
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
          ));
      case WidgetState.LOADED:
        return _buildScaffold(
          context,
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: ListView(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        opciones(context);
                      },
                      child: Container(
                        width: 180,
                        height: 200,
                        child: imagen == null
                            ? const Image(
                                image:
                                    AssetImage("assets/producto_sin_foto.png"))
                            : Image.file(imagen!),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                      height: 180,
                      width: MediaQuery.of(context).size.height,
                      child: CarouselSlider.builder(
                          options: CarouselOptions(
                            //height: 200.0,
                            enlargeCenterPage: true,
                            autoPlay: true,
                            autoPlayInterval: Duration(seconds: 3),
                            viewportFraction: 0.5,
                            autoPlayAnimationDuration:
                                const Duration(milliseconds: 800),
                            autoPlayCurve: Curves.fastOutSlowIn,
                          ),
                          itemCount: widget.listaProductos!.length,
                          itemBuilder:
                              (BuildContext context, int index, int realIndex) {
                            return ProductCard(
                                producto: widget.listaProductos![index]);
                          }),
                    ),
                    Text(
                      "${preguntaActual}",
                      style: kPreguntaTextStyle,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    (!_isAnalyzing)
                        ? Text(
                            (_producto != null)
                                ? '${_producto!.nombreProducto}'
                                : '',
                            style: kAnalyzingTextStyle)
                        : const Text('Analizando...',
                            style: kAnalyzingTextStyle),
                    const Text(
                      "Pedido:",
                      style: TextStyle(fontSize: 20),
                    ),
                    DetallePedido(
                        listaProductos: listaProductos,
                        listaCantidades: listaCantidades),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.fromLTRB(0, 5, 25, 0),
                      child: Text(
                        "Total: S/.${total.toDouble()}",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.end,
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        if (listaProductos.isNotEmpty) {
                          Navigator.pushNamed(
                              context, '/seleccionar-adicionales', arguments: {
                            'productos': listaProductos,
                            'cantidades': listaCantidades,
                            'total': total
                          });
                        } else {
                          print("La lista de productos esta vacia.");
                        }
                      },
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          image: const DecorationImage(
                            image: AssetImage("assets/ok.png"),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    const Text(
                      "Confirmar",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.end,
                    ),
                  ],
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        );

      case WidgetState.ERROR:
        return _buildScaffold(
          context,
          const Center(
            child: Text(
                "La camara no se pudo inicializar, Reinicia la aplicacion."),
          ),
        );
    }
  }

  Widget _buildScaffold(BuildContext context, Widget body) {
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(
      //   title: const Text("Pedido de productos"),
      //   backgroundColor: Colors.green.shade800,
      // ),
      drawer: AppMenuDrawer(),
      body: body,
    );
  }

  Future inicializarCamara() async {
    _widgetState = WidgetState.LOADING;

    if (mounted) {
      setState(
        () {},
      );
    }

    _camaras = await availableCameras();
    _cameraController =
        new CameraController(_camaras[0], ResolutionPreset.ultraHigh);

    _cameraController.setFlashMode(FlashMode.off);

    await _cameraController.initialize();

    if (_cameraController.value.hasError) {
      _widgetState = WidgetState.ERROR;
      if (mounted) {
        setState(() {});
      }
    } else {
      _widgetState = WidgetState.LOADED;
      if (mounted) {
        setState(() {});
      }
    }
  }

  Future setImagen(opcion) async {
    var pickedFile;

    if (opcion == 1) {
      pickedFile = await picker.pickImage(source: ImageSource.camera);
    } else {
      pickedFile = await picker.pickImage(source: ImageSource.gallery);
    }

    // imagen = File(pickedFile.path);
    // if (preguntaActual == "¿QUE PRODUCTO DESEA?") {
    //   _analyzeImageProducto(imagen!);
    // } else {
    //   _analyzeImageCantidad(imagen!);
    // }

    print("Se finalizo el proceso con exito.");

    setState(() {
      if (pickedFile != null) {
        imagen = File(pickedFile.path);
        if (preguntaActual == "¿QUE PRODUCTO DESEA?") {
          _analyzeImageProducto(imagen!);
        } else {
          _analyzeImageCantidad(imagen!);
        }
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

class DetallePedido extends StatelessWidget {
  final List<ProductoModel> listaProductos;
  final List<int> listaCantidades;

  DetallePedido({required this.listaProductos, required this.listaCantidades});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 150,
      //margin: const EdgeInsets.fromLTRB(5, 5, 5, 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey.shade100,
      ),
      child: Stack(children: <Widget>[
        ListView.builder(
          padding: const EdgeInsets.all(2),
          itemCount: listaProductos.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                print(listaProductos[index].id);
                print(listaProductos[index].nombreProducto);
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding:
                        const EdgeInsetsDirectional.fromSTEB(20, 10, 20, 10),
                    decoration: const BoxDecoration(
                        // color: Colors.white,
                        // border: BorderDirectional(
                        //   bottom: BorderSide(width: 0.5),
                        // ),
                        ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 170, // Ancho máximo permitido
                          child: Text(
                            "${listaProductos[index].nombreProducto}",
                            style: const TextStyle(
                              fontSize: 16,
                              // fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.start,
                            overflow: TextOverflow
                                .ellipsis, // Recorta el texto y muestra puntos suspensivos al final
                            maxLines: 1, // Limita el texto a una sola línea
                          ),
                        ),
                        Text(
                          ((listaCantidades[index] != null)
                              ? "S/.${listaProductos[index].precioProducto} x ${listaCantidades[index]} = S/.${listaProductos[index].precioProducto! * listaCantidades[index]}"
                              : "0"),
                          style: const TextStyle(
                            fontSize: 16,
                            // fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.end,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ]),
    );
  }
}

class ProductCard extends StatelessWidget {
  final ProductoModel producto;

  ProductCard({required this.producto});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      width: MediaQuery.of(context).size.width / 2,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.amber.shade100),
      child: Column(
        children: [
          Expanded(
            child: Container(
              width: 100,
              height: 100,
              margin: EdgeInsets.all(5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                //color: Colors.amber,
                image: DecorationImage(
                  image: MemoryImage(
                    base64.decode(
                      producto.imagenProducto!,
                    ),
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          // SizedBox(height: 10),
          Text(producto.nombreProducto!, style: TextStyle(fontSize: 14)),

          Text(producto.letraProducto!, style: TextStyle(fontSize: 25)),
        ],
      ),
    );
  }
}
