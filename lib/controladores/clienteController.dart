import 'package:mysql1/mysql1.dart';
import 'package:app_jugueria/modelos/clienteModel.dart';
import 'package:app_jugueria/modelos/usuarioModel.dart';
import 'package:app_jugueria/modelos/tipoDocumentoModel.dart';
import 'package:app_jugueria/controladores/conexion.dart';

class ClienteController {
  Future<List<ClienteModel>> getClientes() async {
    final conn = await MySqlConnection.connect(Configuracion.instancia);
    final result = await conn.query(
        'select c.id ,c.idTipoDocumento,c.numeroDocumento,c.idUsuario,c.nombreCliente,c.apellidoCliente,c.telefonoCliente,c.emailCliente, c.estadoCliente, u.nombreUsuario,u.contraseniaUsuario from cliente c inner join usuario u on c.idUsuario = u.id where c.estadoCliente = true;');

    final clientes =
        result.map((result) => ClienteModel.fromJson(result.fields)).toList();
    return clientes;
  }

  Future<List<ClienteModel>> validarLogin(UsuarioModel usuario) async {
    final conn = await MySqlConnection.connect(Configuracion.instancia);
    final result = await conn.query(
        'select c.id ,c.idTipoDocumento,c.numeroDocumento,c.idUsuario,c.nombreCliente,c.apellidoCliente,c.telefonoCliente,c.emailCliente, c.estadoCliente, u.nombreUsuario,u.contraseniaUsuario from cliente c inner join usuario u on c.idUsuario = u.id where u.nombreUsuario = ? and u.contraseniaUsuario = ? and c.estadoCliente = true;',
        [usuario.nombreUsuario, usuario.contraseniaUsuario]);

    final respuesta =
        result.map((result) => ClienteModel.fromJson(result.fields)).toList();
    return respuesta;
  }

  Future<ClienteModel> obtenerClientesVarios() async {
    final conn = await MySqlConnection.connect(Configuracion.instancia);
    final result = await conn.query(
      'select c.id ,c.idTipoDocumento,c.numeroDocumento,c.idUsuario,c.nombreCliente,c.apellidoCliente,c.telefonoCliente,c.emailCliente, c.estadoCliente, u.nombreUsuario,u.contraseniaUsuario from cliente c inner join usuario u on c.idUsuario = u.id where nombreCliente = "Clientes varios";',
    );

    final respuesta =
        result.map((result) => ClienteModel.fromJson(result.fields)).toList();
    return respuesta[0];
  }

  Future<List<TipoDocumentoModel>> getTipoDocumentos() async {
    final conn = await MySqlConnection.connect(Configuracion.instancia);
    final result = await conn.query('select * from tipodocumento;');

    final tipodocumentos = result
        .map((result) => TipoDocumentoModel.fromJson(result.fields))
        .toList();
    return tipodocumentos;
  }

  Future<bool> addCliente(ClienteModel cliente) async {
    try {
      final conn = await MySqlConnection.connect(Configuracion.instancia);
      final usuario = await conn.query(
          'insert into usuario (idRol, nombreUsuario, contraseniaUsuario) values (1, ?, ?);',
          [
            cliente.usuario!.nombreUsuario,
            cliente.usuario!.contraseniaUsuario
          ]);

      final usuarioId = usuario.insertId;
      await conn.query(
          'insert into cliente (idUsuario, idTipoDocumento, numeroDocumento,nombrecliente, apellidoCliente, telefonoCliente, emailCliente, estadoCliente) values (?,?,?,?,?,?,?,true)',
          [
            usuarioId,
            cliente.tipoDocumentoModel!.id,
            cliente.numeroDocumento,
            cliente.nombreCliente,
            cliente.apellidoCliente,
            cliente.telefonoCliente,
            cliente.emailCliente
          ]);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> updateCliente(ClienteModel cliente) async {
    final conn = await MySqlConnection.connect(Configuracion.instancia);
    await conn.query(
        'update usuario set nombreUsuario=?, contraseniaUsuario=? where id=?;',
        [
          cliente.usuario!.nombreUsuario,
          cliente.usuario!.contraseniaUsuario,
          cliente.usuario!.id
        ]);

    await conn.query(
        'update cliente set idTipoDocumento=?, numeroDocumento=?, nombreCliente=?, apellidoCliente=?, telefonoCliente=?, emailCliente=? where id=?;',
        [
          cliente.tipoDocumentoModel!.id,
          cliente.numeroDocumento,
          cliente.nombreCliente,
          cliente.apellidoCliente,
          cliente.telefonoCliente,
          cliente.emailCliente,
          cliente.id
        ]);
  }

  Future<void> deleteCliente(int id) async {
    final conn = await MySqlConnection.connect(Configuracion.instancia);
    await conn
        .query('update cliente set estadoCliente = false where id=?;', [id]);
  }
}
