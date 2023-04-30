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
    final result =
        await conn.query('insert into mesa (numeroMesa) values (?)', [numero]);
    print("New user's id: ${result.insertId}");
    // await _personService.addCategoria(newCategoria);
  }
}
