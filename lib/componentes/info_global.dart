import 'package:app_jugueria/modelos/administradorModel.dart';
import 'package:app_jugueria/modelos/clienteModel.dart';
import 'package:app_jugueria/modelos/mesaModel.dart';
import 'package:flutter/material.dart';

class InfoGlobal {
  static AdministradorModel? administradorModel;
  static ClienteModel? clienteModel;
  static MesaModel? mesaModel;
  static int openNavigatorCount = 1;

  static void incrementarVentanas() {
    openNavigatorCount = openNavigatorCount + 1;
  }

  static void decrementarVentanas() {
    openNavigatorCount = openNavigatorCount - 1;
  }

  static void mostrarAlerta(
      BuildContext context, String cabecera, String mensaje) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(cabecera),
          content: Text(mensaje),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  static void mensajeConfirmacion(BuildContext context, String mensaje,
      {int? duracion}) {
    var snackBar = SnackBar(
      duration: Duration(seconds: (duracion == null) ? 7 : duracion),
      backgroundColor: Colors.green,
      content: Text(mensaje),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static void mensajeFallo(BuildContext context, String mensaje, int duracion) {
    var snackBar = SnackBar(
      duration: Duration(seconds: duracion),
      backgroundColor: Colors.red,
      content: Text(mensaje),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
