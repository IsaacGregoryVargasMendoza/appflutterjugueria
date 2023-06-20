import 'package:mysql1/mysql1.dart';
import 'package:app_jugueria/modelos/mesaModel.dart';
import 'package:app_jugueria/controladores/conexion.dart';

class MesaController {
  Future<List<MesaModel>> getMesas() async {
    final conn = await MySqlConnection.connect(Configuracion.instancia);
    final result = await conn.query('select * from mesa;');

    final mesas =
        result.map((result) => MesaModel.fromJson(result.fields)).toList();
    return mesas;
  }

  Future<void> addMesa(String numero) async {
    final conn = await MySqlConnection.connect(Configuracion.instancia);
    await conn.query(
        'insert into mesa (numeroMesa, ocupadoMesa, estadoMesa) values (?, 0, true)',
        [numero]);
  }

  Future<void> updateMesa(MesaModel mesa) async {
    final conn = await MySqlConnection.connect(Configuracion.instancia);
    await conn.query(
        'update mesa set numeroMesa=? where id=?;', [mesa.numeroMesa, mesa.id]);
  }

  Future<void> occupyMesa(MesaModel mesa) async {
    final conn = await MySqlConnection.connect(Configuracion.instancia);
    await conn.query('update mesa set ocupadoMesa=1 where id=?;', [mesa.id]);
  }

  Future<void> freeMesa(int id) async {
    final conn = await MySqlConnection.connect(Configuracion.instancia);
    await conn.query('update mesa set ocupadoMesa=0 where id=?;', [id]);
  }

  Future<void> deleteMesa(int id) async {
    final conn = await MySqlConnection.connect(Configuracion.instancia);
    await conn.query('update mesa set estadoMesa=false where id=?', [id]);
  }
}
