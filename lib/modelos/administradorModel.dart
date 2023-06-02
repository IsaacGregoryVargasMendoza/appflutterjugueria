import 'package:app_jugueria/modelos/tipoDocumentoModel.dart';
import 'package:app_jugueria/modelos/usuarioModel.dart';
import 'package:mysql1/mysql1.dart';

class AdministradorModel {
  int? id;
  TipoDocumentoModel? tipoDocumentoModel;
  String? numeroDocumento;
  String? nombreAdministrador;
  String? apellidoAdministrador;
  String? telefonoAdministrador;
  String? emailAdministrador;
  UsuarioModel? usuario;

  AdministradorModel(
      {this.id,
      this.tipoDocumentoModel,
      this.numeroDocumento,
      this.nombreAdministrador,
      this.apellidoAdministrador,
      this.telefonoAdministrador,
      this.emailAdministrador,
      this.usuario});

  factory AdministradorModel.fromJson(Map<String, dynamic> json) {
    return AdministradorModel(
        id: json['id'] as int,
        tipoDocumentoModel:
            TipoDocumentoModel(id: json['idTipoDocumento'] as int),
        numeroDocumento: json['numeroDocumento'] as String,
        nombreAdministrador: json['nombreAdministrador'] as String,
        apellidoAdministrador: json['apellidoAdministrador'] as String,
        telefonoAdministrador: json['telefonoAdministrador'] as String,
        emailAdministrador: json['emailAdministrador'] as String,
        usuario: UsuarioModel(
            id: json['idUsuario'] as int,
            nombreUsuario: json['nombreUsuario'] as String,
            contraseniaUsuario: json['contraseniaUsuario'] as String));
  }
}
