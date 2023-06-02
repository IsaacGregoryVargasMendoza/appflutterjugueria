import 'package:mysql1/mysql1.dart';
import 'package:app_jugueria/modelos/adicionalModel.dart';
import 'package:app_jugueria/controladores/conexion.dart';

class AdicionalController {
  Future<List<AdicionalModel>> getAdicionales() async {
    final conn = await MySqlConnection.connect(Configuracion.instancia);
    final result = await conn
        .query('select * from adicional where estadoAdicional = true;');

    final adicionales =
        result.map((result) => AdicionalModel.fromJson(result.fields)).toList();
    return adicionales;
  }

  Future<void> addAdicional(AdicionalModel adicional) async {
    final conn = await MySqlConnection.connect(Configuracion.instancia);
    await conn.query(
        'insert into adicional (nombreAdicional, letraAdicional, visibleAdicional, estadoAdicional) values (?,?,?,true)',
        [
          adicional.nombreAdicional,
          adicional.letraAdicional,
          adicional.visibleAdicional
        ]);
  }

  Future<void> addCategoriaAdicional(
      List<CategoriaAdicionalModel> lista) async {
    final conn = await MySqlConnection.connect(Configuracion.instancia);

    for (CategoriaAdicionalModel categoriaAdicional in lista) {
      await conn.query(
          'insert into detalleAdicional (idCategoria, idAdicional, estaActivo) values (?,?,true)',
          [categoriaAdicional.idCategoria, categoriaAdicional.idAdicional]);
    }
  }

  Future<void> deleteCategoriaAdicional(int idCategoria) async {
    final conn = await MySqlConnection.connect(Configuracion.instancia);

    await conn.query(
        'delete from detalleAdicional WHERE idCategoria = ?;', [idCategoria]);
  }

  Future<List<AdicionalModel>> getAdicionalesPorCategoria(
      int idCategoria) async {
    final conn = await MySqlConnection.connect(Configuracion.instancia);
    final result = await conn.query(
        'select a.id, a.nombreAdicional, a.letraAdicional, a.visibleAdicional, a.estadoAdicional  from detalleAdicional d inner join adicional a on d.idAdicional =a.id  where d.idCategoria = ?;',
        [idCategoria]);

    final adicionales =
        result.map((result) => AdicionalModel.fromJson(result.fields)).toList();
    return adicionales;
  }

  Future<List<AdicionalModel>> getAdicionalWithLetter(String letra) async {
    final conn = await MySqlConnection.connect(Configuracion.instancia);
    final result = await conn.query(
        'select * from adicional where estadoAdicional = true and visibleAdicional = true and letraAdicional = ?;',
        [letra]);

    final adicional =
        result.map((result) => AdicionalModel.fromJson(result.fields)).toList();
    return adicional;
  }

  Future<void> updateAdicional(AdicionalModel adicional) async {
    final conn = await MySqlConnection.connect(Configuracion.instancia);
    await conn.query(
        'update adicional set nombreAdicional=?, letraAdicional=?, visibleAdicional=? where id=?;',
        [
          adicional.nombreAdicional,
          adicional.letraAdicional,
          adicional.visibleAdicional,
          adicional.id
        ]);
  }

  Future<void> hiddenAdicional(int id) async {
    final conn = await MySqlConnection.connect(Configuracion.instancia);
    await conn.query(
        'update adicional set visibleAdicional = false where id=?', [id]);
  }

  Future<void> showAdicional(int id) async {
    final conn = await MySqlConnection.connect(Configuracion.instancia);
    await conn
        .query('update adicional set visibleAdicional = true where id=?', [id]);
  }
}
