import 'package:app_jugueria/modelos/productoModel.dart';
import 'package:mysql1/mysql1.dart';
import 'package:app_jugueria/modelos/categoriaModel.dart';
import 'package:app_jugueria/controladores/conexion.dart';

class CategoriaController {
  Future<List<CategoriaModel>> getCategorias() async {
    final conn = await MySqlConnection.connect(Configuracion.instancia);
    final result =
        await conn.query('select * from categoria where estadoCategoria=true;');

    final categorias =
        result.map((result) => CategoriaModel.fromJson(result.fields)).toList();
    return categorias;
  }

  Future<List<ProductoModel>> getProductosConCategoria(int idCategoria) async {
    final conn = await MySqlConnection.connect(Configuracion.instancia);
    final result =
        await conn.query('select p.id, p.idCategoria, p.nombreProducto, p.descripcionProducto , p.precioProducto, p.imagenProducto, p.letraProducto, p.estavisible, p.estadoProducto, c.nombreCategoria from producto p inner join categoria c on p.idCategoria = c.id where estadoProducto = true and idCategoria = ?;',[idCategoria]);

    final productos =
        result.map((result) => ProductoModel.fromJson(result.fields)).toList();
    return productos;
  }

  Future<void> addCategoria(CategoriaModel categoria) async {
    final conn = await MySqlConnection.connect(Configuracion.instancia);
    await conn.query(
        'insert into categoria (nombreCategoria, letraCategoria, estadoCategoria) values (?,?,true)',
        [categoria.nombreCategoria, categoria.letraCategoria]);
  }

  Future<void> updateCategoria(CategoriaModel categoria) async {
    final conn = await MySqlConnection.connect(Configuracion.instancia);
    await conn.query(
        'update categoria set nombreCategoria=?, letraCategoria=? where id=?;',
        [categoria.nombreCategoria, categoria.letraCategoria, categoria.id]);
  }

  Future<void> deleteCategoria(int id) async {
    final conn = await MySqlConnection.connect(Configuracion.instancia);
    await conn
        .query('update categoria set estadoCategoria=false where id=?', [id]);
  }
}
