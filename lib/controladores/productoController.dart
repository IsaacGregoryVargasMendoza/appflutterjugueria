import 'package:mysql1/mysql1.dart';
import 'package:app_jugueria/modelos/productoModel.dart';
import 'package:app_jugueria/controladores/conexion.dart';

class ProductoController {
  Future<List<ProductoModel>> getProductos() async {
    final conn = await MySqlConnection.connect(Configuracion.instancia);
    final result = await conn.query(
        'select p.id, p.idCategoria, p.nombreProducto, p.descripcionProducto , p.precioProducto, p.imagenProducto, p.letraProducto, p.estavisible, p.estadoProducto, c.nombreCategoria from producto p inner join categoria c on p.idCategoria = c.id where estadoProducto = true;');

    final productos =
        result.map((result) => ProductoModel.fromJson(result.fields)).toList();
    return productos;
  }

  Future<List<ProductoModel>> getProductoWithLetter(String letra) async {
    final conn = await MySqlConnection.connect(Configuracion.instancia);
    final result = await conn.query(
        'select p.id, p.idCategoria, p.nombreProducto, p.descripcionProducto , p.precioProducto, p.imagenProducto, p.letraProducto, p.estavisible, p.estadoProducto, c.nombreCategoria from producto p inner join categoria c on p.idCategoria = c.id where estadoProducto = true and letraProducto = ?;',
        [letra]);

    final producto =
        result.map((result) => ProductoModel.fromJson(result.fields)).toList();
    return producto;
  }

  Future<void> addProducto(ProductoModel productoModel) async {
    final conn = await MySqlConnection.connect(Configuracion.instancia);
    await conn.query(
        'insert into producto (nombreProducto, descripcionProducto, precioProducto, idCategoria, imagenProducto, letraProducto, estaVisible, estadoProducto) values (?,?,?,?,?,?,true,true)',
        [
          productoModel.nombreProducto,
          productoModel.descripcionProducto,
          productoModel.precioProducto,
          productoModel.categoria!.id,
          productoModel.imagenProducto,
          productoModel.letraProducto
        ]);
  }

  Future<void> updateProducto(ProductoModel productoModel) async {
    final conn = await MySqlConnection.connect(Configuracion.instancia);
    await conn.query(
        'update producto set nombreProducto=?, descripcionProducto=?, precioProducto=?, idCategoria=?, imagenProducto=?, letraProducto=? where id=?;',
        [
          productoModel.nombreProducto,
          productoModel.descripcionProducto,
          productoModel.precioProducto,
          productoModel.categoria!.id,
          productoModel.imagenProducto,
          productoModel.letraProducto,
          productoModel.id
        ]);
  }

  Future<void> deleteProducto(int id) async {
    final conn = await MySqlConnection.connect(Configuracion.instancia);
    await conn
        .query('update producto set estadoProducto=false where id=?;', [id]);
  }
}
