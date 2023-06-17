import 'package:app_jugueria/componentes/info_global.dart';
import 'package:app_jugueria/controladores/pedidoController.dart';
import 'package:app_jugueria/componentes/app_drawer.dart';
import 'package:app_jugueria/modelos/adicionalModel.dart';
import 'package:app_jugueria/modelos/pedidoModel.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:collection/collection.dart';
//import 'package:flutter_charts/flutter_charts.dart' as;
import 'package:fl_chart/fl_chart.dart';

class AppDashboardPedido extends StatefulWidget {
  AppDashboardPedido({Key? key}) : super(key: key);
  @override
  State<AppDashboardPedido> createState() {
    return AppDashboardPedidoState();
  }
}

class AppDashboardPedidoState extends State<AppDashboardPedido> {
  List<PieChartSectionData> sectionsChart = [];
  List<PedidoModel>? listaPedidos = [];
  List<GraficoLineal>? listaGrafico = [];
  List<String>? listaReportes = [
    "Ventas totales",
    "Ventas por comprobante",
    "Ventas por categoria",
    "Producto mas vendido"
  ];
  late Map<String?, List<PedidoModel>> objetosAgrupadosGlobal;
  late List<Map<String?, List<PedidoModel>>> listaObjetosAgrupadosGlobal = [];
  double _maxX = 0;
  double _maxY = 0;

  int filtro = 0;
  int idInicioMes = 0;
  int idFinMes = 11;

  List<FlSpot>? dataTotales = [];
  List<List<FlSpot>>? listaDataTotales = [];

  final List<String> anios = ['2019', '2020', '2021', '2022', '2023'];

  final List<String> meses = [
    'Ene',
    'Feb',
    'Mar',
    'Abr',
    'May',
    'Jun',
    'Jul',
    'Ago',
    'Sep',
    'Oct',
    'Nov',
    'Dic'
  ];

  Future<void> cargarPedidos() async {
    PedidoController pedidoController = PedidoController();
    var lista = await pedidoController.getPedidos();

    listaPedidos = lista;

    cargarDatosPastel();
    cargarDatosGrafico();
  }

  @override
  void dispose() {
    super.dispose();
    InfoGlobal.decrementarVentanas();
  }

  void cargarDatosGrafico() {
    PedidoController pedidoController = PedidoController();
    var lista = pedidoController.formatearFechas(listaPedidos!);

    for (var i = 0; i < lista.length; i++) {
      debugPrint(lista[i].fechaPedido);
    }

    var objetosAgrupados = groupBy(lista, (pedido) => pedido.fechaPedido);

    objetosAgrupadosGlobal = objetosAgrupados;
    llenarDatosGrafico();
  }

  void llenarDatosGraficoPorComprobante() {
    dataTotales = [];
    listaGrafico = [];
    listaDataTotales = [];

    for (var i = idInicioMes; i <= idFinMes; i++) {
      GraficoLineal valor =
          GraficoLineal(fecha: meses[i], cantidad: meses.length.toDouble());
      listaGrafico!.add(valor);
    }

    for (var l = 0; l < listaObjetosAgrupadosGlobal.length; l++) {
      var objetosAgrupados = listaObjetosAgrupadosGlobal[l];
      int contador = 0;

      List<FlSpot> dataTotal = [];

      for (var i = idInicioMes; i <= idFinMes; i++) {
        double total = 0;

        switch (meses[i]) {
          case "Ene":
            var listas = objetosAgrupados.entries
                .where((entry) => entry.key == "01/2023")
                .map((entry) => entry.value)
                .toList();

            if (listas.isNotEmpty) {
              var objetos = listas.first;
              for (var j = 0; j < objetos.length; j++) {
                total = total + objetos[j].totalPedido!;
              }
            }

            break;
          case "Feb":
            var listas = objetosAgrupados.entries
                .where((entry) => entry.key == "02/2023")
                .map((entry) => entry.value)
                .toList();

            if (listas.isNotEmpty) {
              var objetos = listas.first;
              for (var j = 0; j < objetos.length; j++) {
                total = total + objetos[j].totalPedido!;
              }
            }
            break;
          case "Mar":
            var listas = objetosAgrupados.entries
                .where((entry) => entry.key == "03/2023")
                .map((entry) => entry.value)
                .toList();

            if (listas.isNotEmpty) {
              var objetos = listas.first;
              for (var j = 0; j < objetos.length; j++) {
                total = total + objetos[j].totalPedido!;
              }
            }
            break;
          case "Abr":
            var listas = objetosAgrupados.entries
                .where((entry) => entry.key == "04/2023")
                .map((entry) => entry.value)
                .toList();

            if (listas.isNotEmpty) {
              var objetos = listas.first;
              for (var j = 0; j < objetos.length; j++) {
                total = total + objetos[j].totalPedido!;
              }
            }
            break;
          case "May":
            var listas = objetosAgrupados.entries
                .where((entry) => entry.key == "05/2023")
                .map((entry) => entry.value)
                .toList();

            if (listas.isNotEmpty) {
              var objetos = listas.first;
              for (var j = 0; j < objetos.length; j++) {
                total = total + objetos[j].totalPedido!;
              }
            }
            break;
          case "Jun":
            var listas = objetosAgrupados.entries
                .where((entry) => entry.key == "06/2023")
                .map((entry) => entry.value)
                .toList();

            if (listas.isNotEmpty) {
              var objetos = listas.first;
              for (var j = 0; j < objetos.length; j++) {
                total = total + objetos[j].totalPedido!;
              }
            }
            break;
          case "Jul":
            var listas = objetosAgrupados.entries
                .where((entry) => entry.key == "07/2023")
                .map((entry) => entry.value)
                .toList();

            if (listas.isNotEmpty) {
              var objetos = listas.first;
              for (var j = 0; j < objetos.length; j++) {
                total = total + objetos[j].totalPedido!;
              }
            }
            break;
          case "Ago":
            var listas = objetosAgrupados.entries
                .where((entry) => entry.key == "08/2023")
                .map((entry) => entry.value)
                .toList();

            if (listas.isNotEmpty) {
              var objetos = listas.first;
              for (var j = 0; j < objetos.length; j++) {
                total = total + objetos[j].totalPedido!;
              }
            }
            break;
          case "Sep":
            var listas = objetosAgrupados.entries
                .where((entry) => entry.key == "09/2023")
                .map((entry) => entry.value)
                .toList();

            if (listas.isNotEmpty) {
              var objetos = listas.first;
              for (var j = 0; j < objetos.length; j++) {
                total = total + objetos[j].totalPedido!;
              }
            }
            break;
          case "Oct":
            var listas = objetosAgrupados.entries
                .where((entry) => entry.key == "10/2023")
                .map((entry) => entry.value)
                .toList();

            if (listas.isNotEmpty) {
              var objetos = listas.first;
              for (var j = 0; j < objetos.length; j++) {
                total = total + objetos[j].totalPedido!;
              }
            }
            break;
          case "Nov":
            var listas = objetosAgrupados.entries
                .where((entry) => entry.key == "11/2023")
                .map((entry) => entry.value)
                .toList();

            if (listas.isNotEmpty) {
              var objetos = listas.first;
              for (var j = 0; j < objetos.length; j++) {
                total = total + objetos[j].totalPedido!;
              }
            }
            break;
          case "Dic":
            var listas = objetosAgrupados.entries
                .where((entry) => entry.key == "12/2023")
                .map((entry) => entry.value)
                .toList();

            if (listas.isNotEmpty) {
              var objetos = listas.first;
              for (var j = 0; j < objetos.length; j++) {
                total = total + objetos[j].totalPedido!;
              }
            }
            break;
        }

        dataTotal.add(FlSpot(contador.toDouble(), total));

        contador++;

        if (_maxY < total) {
          _maxY = total;
        }
      }

      listaDataTotales!.add(dataTotal);
    }

    setState(() {
      _maxX = idFinMes.toDouble() - idInicioMes.toDouble();
    });
  }

  void llenarDatosGrafico() {
    dataTotales = [];
    listaGrafico = [];

    int contador = 0;

    for (var i = idInicioMes; i <= idFinMes; i++) {
      GraficoLineal valor =
          GraficoLineal(fecha: meses[i], cantidad: meses.length.toDouble());

      double total = 0;

      switch (meses[i]) {
        case "Ene":
          var listas = objetosAgrupadosGlobal.entries
              .where((entry) => entry.key == "01/2023")
              .map((entry) => entry.value)
              .toList();

          if (listas.isNotEmpty) {
            var objetos = listas.first;
            for (var j = 0; j < objetos.length; j++) {
              total = total + objetos[j].totalPedido!;
            }
          }

          break;
        case "Feb":
          var listas = objetosAgrupadosGlobal.entries
              .where((entry) => entry.key == "02/2023")
              .map((entry) => entry.value)
              .toList();

          if (listas.isNotEmpty) {
            var objetos = listas.first;
            for (var j = 0; j < objetos.length; j++) {
              total = total + objetos[j].totalPedido!;
            }
          }
          break;
        case "Mar":
          var listas = objetosAgrupadosGlobal.entries
              .where((entry) => entry.key == "03/2023")
              .map((entry) => entry.value)
              .toList();

          if (listas.isNotEmpty) {
            var objetos = listas.first;
            for (var j = 0; j < objetos.length; j++) {
              total = total + objetos[j].totalPedido!;
            }
          }
          break;
        case "Abr":
          var listas = objetosAgrupadosGlobal.entries
              .where((entry) => entry.key == "04/2023")
              .map((entry) => entry.value)
              .toList();

          if (listas.isNotEmpty) {
            var objetos = listas.first;
            for (var j = 0; j < objetos.length; j++) {
              total = total + objetos[j].totalPedido!;
            }
          }
          break;
        case "May":
          var listas = objetosAgrupadosGlobal.entries
              .where((entry) => entry.key == "05/2023")
              .map((entry) => entry.value)
              .toList();

          if (listas.isNotEmpty) {
            var objetos = listas.first;
            for (var j = 0; j < objetos.length; j++) {
              total = total + objetos[j].totalPedido!;
            }
          }
          break;
        case "Jun":
          var listas = objetosAgrupadosGlobal.entries
              .where((entry) => entry.key == "06/2023")
              .map((entry) => entry.value)
              .toList();

          if (listas.isNotEmpty) {
            var objetos = listas.first;
            for (var j = 0; j < objetos.length; j++) {
              total = total + objetos[j].totalPedido!;
            }
          }
          break;
        case "Jul":
          var listas = objetosAgrupadosGlobal.entries
              .where((entry) => entry.key == "07/2023")
              .map((entry) => entry.value)
              .toList();

          if (listas.isNotEmpty) {
            var objetos = listas.first;
            for (var j = 0; j < objetos.length; j++) {
              total = total + objetos[j].totalPedido!;
            }
          }
          break;
        case "Ago":
          var listas = objetosAgrupadosGlobal.entries
              .where((entry) => entry.key == "08/2023")
              .map((entry) => entry.value)
              .toList();

          if (listas.isNotEmpty) {
            var objetos = listas.first;
            for (var j = 0; j < objetos.length; j++) {
              total = total + objetos[j].totalPedido!;
            }
          }
          break;
        case "Sep":
          var listas = objetosAgrupadosGlobal.entries
              .where((entry) => entry.key == "09/2023")
              .map((entry) => entry.value)
              .toList();

          if (listas.isNotEmpty) {
            var objetos = listas.first;
            for (var j = 0; j < objetos.length; j++) {
              total = total + objetos[j].totalPedido!;
            }
          }
          break;
        case "Oct":
          var listas = objetosAgrupadosGlobal.entries
              .where((entry) => entry.key == "10/2023")
              .map((entry) => entry.value)
              .toList();

          if (listas.isNotEmpty) {
            var objetos = listas.first;
            for (var j = 0; j < objetos.length; j++) {
              total = total + objetos[j].totalPedido!;
            }
          }
          break;
        case "Nov":
          var listas = objetosAgrupadosGlobal.entries
              .where((entry) => entry.key == "11/2023")
              .map((entry) => entry.value)
              .toList();

          if (listas.isNotEmpty) {
            var objetos = listas.first;
            for (var j = 0; j < objetos.length; j++) {
              total = total + objetos[j].totalPedido!;
            }
          }
          break;
        case "Dic":
          var listas = objetosAgrupadosGlobal.entries
              .where((entry) => entry.key == "12/2023")
              .map((entry) => entry.value)
              .toList();

          if (listas.isNotEmpty) {
            var objetos = listas.first;
            for (var j = 0; j < objetos.length; j++) {
              total = total + objetos[j].totalPedido!;
            }
          }
          break;
      }

      dataTotales!.add(FlSpot(contador.toDouble(), total));

      contador++;

      listaGrafico!.add(valor);
      if (_maxY < total) {
        _maxY = total;
      }
    }

    setState(() {
      _maxX = idFinMes.toDouble() - idInicioMes.toDouble();
    });
  }

  void cargarDatosGraficoPorComprobante() {
    PedidoController pedidoController = PedidoController();
    var listaPorComprobante =
        pedidoController.listaPorComprobante(listaPedidos!);

    for (var a = 0; a < listaPorComprobante.length; a++) {
      var lista = pedidoController.formatearFechas(listaPorComprobante[a]!);
      var objetosAgrupados = groupBy(lista, (pedido) => pedido.fechaPedido);

      listaObjetosAgrupadosGlobal.add(objetosAgrupados);
    }

    llenarDatosGraficoPorComprobante();
  }

  void cargarDatosPastel() {
    var tickets = listaPedidos!
        .where((element) => element.comprobante!.nombreComprobante! == "TICKET")
        .toList();
    var boletas = listaPedidos!
        .where((element) => element.comprobante!.nombreComprobante! == "BOLETA")
        .toList();
    var facturas = listaPedidos!
        .where(
            (element) => element.comprobante!.nombreComprobante! == "FACTURA")
        .toList();

    var ticketsPastel = PieChartSectionData(
      value: tickets.length.toDouble(),
      title: "${tickets.length.toDouble()}%",
      showTitle: true,
      color: Colors.orange,
      radius: 100,
    );
    var boletasPastel = PieChartSectionData(
      value: boletas.length.toDouble(),
      title: "${boletas.length.toDouble()}%",
      showTitle: true,
      color: Colors.blue,
      radius: 100,
    );
    var facturasPastel = PieChartSectionData(
      value: facturas.length.toDouble(),
      title: "${facturas.length.toDouble()}%",
      showTitle: true,
      color: Colors.red,
      radius: 100,
    );

    setState(() {
      sectionsChart.add(ticketsPastel);
      sectionsChart.add(boletasPastel);
      sectionsChart.add(facturasPastel);
    });
  }

  @override
  void initState() {
    //cargarDatosPastel();
    super.initState();

    cargarPedidos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Dashboard ventas"),
        backgroundColor: Colors.green.shade900,
      ),
      drawer: AppMenuDrawer(),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: ListView(
          children: [
            Container(
              //color: Colors.blue,
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.fromLTRB(15, 15, 10, 15),
              child: Text(
                "Bienvenido ${InfoGlobal.administradorModel!.nombreAdministrador}",
                style: const TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 20.0,
                    color: Colors.black,
                    decoration: TextDecoration.none,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(20, 0, 50, 0),
                    child: Text(
                      "Año",
                      style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 16,
                          color: Colors.black,
                          decoration: TextDecoration.none,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(50, 0, 50, 0),
                    child: DropdownButtonFormField(
                      decoration:
                          const InputDecoration(border: InputBorder.none),
                      value: 4,
                      // enableFeedback: false,
                      onChanged: null,
                      borderRadius: BorderRadius.circular(15),
                      items: anios.map((anio) {
                        return DropdownMenuItem(
                            child: Text(anio), value: anios.indexOf(anio));
                      }).toList(),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(20, 0, 50, 0),
                    child: Text(
                      "Filtro",
                      style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 16,
                          color: Colors.black,
                          decoration: TextDecoration.none,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(50, 0, 50, 0),
                    child: DropdownButtonFormField(
                        decoration:
                            const InputDecoration(border: InputBorder.none),
                        value: 0,
                        borderRadius: BorderRadius.circular(15),
                        items: listaReportes!.map((reporte) {
                          return DropdownMenuItem(
                              child: Text(reporte),
                              value: listaReportes!.indexOf(reporte));
                        }).toList(),
                        onChanged: (value) async {
                          print(value);
                          // setState(() {
                          filtro = value!;
                          // });
                          if (filtro == 0) {
                            cargarDatosGrafico();
                          } else if (filtro == 1) {
                            cargarDatosGraficoPorComprobante();
                          } else {}
                        }),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(20, 0, 5, 0),
                        child: Column(
                          children: [
                            const Text(
                              "Desde",
                              style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 16,
                                  color: Colors.black,
                                  decoration: TextDecoration.none,
                                  fontWeight: FontWeight.bold),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width / 2 - 50,
                              child: DropdownButtonFormField(
                                  decoration: const InputDecoration(
                                      border: InputBorder.none),
                                  value: 0,
                                  borderRadius: BorderRadius.circular(15),
                                  items: meses.map((mes) {
                                    return DropdownMenuItem(
                                        child: Text(mes),
                                        value: meses!.indexOf(mes));
                                  }).toList(),
                                  onChanged: (value) async {
                                    idInicioMes = value!;
                                    int diferencia = idFinMes - idInicioMes;
                                    if (diferencia > 0) {
                                      if (filtro == 0) {
                                        llenarDatosGrafico();
                                      } else if (filtro == 1) {
                                        llenarDatosGraficoPorComprobante();
                                      } else {}
                                      // llenarDatosGrafico();
                                    } else {
                                      InfoGlobal.mensajeFallo(context,
                                          "Debe seleccionar un rango de fechas valido.");
                                    }
                                  }),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(5, 0, 20, 0),
                        child: Column(
                          children: [
                            const Text(
                              "Hasta",
                              style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 16,
                                  color: Colors.black,
                                  decoration: TextDecoration.none,
                                  fontWeight: FontWeight.bold),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width / 2 - 50,
                              child: DropdownButtonFormField(
                                  decoration: const InputDecoration(
                                      border: InputBorder.none),
                                  value: 11,
                                  borderRadius: BorderRadius.circular(15),
                                  items: meses.map((mes) {
                                    return DropdownMenuItem(
                                        child: Text(mes),
                                        value: meses!.indexOf(mes));
                                  }).toList(),
                                  onChanged: (value) async {
                                    idFinMes = value!;
                                    int diferencia = idFinMes - idInicioMes;
                                    if (diferencia > 0) {
                                      if (filtro == 0) {
                                        llenarDatosGrafico();
                                      } else if (filtro == 1) {
                                        llenarDatosGraficoPorComprobante();
                                      } else {}
                                    } else {
                                      InfoGlobal.mensajeFallo(context,
                                          "Debe seleccionar un rango de fechas valido.");
                                    }
                                  }),
                            )
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),

            // (data!.isNotEmpty)
            //     ? Container(
            //         height: 300,
            //         padding: EdgeInsets.fromLTRB(10, 20, 10, 5),
            //         margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
            //         width: MediaQuery.of(context).size.width - 25,
            //         decoration: BoxDecoration(
            //             color: Color.fromRGBO(30, 2, 90, 1),
            //             borderRadius:
            //                 BorderRadius.all(Radius.circular(10))),
            //         child: LineChart(
            //           LineChartData(
            //             //backgroundColor: Colors.amber,
            //             lineBarsData: [
            //               // LineChartBarData(
            //               //   spots: data,
            //               //   isCurved: false,
            //               //   color: Colors.blue,
            //               //   //colors: [Colors.blue],
            //               //   barWidth: 4,
            //               // ),
            //               LineChartBarData(
            //                 spots: dataTotales,
            //                 isCurved: false,
            //                 color: Colors.orange,
            //                 //colors: [Colors.blue],
            //                 barWidth: 4,
            //               ),
            //             ],
            //             minX: 0,
            //             maxX: _maxX,
            //             minY: 0,
            //             maxY: _maxY + 10,
            //             titlesData: FlTitlesData(
            //               show: true,
            //               bottomTitles: AxisTitles(
            //                 sideTitles: SideTitles(
            //                   //interval: 10,
            //                   showTitles: true,
            //                   reservedSize: 100,
            //                   getTitlesWidget: (value, meta) {
            //                     //print(value);
            //                     final int index = value.toInt();
            //                     if (index >= 0 &&
            //                         index < listaGrafico!.length) {
            //                       return Container(
            //                           padding:
            //                               EdgeInsets.fromLTRB(0, 60, 0, 0),
            //                           child: Transform(
            //                             transform: Matrix4.rotationZ(315 *
            //                                 0.0174533), // 45 grados en radianes
            //                             child: Text(
            //                               listaGrafico![index].fecha!,
            //                               style: TextStyle(
            //                                   color: Colors.grey,
            //                                   fontWeight: FontWeight.bold),
            //                             ),
            //                           ));
            //                     }
            //                     return Text("");
            //                   },
            //                 ),
            //               ),
            //               topTitles: AxisTitles(
            //                   sideTitles: SideTitles(showTitles: false)),
            //               rightTitles: AxisTitles(
            //                   sideTitles: SideTitles(showTitles: false)),
            //               leftTitles: AxisTitles(
            //                 sideTitles: SideTitles(
            //                   //interval: 10,
            //                   showTitles: true,
            //                   reservedSize: 50,
            //                   getTitlesWidget: (value, meta) {
            //                     return Text(
            //                       value.toString(),
            //                       style: TextStyle(color: Colors.grey),
            //                     );
            //                   },
            //                 ),
            //               ),
            //             ),
            //           ),
            //         ),
            //       )

            // Container(
            //   height: 300,
            //   padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
            //   margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
            //   width: MediaQuery.of(context).size.width - 25,
            //   decoration: const BoxDecoration(
            //       color: Color.fromRGBO(30, 2, 90, 1),
            //       borderRadius: BorderRadius.all(Radius.circular(10))),
            //   child: Column(
            //       mainAxisAlignment: MainAxisAlignment.center,
            //       crossAxisAlignment: CrossAxisAlignment.center,
            //       children: [
            //         CircularProgressIndicator(
            //           color: Colors.amber.shade800,
            //         ),
            //         const Text(
            //           "Cargando datos...",
            //           style: TextStyle(fontSize: 18, color: Colors.white),
            //           textAlign: TextAlign.start,
            //         ),
            //       ]),
            // ),
            graficoLineal(),
            Container(
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              height: 250,
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.fromLTRB(0, 70, 0, 0),
                    height: 150,
                    width: 150,
                    child: PieChart(
                      PieChartData(
                          borderData: FlBorderData(
                            show: false,
                          ),
                          sectionsSpace: 0,
                          centerSpaceRadius: 0,
                          sections: sectionsChart),
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        height: 20,
                        width: 20,
                        color: Colors.blue,
                      ),
                      const Text(
                        " Boletas",
                        style: TextStyle(fontSize: 18, color: Colors.black),
                        textAlign: TextAlign.start,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        height: 20,
                        width: 20,
                        color: Colors.red,
                      ),
                      const Text(
                        " Facturas",
                        style: TextStyle(fontSize: 18, color: Colors.black),
                        textAlign: TextAlign.start,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        height: 20,
                        width: 20,
                        color: Colors.orange,
                      ),
                      const Text(
                        " Tickets",
                        style: TextStyle(fontSize: 18, color: Colors.black),
                        textAlign: TextAlign.start,
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget graficoLineal() {
    return ((filtro == 0 && dataTotales!.isNotEmpty) ||
            (filtro == 1 && listaDataTotales!.isNotEmpty))
        ? Container(
            height: 300,
            padding: EdgeInsets.fromLTRB(10, 20, 30, 5),
            margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
            width: MediaQuery.of(context).size.width - 25,
            decoration: BoxDecoration(
                color: Color.fromRGBO(30, 2, 90, 1),
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: LineChart(
              LineChartData(
                //backgroundColor: Colors.amber,
                lineBarsData: (filtro == 0)
                    ? [
                        LineChartBarData(
                          spots: dataTotales,
                          isCurved: false,
                          color: Colors.green,
                          //colors: [Colors.blue],
                          barWidth: 4,
                        ),
                      ] //
                    : (filtro == 1)
                        ? [
                            LineChartBarData(
                              spots: listaDataTotales![1],
                              isCurved: false,
                              color: Colors.blue,
                              //colors: [Colors.blue],
                              barWidth: 4,
                            ),
                            LineChartBarData(
                              spots: listaDataTotales![2],
                              isCurved: false,
                              color: Colors.red,
                              //colors: [Colors.blue],
                              barWidth: 4,
                            ),
                            LineChartBarData(
                              spots: listaDataTotales![0],
                              isCurved: false,
                              color: Colors.orange,
                              //colors: [Colors.blue],
                              barWidth: 4,
                            )
                          ]
                        : [],
                minX: 0,
                maxX: _maxX,
                minY: 0,
                maxY: _maxY + 10,
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      //interval: 10,
                      showTitles: true,
                      reservedSize: 100,
                      getTitlesWidget: (value, meta) {
                        final int index = value.toInt();

                        if (index >= 0 && index < listaGrafico!.length) {
                          return Container(
                              padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
                              child: Transform(
                                transform: Matrix4.rotationZ(
                                    315 * 0.0174533), // 45 grados en radianes
                                child: Text(
                                  listaGrafico![index].fecha!,
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold),
                                ),
                              ));
                        }
                        return Text("");
                      },
                    ),
                  ),
                  topTitles:
                      AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles:
                      AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      //interval: 10,
                      showTitles: true,
                      reservedSize: 50,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toString(),
                          style: TextStyle(color: Colors.grey),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          )
        : Container(
            height: 300,
            padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
            margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
            width: MediaQuery.of(context).size.width - 25,
            decoration: const BoxDecoration(
                color: Color.fromRGBO(30, 2, 90, 1),
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    color: Colors.amber.shade800,
                  ),
                  const Text(
                    "Cargando datos...",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                    textAlign: TextAlign.start,
                  ),
                ]),
          );
  }

  abrirModalDetalle(List<DetallePedidoModel> lista,
      List<List<AdicionalModel>> listaAdicionales) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height,
          //color: Colors.amber,
          child: Column(
            children: [
              Container(
                height: 60,
                padding: const EdgeInsets.all(10),
                child: Center(
                  child: Text(
                    "Lista de productos",
                    //MediaQuery.of(context).size.height.toString(),
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.green.shade600),
                    textAlign: TextAlign.start,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  //height: MediaQuery.of(context).size.height - 100,
                  //color: Colors.red,
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: ListView.builder(
                    padding: const EdgeInsets.all(10),
                    itemCount: lista.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () async {},
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(0, 0, 10, 10),
                          decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width,
                                child: Text(
                                  "${lista[index].producto!.nombreProducto}",
                                  style: const TextStyle(
                                    fontSize: 18,
                                    //fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.start,
                                ),
                              ),
                              (listaAdicionales[index].isNotEmpty)
                                  ? Detalle(
                                      listaDetalle: listaAdicionales[index])
                                  : const Text(
                                      "- SIN DETALLE",
                                      style: TextStyle(
                                          fontSize: 14,
                                          // fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                      textAlign: TextAlign.start,
                                    ),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                child: Text(
                                  "${lista[index].cantidadDetalle} x ${lista[index].precioDetalle} = ${lista[index].cantidadDetalle! * lista[index].precioDetalle!}",
                                  style: const TextStyle(
                                    fontSize: 18,
                                    //fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.end,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class GraficoLineal {
  String? fecha;
  double? cantidad;

  GraficoLineal({this.fecha, this.cantidad});
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
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "- ${listaDetalle[index].nombreAdicional}",
                style: const TextStyle(fontSize: 14, color: Colors.black),
                textAlign: TextAlign.start,
              ),
            ],
          );
        },
      ),
    );
  }
}
