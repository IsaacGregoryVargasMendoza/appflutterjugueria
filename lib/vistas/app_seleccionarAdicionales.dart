import 'dart:convert';
import 'package:app_jugueria/componentes/app_text.dart';
import 'package:app_jugueria/componentes/app_buttons.dart';
import 'package:app_jugueria/componentes/app_textFieldRound.dart';
import 'package:app_jugueria/componentes/app_drawer.dart';
import 'package:app_jugueria/modelos/categoriaModel.dart';
import 'package:app_jugueria/modelos/productoModel.dart';
import 'package:app_jugueria/modelos/adicionalModel.dart';
import 'package:app_jugueria/controladores/adicionalController.dart';
import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image/image.dart' as img;
// import 'dart:image';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
// import 'package:tflite/tflite.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';
import 'package:camera/camera.dart';
import 'package:app_jugueria/classifier/classifier.dart';
import 'dart:io';
import 'dart:async';

late List<CameraDescription> _cameras;

class AppSeleccionarAdicional extends StatefulWidget {
  List<ProductoModel>? productos;
  List<int>? cantidades;
  double total;

  AppSeleccionarAdicional(
      {this.productos, this.cantidades, required this.total, Key? key})
      : super(key: key);
  @override
  State<AppSeleccionarAdicional> createState() {
    return AppSeleccionarAdicionalState();
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
    fontSize: 16.0,
    fontWeight: FontWeight.bold,
    color: Colors.red,
    decoration: TextDecoration.none);

class AppSeleccionarAdicionalState extends State<AppSeleccionarAdicional> {
  WidgetState _widgetState = WidgetState.NONE;
  late List<CameraDescription> _camaras;
  late CameraController _cameraController;
  List<String> preguntas = ["¿Producto a agregar detalle?", "Detalle"];
  CameraImage? cameraImage;
  File? imagen;

  late Classifier _classifierLetras;
  // late Classifier _classifierNumeros;
  _ResultStatus _resultStatus = _ResultStatus.notStarted;
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
  // List<ProductoModel> listaProductos = [];
  // List<int> listaCantidades = [];
  //List<double> listaSubtotales = [];
  //double total = 0;
  int indice = -1;
  String preguntaActual = "¿PRODUCTO A AGREGAR DETALLE?";
  List<AdicionalModel> listaAdicionales = [];
  List<List<AdicionalModel>> listaDetalle = [];

  @override
  void initState() {
    super.initState();
    //loadModel();
    listaDetalle = List<List<AdicionalModel>>.generate(
        widget.productos!.length, (index) => []);
    _loadClassifier();
    inicializarCamara();
  }

  void _setAnalyzing(bool flag) {
    setState(() {
      _isAnalyzing = flag;
    });
  }

  void _analyzeImageProducto(File image) async {
    _setAnalyzing(true);

    final imageInput = img.decodeImage(image.readAsBytesSync())!;

    final resultCategory = _classifierLetras.predict(imageInput);

    final result = resultCategory.score >= 0.6
        ? _ResultStatus.found
        : _ResultStatus.notFound;
    final productoLabel = resultCategory.label;
    final accuracy = resultCategory.score;

    print("Producto");
    print(productoLabel);
    print(accuracy);

    if (productoLabel == "CONFIRMAR") {
      print("ENTRO A CONFIRMAR PEDIDO.");
      // Navigator.pushNamed(context, '/confirmar-pedido', arguments: {
      //   'listaProductos': widget.productos,
      //   'listaCantidades': widget.cantidades,
      //   'listaDetalles': listaDetalle
      // });
    } else if (productoLabel != "AFIRMAR" && productoLabel != "NEGAR") {
      ProductoModel productoEncontrado = widget.productos!.firstWhere(
          (producto) => producto.letraProducto == productoLabel,
          orElse: () => ProductoModel());

      if (productoEncontrado.id != null) {
        _producto = productoEncontrado;
        print('Producto encontrado: ${productoEncontrado.nombreProducto}');
        AdicionalController productoCtrll = AdicionalController();

        var adicionales = await productoCtrll
            .getAdicionalesPorCategoria(productoEncontrado.categoria!.id!);

        _setAnalyzing(false);
        setState(() {
          listaAdicionales = adicionales;
          preguntaActual = "INGRESAR ADICIONAL";
          _resultStatus = result;
          _plantLabel = productoLabel;
          _accuracy = accuracy;
          _letra = productoLabel;
        });
      } else {
        print('No se encontró un producto con la letra $productoLabel');
        _setAnalyzing(false);
        setState(() {
          preguntaActual = "¿PRODUCTO A AGREGAR DETALLE?";
        });
      }
    } else {
      print("No hay acciones para afimar o negar.");
    }
  }

  void _analyzeImageAdicional(File image) async {
    final imageInput = img.decodeImage(image.readAsBytesSync())!;

    final resultCategory = _classifierLetras.predict(imageInput);

    String adicionalLabel = resultCategory.label;
    final accuracy = resultCategory.score;

    if (adicionalLabel == "CONFIRMAR") {
      _setAnalyzing(false);
      setState(() {
        preguntaActual = "¿PRODUCTO A AGREGAR DETALLE?";
        _accuracy = accuracy;
      });
    } else if (adicionalLabel != "AFIRMAR" && adicionalLabel != "NEGAR") {
      AdicionalModel adicional = listaAdicionales.firstWhere(
          (adicional) => adicional.letraAdicional == adicionalLabel,
          orElse: () => AdicionalModel());

      if (adicional.id != null) {
        indice = widget.productos!
            .indexWhere((producto) => producto.id == _producto!.id);

        listaDetalle[indice].add(adicional);
        print(listaDetalle.length);
        print(listaDetalle[indice].length);

        _setAnalyzing(false);
        setState(() {
          _accuracy = accuracy;
        });
      } else {
        print('No se encontró un adicional con la letra $adicionalLabel');
        _setAnalyzing(false);
        setState(() {});
      }
    }
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

    // final classifierNumeros = await Classifier.loadWith(
    //   labelsFileName: _labelsFileNameNumeros,
    //   modelFileName: _modelFileNameNumeros,
    // );

    _classifierLetras = classifierLetras!;
    //_classifierNumeros = classifierNumeros!;
  }

  @override
  Widget build(BuildContext context) {
    switch (_widgetState) {
      case WidgetState.NONE:
      case WidgetState.LOADING:
        return _buildScaffold(
            context,
            const Center(
              child: CircularProgressIndicator(),
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
                    /*
                        Container(
                          // width: 200,
                          height: MediaQuery.of(context).size.height / 3,
                          color: Colors.amber,
                          // padding: const EdgeInsets.only(top: 50),
                          margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                          child: Transform.scale(
                            scale:
                                1, // Escala de 0.5 para reducir el tamaño a la mitad
                            child: CameraPreview(_cameraController),
                          ),
                          // child: CameraPreview(_cameraController),
                        ),
                        */
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
                    (_producto != null)
                        ? ProductoSeleccionado(producto: _producto!)
                        : const Text(
                            "",
                            style: TextStyle(fontSize: 20),
                          ),
                    (listaAdicionales.length > 0)
                        ? CarruselAdicionales(
                            listaAdicionales: listaAdicionales,
                          )
                        : const Text(
                            "",
                            style: TextStyle(fontSize: 20),
                          ),
                    const Text(
                      "Pedido:",
                      style: TextStyle(fontSize: 20),
                    ),
                    DetalleProductos(
                      listaProductos: widget.productos!,
                      listaDetalle: listaDetalle,
                      listaCantidades: widget.cantidades!,
                    ),
                    // CarruselProductos(
                    //   listaProductos: widget.productos!,
                    //   listaCantidades: widget.cantidades!,
                    // ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.fromLTRB(0, 5, 25, 0),
                      child: Text(
                        "Total: S/.${widget.total.toDouble()}",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.end,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        print("ENTRO A CONFIRMAR PEDIDO.");
                        Navigator.pushNamed(context, '/confirmar-pedido',
                            arguments: {
                              'listaProductos': widget.productos,
                              'listaCantidades': widget.cantidades,
                              'listaDetalles': listaDetalle,
                              'total': widget.total
                            });
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
                    GestureDetector(
                      onTap: () async {
                        var file = await _cameraController.takePicture();
                        final File newImage = File(file.path);

                        if (preguntaActual == "¿PRODUCTO A AGREGAR DETALLE?") {
                          _analyzeImageProducto(newImage);
                        } else {
                          _analyzeImageAdicional(newImage);
                        }

                        print("Se finalizo el proceso con exito.");
                      },
                      child: const Text(
                        "Confirmar",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ],
                ),
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
            ));
    }
  }

  Widget _buildScaffold(BuildContext context, Widget body) {
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(
      //   title: const Text("¿Que salsas desea?"),
      //   backgroundColor: Colors.green.shade800,
      // ),
      // drawer: AppMenuDrawer(),
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

  Future setImagen(opcion) async {
    var pickedFile;

    if (opcion == 1) {
      pickedFile = await picker.pickImage(source: ImageSource.camera);
    } else {
      pickedFile = await picker.pickImage(source: ImageSource.gallery);
    }

    print("Se finalizo el proceso con exito.");

    setState(() {
      if (pickedFile != null) {
        imagen = File(pickedFile.path);
        if (preguntaActual == "¿PRODUCTO A AGREGAR DETALLE?") {
          _analyzeImageProducto(imagen!);
        } else {
          _analyzeImageAdicional(imagen!);
        }
      } else {
        print("No seleccionaste ninguna foto");
      }
    });

    Navigator.of(context).pop();
  }
}

class ProductoSeleccionado extends StatelessWidget {
  final ProductoModel producto;

  ProductoSeleccionado({required this.producto});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      margin: EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        image: DecorationImage(
          image: MemoryImage(
            base64.decode(
              producto.imagenProducto!,
            ),
          ),
          fit: BoxFit.cover,
        ),
      ),
    );
    // Text(
    //   "${producto.nombreProducto!}",
    //   style: const TextStyle(fontSize: 16.0, color: Colors.black),
    // ),
  }
}

class CarruselProductos extends StatelessWidget {
  final List<ProductoModel> listaProductos;
  final List<int> listaCantidades;

  CarruselProductos(
      {required this.listaProductos, required this.listaCantidades});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 150,
      margin: const EdgeInsets.fromLTRB(5, 5, 5, 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.transparent,
      ),
      child: CarouselSlider.builder(
        options: CarouselOptions(
          height: 200.0,
          enlargeCenterPage: true,
          autoPlay: true,
          autoPlayInterval: Duration(seconds: 3),
          viewportFraction: 0.5,
          autoPlayAnimationDuration: const Duration(milliseconds: 800),
          autoPlayCurve: Curves.fastOutSlowIn,
        ),
        itemCount: listaProductos.length,
        itemBuilder: (BuildContext context, int index, int realIndex) {
          return Container(
            width: MediaQuery.of(context).size.width / 2,
            margin: EdgeInsets.symmetric(horizontal: 10.0),
            decoration: BoxDecoration(
              color: Colors.amber.shade100,
            ),
            child: Column(
              children: [
                Container(
                  width: 100,
                  height: 100,
                  margin: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    image: DecorationImage(
                      image: MemoryImage(
                        base64.decode(
                          listaProductos[index].imagenProducto!,
                        ),
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Text(
                  "${listaCantidades[index]} - ${listaProductos[index].nombreProducto!}",
                  style: const TextStyle(fontSize: 16.0, color: Colors.black),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class CarruselAdicionales extends StatelessWidget {
  final List<AdicionalModel> listaAdicionales;

  CarruselAdicionales({required this.listaAdicionales});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      //height: 250,
      //margin: const EdgeInsets.fromLTRB(5, 5, 5, 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.transparent,
      ),
      child: CarouselSlider.builder(
        options: CarouselOptions(
          height: 70,
          enlargeCenterPage: true,
          autoPlay: true,
          autoPlayInterval: Duration(seconds: 3),
          viewportFraction: 0.4,
          autoPlayAnimationDuration: const Duration(milliseconds: 800),
          autoPlayCurve: Curves.fastOutSlowIn,
        ),
        itemCount: listaAdicionales.length,
        itemBuilder: (BuildContext context, int index, int realIndex) {
          return Container(
            width: MediaQuery.of(context).size.width / 2,
            margin: const EdgeInsets.symmetric(horizontal: 10.0),
            height: 100,
            decoration: BoxDecoration(
                color: Colors.amber.shade100,
                borderRadius: BorderRadius.circular(20)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "${listaAdicionales[index].nombreAdicional}",
                  style: const TextStyle(fontSize: 16.0, color: Colors.black),
                ),
                Text(
                  '"${listaAdicionales[index].letraAdicional}"',
                  style: const TextStyle(
                      fontSize: 16.0,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class Detalle extends StatelessWidget {
  List<AdicionalModel> listaDetalle;

  Detalle({required this.listaDetalle});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: (20 * listaDetalle.length).toDouble(),
      width: MediaQuery.of(context).size.width / 2,
      color: Colors.transparent,
      child: ListView.builder(
        itemCount: listaDetalle.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              // print(listaProductos[index].id);
              // print(listaProductos[index].nombreProducto);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Text(
                //   "${listaProductos[index].nombreProducto}",
                //   style: const TextStyle(
                //     fontSize: 16,
                //     // fontWeight: FontWeight.bold,
                //   ),
                //   textAlign: TextAlign.start,
                // ),
                Text(
                  "- ${listaDetalle[index].nombreAdicional}",
                  style: const TextStyle(
                      fontSize: 16,
                      // fontWeight: FontWeight.bold,
                      color: Colors.black),
                  textAlign: TextAlign.end,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
//Mostrare una lista de los productos con sus detalles ejemplo
//sanguche de pollo:
//Mayonesa, aji cebolla y apio

//jugo de papaya
//sin helar y sin azucar
class DetalleProductos extends StatelessWidget {
  final List<ProductoModel> listaProductos;
  final List<int> listaCantidades;
  final List<List<AdicionalModel>>? listaDetalle;

  DetalleProductos(
      {required this.listaProductos,
      required this.listaCantidades,
      required this.listaDetalle});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 150,
      margin: const EdgeInsets.fromLTRB(5, 5, 5, 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey.shade100,
      ),
      child: Stack(children: <Widget>[
        ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: listaProductos.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                // print(listaProductos[index].id);
                // print(listaProductos[index].nombreProducto);
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
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${listaProductos[index].nombreProducto} (x${listaCantidades[index]}): "${listaProductos[index].letraProducto}"',
                          style: const TextStyle(
                            fontSize: 16,
                            // fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.start,
                        ),
                        (listaDetalle![index].length > 0)
                            ? Detalle(
                                listaDetalle: listaDetalle![index],
                              )
                            : const Text(
                                "Sin Detalle",
                                style: TextStyle(
                                  fontSize: 16,
                                  // fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.start,
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
