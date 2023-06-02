import 'package:mysql1/mysql1.dart';
import 'package:app_jugueria/modelos/productoModel.dart';
import 'package:app_jugueria/modelos/adicionalModel.dart';
import 'package:app_jugueria/modelos/pedidoModel.dart';
import 'package:app_jugueria/controladores/conexion.dart';
import 'package:intl/intl.dart';

class PedidoController {
  Future<List<PedidoModel>> getPedidos() async {
    final conn = await MySqlConnection.connect(Configuracion.instancia);
    final result = await conn.query(//'select * from pedido;');
        'select p.id, p.fechaPedido, p.totalPedido, p.estadoPedido, p.idCliente, c.numeroDocumento, c.nombreCliente, c.apellidoCliente, c.telefonoCliente, c.emailCliente, p.idMesa ,m.numeroMesa  from pedido p inner join cliente c on p.idCliente = c.id inner join mesa m on m.id = p.idMesa where estadoPedido = true;');

    final pedidos =
        result.map((result) => PedidoModel.fromJson(result.fields)).toList();
    return pedidos;
  }

  Future<List<DetallePedidoModel>> getListDetalleOfPedido(int id) async {
    final conn = await MySqlConnection.connect(Configuracion.instancia);
    final result = await conn.query(
        'select dp.id, dp.idDetallePedido , dp.cantidadDetalle, dp.precioDetalle, dp.observacion, dp.idProducto, p.nombreProducto, p.descripcionProducto, p.imagenProducto, p.letraProducto, p.estavisible  from detallePedido dp inner join producto p on dp.idProducto = p.id where dp.idDetallePedido = ?;',
        //'select * from detallePedido dp inner join detalleProducto dp2 on dp.id = dp2.idDetallePedido inner join producto p on dp.idProducto = p.id inner join adicional a on dp2.idAdicional = a.id inner join pedido p2 ON dp.idDetallePedido = p2.id where p2.id = ?',
        [id]);

    final pedidos = result
        .map((result) => DetallePedidoModel.fromJson(result.fields))
        .toList();
    return pedidos;
  }

  Future<List<List<AdicionalModel>>> getListAdicionales(
      List<DetallePedidoModel> listaDetalle) async {
    List<List<AdicionalModel>> listaTotal = [];

    for (int i = 0; i < listaDetalle.length; i++) {
      final result = await getListAdicionalWithDetalleProducto(
          listaDetalle[i].id!, listaDetalle[i].producto!.id!);

      listaTotal.add(result);
    }

    return listaTotal;
  }

  Future<List<AdicionalModel>> getListAdicionalWithDetalleProducto(
      int idDetallePedido, int idProducto) async {
    final conn = await MySqlConnection.connect(Configuracion.instancia);
    final result = await conn.query(
        'select a.id, a.nombreAdicional,a.letraAdicional,a.visibleAdicional from detalleProducto dp2 inner join adicional a on dp2.idAdicional = a.id where dp2.idDetallePedido = ? and dp2.idProducto = ?;',
        [idDetallePedido, idProducto]);

    final listaAdicionales =
        result.map((result) => AdicionalModel.fromJson(result.fields)).toList();
    return listaAdicionales;
  }

  //select a.id, a.nombreAdicional,a.letraAdicional from detalleProducto dp2 inner join adicional a on dp2.idAdicional = a.id where dp2.idDetallePedido = ? and dp2.idProducto = ?;

  Future<void> addPedido(
      List<ProductoModel> listaProductos,
      List<List<AdicionalModel>> listaAdicionales,
      List<int> listaCantidades,
      double total) async {
    final conn = await MySqlConnection.connect(Configuracion.instancia);
    final results = await conn.query(
        'insert into pedido (idCliente, idMesa, fechaPedido, totalPedido, estadoPedido) values (2,1,?,?,true);',
        [DateFormat('dd/MM/yyyy hh:mm:ss').format(DateTime.now()), total]);

    final pedidoId = results.insertId;
    print('ID del registro insertado: $pedidoId');

    for (int i = 0; i < listaProductos.length; i++) {
      final resultadoDetalle = await conn.query(
          'insert into detallePedido (idDetallePedido, idProducto, cantidadDetalle , precioDetalle , observacion, estadoDetalle) values (?,?,?,?,?,true);',
          [
            pedidoId,
            listaProductos[i].id,
            listaCantidades[i],
            listaProductos[i].precioProducto,
            "",
          ]);
      for (int j = 0; j < listaAdicionales[i].length; j++) {
        await conn.query(
            'insert into detalleProducto (idDetallePedido,idProducto, idAdicional, estadoDetalle) values (?,?,?,true);',
            [
              resultadoDetalle.insertId,
              listaProductos[i].id,
              listaAdicionales[i][j].id,
            ]);
      }
    }

    // for (int i = 0; i < listaAdicionales.length; i++) {
    //   for (int j = 0; j < listaAdicionales[i].length; j++) {
    //     await conn.query(
    //         'insert into detalleProducto (idDetallePedido,idProducto, idAdicional, estadoDetalle) values (?,?,?,true);',
    //         [
    //           pedidoId,
    //           listaProductos[i].id,
    //           listaCantidades[i],
    //           listaProductos[i].precioProducto,
    //           "",
    //         ]);
    //   }
    // }
  }

  // Future<void> updateProducto(ProductoModel productoModel) async {
  //   final conn = await MySqlConnection.connect(Configuracion.instancia);
  //   await conn.query(
  //       'update producto set nombreProducto=?, descripcionProducto=?, precioProducto=?, idCategoria=?, imagenProducto=?, letraProducto=? where id=?;',
  //       [
  //         productoModel.nombreProducto,
  //         productoModel.descripcionProducto,
  //         productoModel.precioProducto,
  //         productoModel.categoria!.id,
  //         productoModel.imagenProducto,
  //         productoModel.letraProducto,
  //         productoModel.id
  //       ]);
  // }

  // Future<void> deleteProducto(int id) async {
  //   final conn = await MySqlConnection.connect(Configuracion.instancia);
  //   await conn
  //       .query('update producto set estadoProducto=false where id=?;', [id]);
  // }
}
