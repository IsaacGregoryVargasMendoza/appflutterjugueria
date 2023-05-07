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
import 'dart:typed_data';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image/image.dart' as img;
// import 'dart:image';
// import 'package:tflite/tflite.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';
import 'package:camera/camera.dart';
import 'dart:io';
import 'dart:async';

late List<CameraDescription> _cameras;

class AppSeleccionarProducto extends StatefulWidget {
  List<CategoriaModel> data;

  AppSeleccionarProducto(this.data, {Key? key}) : super(key: key);
  @override
  State<AppSeleccionarProducto> createState() {
    return _AppSeleccionarProductoState();
  }
}

enum WidgetState { NONE, LOADING, LOADED, ERROR }

class _AppSeleccionarProductoState extends State<AppSeleccionarProducto> {
  WidgetState _widgetState = WidgetState.NONE;
  late List<CameraDescription> _camaras;
  late CameraController _cameraController;
  late Interpreter _interpreter;
  List<String> preguntas = ["¿Que producto desea?", "¿Que cantidad desea?"];
  CameraImage? cameraImage;
  late List<int> _inputShape;
  late dynamic _inputDataType;
  late List<int> _outputShape;
  late dynamic _outputDataType;

  @override
  void initState() {
    super.initState();
    loadModel();
    inicializarCamara();
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "${preguntas[0]}",
                    style: TextStyle(fontSize: 18),
                  ),
                  Container(
                    // width: 200,
                    height: MediaQuery.of(context).size.height / 3,
                    color: Colors.amber,
                    // padding: const EdgeInsets.only(top: 50),
                    margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                    child: Transform.scale(
                      scale:
                          1, // Escala de 0.5 para reducir el tamaño a la mitad
                      child: CameraPreview(_cameraController),
                    ),
                    // child: CameraPreview(_cameraController),
                  ),
                  const Text(
                    "Pedido:",
                    style: TextStyle(fontSize: 20),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 150,
                    margin: EdgeInsets.fromLTRB(5, 5, 5, 0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey.shade100,
                    ),
                    child: Stack(children: <Widget>[
                      ListView.builder(
                        padding: const EdgeInsets.all(20),
                        itemCount: widget.data.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              print(widget.data[index].id);
                              print(widget.data[index].nombreCategoria);
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      20, 10, 20, 10),
                                  decoration: const BoxDecoration(
                                      // color: Colors.white,
                                      // border: BorderDirectional(
                                      //   bottom: BorderSide(width: 0.5),
                                      // ),
                                      ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "${widget.data[index].nombreCategoria}",
                                        style: const TextStyle(
                                          fontSize: 16,
                                          // fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.start,
                                      ),
                                      const Text(
                                        "10",
                                        style: TextStyle(
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
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.fromLTRB(0, 5, 25, 0),
                    child: const Text(
                      "Total: S/.100.00",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.end,
                    ),
                  ),
                  Container(
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
                  GestureDetector(
                    onTap: () async {
                      var height = _interpreter.getInputTensor(0).shape[1];
                      var width = _interpreter.getInputTensor(0).shape[2];
                      print(
                          "Probando comparacion de imagen con el modelo de IA");
                      List<int> imageBytes = await _cameraController
                          .takePicture()
                          .then((XFile image) => image.readAsBytes());

                      //final bytes = await imageFile.readAsBytes();
                      var image = img.decodeImage(imageBytes);

                      // Convertir la imagen en un objeto ByteData
                      var resizedImage =
                          img.copyResize(image!, width: width, height: height);
                      var inputImage = ByteData.view(resizedImage.data.buffer);

                      // Normalizar los valores de píxeles de la imagen
                      // final inputList = Float32List(
                      //     resizedImage.width * resizedImage.height * 3);

                      var inputList = Float32List.view(resizedImage.data.buffer)
                          .map((pixel) => pixel / 255.0)
                          .toList();
                      print(inputList.length);

                      for (int i = 0; i < inputList.length; i++) {
                        inputList[i] = inputImage.getFloat32(i * 4) / 255.0;
                      }

                      // Crear el tensor de entrada con la forma correcta
                      var tensorBuffer = TensorBuffer.createFixedSize(
                          [1, height, width, 1], TfLiteType.float32);

                      // print(inputList.length);
                      // print(resizedImage.height);
                      // print("");
                      // print(resizedImage.width);
                      // print("");
                      // print(_interpreter.getInputTensor(0).shape[1]);
                      // print("");
                      // print(_interpreter.getInputTensor(0).shape[2]);

                      // Copiar los valores normalizados de píxeles en el tensor de entrada
                      tensorBuffer
                          .loadList(inputList, shape: [1, height, width, 1]);

                      // var image = img.decodeImage(imageBytes);
                      // final imageResize =
                      //     img.copyResize(image!, width: 224, height: 224);
                      // final inputImage = ByteData.view(imageResize.data.buffer);

                      // final inputList = Float32List(
                      //     imageResize.width * imageResize.height * 3);
                      // for (int i = 0; i < inputList.length; i++) {
                      //   inputList[i] = inputImage.getFloat32(i * 4) / 255.0;
                      // }

                      // final tensorBuffer = TensorBuffer.createFixedSize(
                      //     [1, 224, 224, 3], TfLiteType.float32);

                      // tensorBuffer.loadList(inputList, shape: [1, 224, 224, 3]);

                      final outputShape = _interpreter.getOutputTensor(0).shape;

                      final outputData =
                          List.filled(outputShape.reduce((a, b) => a * b), 0)
                              .reshape(outputShape);

                      _interpreter.run(tensorBuffer, outputData);
                      // _interpreter.run([tensorBuffer.buffer]);
                      print(_interpreter.getInputTensor(0).shape.length);
                      print(tensorBuffer.shape.length);
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
            ));

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
      appBar: AppBar(
        title: const Text("Pedido de productos"),
        backgroundColor: Colors.green.shade900,
      ),
      drawer: AppMenuDrawer(),
      body: body,
      // body: Container(
      //   width: MediaQuery.of(context).size.width,
      //   padding: const EdgeInsets.only(top: 50),
      //   child: CameraPreview(_cameraController),
      // ),
    );
  }

  Future inicializarCamara() async {
    _widgetState = WidgetState.LOADING;

    if (mounted) {
      setState(
        () {
          // _cameraController.startImageStream(
          //   (image) => {
          //     if (true)
          //       {
          //         cameraImage = image,
          //         //applymodelonimages(),
          //       }
          //   },
          // );
        },
      );
    }

    _camaras = await availableCameras();
    _cameraController =
        new CameraController(_camaras[0], ResolutionPreset.medium);

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

  loadModel() async {
    print('Interpreter loaded successfully');
    _interpreter = await Interpreter.fromAsset('model.tflite');
    print('Interpreter loaded successfully');
    //_inputShape = _interpreter.getInputTensor(0).shape;
    // preProcessInputData();
    // _inputDataType = _interpreter.getInputTensor(0).data;
    // _outputShape = _interpreter.getOutputTensor(0).shape;
    // _outputDataType = _interpreter.getOutputTensor(0).dataType;
  }

  List<double> imageToByteListFloat32(
      img.Image image, int width, int height, int numChannels,
      {List<double>? mean, List<double>? std}) {
    var convertedBytes = Float32List(width * height * numChannels);
    var buffer = Float32List.view(convertedBytes.buffer);

    var imageChannels = image.channels;

    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        var pixel = image.getPixel(x, y);

        for (int c = 0; c < numChannels; c++) {
          if (imageChannels == 1) {
            var val = (img.getRed(pixel) - (mean != null ? mean[c] : 0.0)) /
                (std != null ? std[c] : 1.0);
            buffer[numChannels * (y * width + x) + c] = val;
          } else {
            var val = (img.getRed(pixel) - (mean != null ? mean[c] : 0.0)) /
                (std != null ? std[c] : 1.0);
            buffer[numChannels * (y * width + x) + c] = val;
          }
        }
      }
    }

    return convertedBytes;
  }

  applymodelonimages() async {
    // if (cameraImage != null) {
    //   cameraImage.readAsBytes();
    //   final inputData = preProcessInputData(cameraImage, _inputShape);
    // var predictions = await Tflite.runModelOnFrame(
    //     bytesList: cameraImage!.planes.map(
    //       (plane) {
    //         return plane.bytes;
    //       },
    //     ).toList(),
    //     imageHeight: cameraImage!.height,
    //     imageWidth: cameraImage!.width,
    //     imageMean: 127.5,
    //     imageStd: 127.5,
    //     rotation: 90,
    //     numResults: 3,
    //     threshold: 0.1,
    //     asynch: true);

    // answer = '';

    //   predictions!.forEach(
    //     (prediction) {
    //       answer +=
    //           prediction['label'].toString().substring(0, 1).toUpperCase() +
    //               prediction['label'].toString().substring(1) +
    //               " " +
    //               (prediction['confidence'] as double).toStringAsFixed(3) +
    //               '\n';
    //     },
    //   );

    //   setState(
    //     () {
    //       answer = answer;
    //     },
    //   );
    // }
  }
}
