import 'package:app_jugueria/modelos/tipoDocumentoModel.dart';
import 'package:mysql1/mysql1.dart';

class UsuarioModel {
  int? id;
  String? nombreUsuario;
  String? contraseniaUsuario;

  UsuarioModel({this.id, this.nombreUsuario, this.contraseniaUsuario});

  factory UsuarioModel.fromJson(Map<String, dynamic> json) {
    return UsuarioModel(
        id: json['id'] as int,
        nombreUsuario: json['nombreUsuario'] as String,
        contraseniaUsuario: json['contraseniaUsuario'] as String);
  }
}
