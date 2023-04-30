import 'package:mysql1/mysql1.dart';
import 'package:app_jugueria/modelos/clienteModel.dart';
import 'package:app_jugueria/controladores/conexion.dart';

class ClienteController {
  Future<List<ClienteModel>> getClientes() async {
    final conn = await MySqlConnection.connect(Configuracion.instancia);
    final result = await conn.query('select * from cliente;');

    final clientes =
        result.map((result) => ClienteModel.fromJson(result.fields)).toList();
    return clientes;
  }

  Future<void> addCliente(
      String nombre, String apellido, String telefono, String email) async {
    final conn = await MySqlConnection.connect(Configuracion.instancia);
    final result = await conn.query(
        'insert into cliente (nombrecliente, apellidoCliente, telefonoCliente, emailCliente) values (?,?,?,?)',
        [nombre, apellido, telefono, email]);
    print("Nuevo cliente id: ${result.insertId}");
  }
}
