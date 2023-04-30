import 'package:mysql1/mysql1.dart';
import 'package:app_jugueria/modelos/categoriaModel.dart';
import 'package:app_jugueria/controladores/conexion.dart';

class CategoriaController {
  Future<List<CategoriaModel>> getCategorias() async {
    final conn = await MySqlConnection.connect(Configuracion.instancia);
    final result = await conn.query('select * from categoria;');

    final categorias =
        result.map((result) => CategoriaModel.fromJson(result.fields)).toList();
    return categorias;
  }

  Future<void> addCategoria(String nombre) async {
    final conn = await MySqlConnection.connect(Configuracion.instancia);
    final result = await conn
        .query('insert into categoria (nombreCategoria) values (?)', [nombre]);
    print("New user's id: ${result.insertId}");
    // await _personService.addCategoria(newCategoria);
  }

  // Future<void> deleteCategoria(int id) async {
  //   await _personService.deleteCategoria(id);
  // }

  // Future<void> updateCategoria(CategoriaModel categoria) async {
  //   await _personService.updateCategoria(categoria);
  // }
}
