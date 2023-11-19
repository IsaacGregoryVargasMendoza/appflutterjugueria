import 'package:mysql1/mysql1.dart';
import 'package:app_jugueria/modelos/manualModel.dart';
import 'package:app_jugueria/controladores/conexion.dart';

class ManualController {
  Future<List<ManualModel>> getManuelAdministradores() async {
    final conn = await MySqlConnection.connect(Configuracion.instancia);
    final result = await conn.query(
        'select * from manual m where m.tipoManual = 1 ORDER BY m.pasoManual');

    final manual =
        result.map((result) => ManualModel.fromJson(result.fields)).toList();
    return manual;
  }

  Future<List<ManualModel>> getManualClientes() async {
    final conn = await MySqlConnection.connect(Configuracion.instancia);
    final result = await conn.query(
        'select * from manual m where m.tipoManual = 0 ORDER BY m.pasoManual');

    final manual =
        result.map((result) => ManualModel.fromJson(result.fields)).toList();
    return manual;
  }

  Future<void> addManual(ManualModel manualModel) async {
    final conn = await MySqlConnection.connect(Configuracion.instancia);
    await conn.query(
        'insert into manual (pasoManual, tipoManual, descripcionManual, imagenManual) values (?,?,?,?)',
        [
          manualModel.pasoManual,
          manualModel.tipoManual,
          manualModel.descripcionManual,
          manualModel.imagenManual
        ]);
  }

  Future<void> updateManual(ManualModel manualModel) async {
    final conn = await MySqlConnection.connect(Configuracion.instancia);
    await conn.query(
        'update manual set pasoManual=?, tipoManual=?, descripcionManual=?, imagenManual=? where id=?;',
        [
          manualModel.pasoManual,
          manualModel.tipoManual,
          manualModel.descripcionManual,
          manualModel.imagenManual,
          manualModel.id
        ]);
  }

  Future<void> deleteManual(int id) async {
    final conn = await MySqlConnection.connect(Configuracion.instancia);
    await conn.query('delete from manual where id=?', [id]);
  }
}
