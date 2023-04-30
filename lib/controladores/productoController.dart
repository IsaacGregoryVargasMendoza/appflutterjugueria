import 'package:mysql1/mysql1.dart';
import 'package:app_jugueria/modelos/productoModel.dart';
import 'package:app_jugueria/controladores/conexion.dart';

class ProductoController {
  Future<List<ProductoModel>> getProductos() async {
    final conn = await MySqlConnection.connect(Configuracion.instancia);
    final result = await conn.query('select * from producto;');

    final productos =
        result.map((result) => ProductoModel.fromJson(result.fields)).toList();
    return productos;
  }

  Future<void> addProducto(String nombre, int categoria, String descripcion,
      double precio, String imagen) async {
    final conn = await MySqlConnection.connect(Configuracion.instancia);
    final result = await conn.query(
        'insert into producto (nombreProducto, descripcionProducto, precioProducto, idCategoria, imagenProducto) values (?,?,?,?,?)',
        [nombre, descripcion, precio, categoria, imagen]);
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
