import 'package:mysql1/mysql1.dart';
import 'package:app_jugueria/modelos/administradorModel.dart';
import 'package:app_jugueria/modelos/usuarioModel.dart';
import 'package:app_jugueria/controladores/conexion.dart';

class AdministradorController {
  Future<List<AdministradorModel>> getAdministradores() async {
    final conn = await MySqlConnection.connect(Configuracion.instancia);
    final result = await conn.query(
        'select * from administrador a inner join usuario u on a.idUsuario = u.id where a.estadoAdministrador=true;');

    final administradores = result
        .map((result) => AdministradorModel.fromJson(result.fields))
        .toList();
    return administradores;
  }

  Future<List<AdministradorModel>> validarLogin(UsuarioModel usuario) async {
    final conn = await MySqlConnection.connect(Configuracion.instancia);
    final result = await conn.query(
        'select * from administrador a inner join usuario u on a.idUsuario = u.id where u.nombreUsuario = ? and u.contraseniaUsuario = ? and a.estadoAdministrador = true;',
        [usuario.nombreUsuario, usuario.contraseniaUsuario]);

    final respuesta = result
        .map((result) => AdministradorModel.fromJson(result.fields))
        .toList();
    return respuesta;
  }

  Future<void> addAdministrador(AdministradorModel administrador) async {
    final conn = await MySqlConnection.connect(Configuracion.instancia);
    final usuario = await conn.query(
        'insert into usuario (idRol, nombreUsuario, contraseniaUsuario) values (2, ?, ?);',
        [
          administrador.usuario!.nombreUsuario,
          administrador.usuario!.contraseniaUsuario
        ]);

    final usuarioId = usuario.insertId;
    await conn.query(
        'insert into administrador (idUsuario ,idTipoDocumento, numeroDocumento, nombreAdministrador, apellidoAdministrador, telefonoAdministrador, emailAdministrador, estadoAdministrador) values (?, ?, ?, ?, ?, ?, ?, true);',
        [
          usuarioId,
          administrador.tipoDocumentoModel!.id,
          administrador.numeroDocumento,
          administrador.nombreAdministrador,
          administrador.apellidoAdministrador,
          administrador.telefonoAdministrador,
          administrador.emailAdministrador
        ]);
  }

  Future<void> updateAdministrador(AdministradorModel administrador) async {
    final conn = await MySqlConnection.connect(Configuracion.instancia);
    await conn.query(
        'update usuario set nombreUsuario=?, contrasenia=? where id=?;', [
      administrador.usuario!.nombreUsuario,
      administrador.usuario!.contraseniaUsuario,
      administrador.usuario!.id
    ]);

    await conn.query(
        'update administrador set idTipoDocumento=?, numeroDocumento=?, nombreAdministrador=?, apellidoAdministrador=?, telefonoAdministrador=?, emailAdministrador=? where id=?;',
        [
          administrador.tipoDocumentoModel!.id,
          administrador.numeroDocumento,
          administrador.nombreAdministrador,
          administrador.apellidoAdministrador,
          administrador.telefonoAdministrador,
          administrador.emailAdministrador,
          administrador.id
        ]);
  }

  Future<void> deleteAdministrador(int id) async {
    final conn = await MySqlConnection.connect(Configuracion.instancia);
    await conn.query(
        'update administrador set estadoAdministrador=false where id=?', [id]);
  }
}
