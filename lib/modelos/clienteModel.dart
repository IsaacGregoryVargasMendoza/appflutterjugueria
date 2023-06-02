import 'package:app_jugueria/modelos/tipoDocumentoModel.dart';
import 'package:app_jugueria/modelos/usuarioModel.dart';

class ClienteModel {
  int? id;
  String? numeroDocumento;
  String? nombreCliente;
  String? apellidoCliente;
  String? telefonoCliente;
  String? emailCliente;
  TipoDocumentoModel? tipoDocumentoModel;
  UsuarioModel? usuario;

  ClienteModel(
      {this.id,
      this.numeroDocumento,
      this.nombreCliente,
      this.apellidoCliente,
      this.telefonoCliente,
      this.emailCliente,
      this.tipoDocumentoModel,
      this.usuario});

  factory ClienteModel.fromJson(Map<String, dynamic> json) {
    return ClienteModel(
        id: json['id'] as int,
        numeroDocumento: json['numeroDocumento'] as String,
        nombreCliente: json['nombreCliente'] as String,
        apellidoCliente: json['apellidoCliente'] as String,
        telefonoCliente: json['telefonoCliente'] as String,
        emailCliente: json['emailCliente'] as String,
        tipoDocumentoModel:
            TipoDocumentoModel(id: json['idTipoDocumento'] as int),
        usuario: UsuarioModel(
            id: json['idUsuario'] as int,
            nombreUsuario: json['nombreUsuario'] as String,
            contraseniaUsuario: json['contraseniaUsuario'] as String));
  }
}
