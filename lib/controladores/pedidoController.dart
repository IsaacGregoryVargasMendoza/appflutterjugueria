import 'package:app_jugueria/controladores/mesaController.dart';
import 'package:app_jugueria/modelos/categoriaModel.dart';
import 'package:mysql1/mysql1.dart';
import 'package:app_jugueria/modelos/productoModel.dart';
import 'package:app_jugueria/modelos/adicionalModel.dart';
import 'package:app_jugueria/modelos/pedidoModel.dart';
import 'package:app_jugueria/modelos/comprobanteModel.dart';
import 'package:app_jugueria/controladores/conexion.dart';
import 'package:http/http.dart' as http;

class PedidoController {
  Future<String> getEmpresa(String ruc) async {
    var url = Uri.parse(
        'https://dniruc.apisperu.com/api/v1/ruc/${ruc}?token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJlbWFpbCI6ImlzYWFjY2Fwcmljb3JuaW8xMkBnbWFpbC5jb20ifQ.wg_CLoG-c6fKOQnstptacoM7AM8zlhXMy_wuBZXht7A');

    print(url);
    var response = await http.get(url);
    if (response.statusCode == 200) {
      // La solicitud fue exitosa
      var data = response.body;
      // Haz algo con los datos obtenidos
      print(data);
      return data;
    } else {
      // La solicitud falló
      print('Error: ${response.statusCode}');
      return "";
    }
  }

  Future<String> getPersona(String dni) async {
    var url = Uri.parse(
        'https://dniruc.apisperu.com/api/v1/dni/${dni}?token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJlbWFpbCI6ImlzYWFjY2Fwcmljb3JuaW8xMkBnbWFpbC5jb20ifQ.wg_CLoG-c6fKOQnstptacoM7AM8zlhXMy_wuBZXht7A');

    print(url);
    var response = await http.get(url);
    if (response.statusCode == 200) {
      // La solicitud fue exitosa
      var data = response.body;
      // Haz algo con los datos obtenidos
      print(data);
      return data;
    } else {
      // La solicitud falló
      print('Error: ${response.statusCode}');
      return "";
    }
  }

  Future<List<PedidoModel>> getPedidos() async {
    final conn = await MySqlConnection.connect(Configuracion.instancia);
    final result = await conn.query(//'select * from pedido;');
        'select p.id, p.fechaPedido,p.seriePedido, p.correlativoPedido, p.numeroDocumento, p.denominacionCliente, p.direccionCliente,p.subTotalPedido, p.igvPedido, p.totalPedido, p.estadoPedido, p.idCliente, c.numeroDocumento, c.nombreCliente, c.apellidoCliente, c.telefonoCliente, c.emailCliente, p.idMesa ,m.numeroMesa, c2.nombreComprobante from pedido p inner join cliente c on p.idCliente = c.id inner join mesa m on m.id = p.idMesa inner join comprobante c2 on c2.id = p.idComprobante where estadoPedido = true ORDER by p.id;');

    final pedidos =
        result.map((result) => PedidoModel.fromJson(result.fields)).toList();
    return pedidos;
  }

  Future<List<PedidoModel>> getPedidosDesc() async {
    final conn = await MySqlConnection.connect(Configuracion.instancia);
    final result = await conn.query(//'select * from pedido;');
        'select p.id, p.fechaPedido,p.seriePedido, p.correlativoPedido, p.numeroDocumento, p.denominacionCliente, p.direccionCliente,p.subTotalPedido, p.igvPedido, p.totalPedido, p.estadoPedido, p.idCliente, c.numeroDocumento, c.nombreCliente, c.apellidoCliente, c.telefonoCliente, c.emailCliente, p.idMesa ,m.numeroMesa, c2.nombreComprobante from pedido p inner join cliente c on p.idCliente = c.id inner join mesa m on m.id = p.idMesa inner join comprobante c2 on c2.id = p.idComprobante where estadoPedido = true ORDER by p.id DESC;');

    final pedidos =
        result.map((result) => PedidoModel.fromJson(result.fields)).toList();
    return pedidos;
  }

  Future<List<CategoriasVendidasModel>> getCategoriasVendidasConFecha() async {
    final conn = await MySqlConnection.connect(Configuracion.instancia);
    final result = await conn.query(//'select * from pedido;');
        "select p.id as 'idPedido',p.fechaPedido as 'fechaPedido',dp.cantidadDetalle as 'cantidadPedido',dp.precioDetalle as 'precioPedido',dp.idProducto as 'idProducto',pr.nombreProducto as 'nombreProducto',c.nombreCategoria as 'nombreCategoria' from pedido p inner join detallePedido dp on p.id = dp.idDetallePedido inner join producto pr on dp.idProducto = pr.id inner join categoria c on c.id = pr.idCategoria order by p.id;");

    final categoriasVendidas =
        result.map((result) => CategoriasVendidasModel.fromJson(result.fields)).toList();
    return categoriasVendidas;
  }

  Future<List<ComprobanteModel>> getComprobantes() async {
    final conn = await MySqlConnection.connect(Configuracion.instancia);
    final result = await conn.query('select * from comprobante;');

    final comprobantes = result
        .map((result) => ComprobanteModel.fromJson(result.fields))
        .toList();
    return comprobantes;
  }

  Future<ComprobanteModel> getComprobante(int idComprobante) async {
    final conn = await MySqlConnection.connect(Configuracion.instancia);
    final result = await conn
        .query('select * from comprobante where id = ?;', [idComprobante]);

    final comprobantes = result
        .map((result) => ComprobanteModel.fromJson(result.fields))
        .toList();
    return comprobantes[0];
  }

  Future<void> updateComprobante(int idComprobante) async {
    final conn = await MySqlConnection.connect(Configuracion.instancia);
    await conn.query(
        'update comprobante set correlativoComprobante = correlativoComprobante + 1 where id = ?;',
        [idComprobante]);
  }

  List<CategoriasVendidasModel> formatearFechasCategoriasVendidas(List<CategoriasVendidasModel> lista) {
    List<CategoriasVendidasModel> listaNueva = [];
    for (var i = 0; i < lista.length; i++) {
      CategoriasVendidasModel categoriaVendidaModel = CategoriasVendidasModel();
      categoriaVendidaModel.idPedido = lista[i].idPedido;
      categoriaVendidaModel.idProducto = lista[i].idProducto;
      categoriaVendidaModel.nombreProducto = lista[i].nombreProducto;
      categoriaVendidaModel.cantidadPedido = lista[i].cantidadPedido;
      categoriaVendidaModel.precioPedido = lista[i].precioPedido;
      categoriaVendidaModel.nombreCategoria = lista[i].nombreCategoria;
      categoriaVendidaModel.fechaPedido = lista[i].fechaPedido;

      var fecha = categoriaVendidaModel.fechaPedido!.split(" ")[0].toString();
      categoriaVendidaModel.fechaPedido = "${fecha.split("/")[1]}/${fecha.split("/")[2]}";

      listaNueva.add(categoriaVendidaModel);
    }

    return listaNueva;
  }

  List<PedidoModel> formatearFechas(List<PedidoModel> lista) {
    List<PedidoModel> listaNueva = [];
    for (var i = 0; i < lista.length; i++) {
      PedidoModel pedidoModel = PedidoModel();
      pedidoModel.id = lista[i].id;
      pedidoModel.cliente = lista[i].cliente;
      pedidoModel.mesa = lista[i].mesa;
      pedidoModel.comprobante = lista[i].comprobante;
      pedidoModel.numeroDocumento = lista[i].numeroDocumento;
      pedidoModel.denominacionCliente = lista[i].denominacionCliente;
      pedidoModel.direccionCliente = lista[i].direccionCliente;
      pedidoModel.fechaPedido = lista[i].fechaPedido;
      pedidoModel.seriePedido = lista[i].seriePedido;
      pedidoModel.correlativoPedido = lista[i].correlativoPedido;
      pedidoModel.subTotalPedido = lista[i].subTotalPedido;
      pedidoModel.igvPedido = lista[i].igvPedido;
      pedidoModel.totalPedido = lista[i].totalPedido;

      var fecha = pedidoModel.fechaPedido!.split(" ")[0].toString();
      pedidoModel.fechaPedido = "${fecha.split("/")[1]}/${fecha.split("/")[2]}";

      listaNueva.add(pedidoModel);
    }

    return listaNueva;
  }

  List<List<PedidoModel>?> listaPorComprobante(List<PedidoModel> lista) {
    List<List<PedidoModel>> listaPorComprobante = [];

    List<PedidoModel> listaTickets = [];
    List<PedidoModel> listaBoletas = [];
    List<PedidoModel> listaFacturas = [];

    listaTickets = lista
        .where((element) => element.comprobante!.nombreComprobante == "TICKET")
        .toList();
    listaBoletas = lista
        .where((element) => element.comprobante!.nombreComprobante == "BOLETA")
        .toList();
    listaFacturas = lista
        .where((element) => element.comprobante!.nombreComprobante == "FACTURA")
        .toList();

    listaPorComprobante.add(listaTickets);
    listaPorComprobante.add(listaBoletas);
    listaPorComprobante.add(listaFacturas);

    return listaPorComprobante;
  }

  List<List<CategoriasVendidasModel>?> listaPorCategoria(List<CategoriasVendidasModel> lista, List<CategoriaModel> listaCategorias) {
    List<List<CategoriasVendidasModel>> listaPorCategoria = [];

    for(var i = 0;  i<listaCategorias.length; i++){
      var listaAux = lista
        .where((element) => element.nombreCategoria == listaCategorias[i].nombreCategoria)
        .toList();

      if(listaAux.isNotEmpty){
        listaPorCategoria.add(listaAux);
      }
    }

    return listaPorCategoria;
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

  PedidoModel llenarPedido(
      PedidoModel pedidoModel,
      List<ProductoModel> listaProductos,
      List<List<AdicionalModel>> listaAdicionales,
      List<int> listaCantidades) {
    List<DetallePedidoModel> listaDetallePedido = [];

    for (int i = 0; i < listaProductos.length; i++) {
      DetallePedidoModel detallePedidoModel = DetallePedidoModel(
          producto: listaProductos[i],
          cantidadDetalle: listaCantidades[i],
          observacion: "",
          precioDetalle: listaProductos[i].precioProducto);

      List<DetalleProductoModel> listaDetalleProducto = [];
      for (int j = 0; j < listaAdicionales[i].length; j++) {
        DetalleProductoModel detalleProductoModel = DetalleProductoModel(
            producto: listaProductos[i], adicional: listaAdicionales[i][j]);
        listaDetalleProducto.add(detalleProductoModel);
      }

      detallePedidoModel.lista = listaDetalleProducto;

      listaDetallePedido.add(detallePedidoModel);
    }

    pedidoModel.detallePedido = listaDetallePedido;
    return pedidoModel;
  }

  Future<PedidoModel> addPedido(PedidoModel pedidoModel) async {
    final conn = await MySqlConnection.connect(Configuracion.instancia);
    final results = await conn.query(
        'insert into pedido (idCliente, idMesa, idComprobante,fechaPedido,seriePedido,correlativoPedido, subTotalPedido, igvPedido,totalPedido, estadoPedido) values (?,?,?,?,?,?,?,?,?,true);',
        [
          pedidoModel.cliente!.id,
          pedidoModel.mesa!.id,
          pedidoModel.comprobante!.id,
          pedidoModel.fechaPedido,
          pedidoModel.seriePedido,
          pedidoModel.correlativoPedido,
          pedidoModel.subTotalPedido,
          pedidoModel.igvPedido,
          pedidoModel.totalPedido
        ]);

    MesaController mesaCtrll = MesaController();
    await mesaCtrll.occupyMesa(pedidoModel.mesa!);

    await updateComprobante(pedidoModel.comprobante!.id!);

    final pedidoId = results.insertId;
    pedidoModel.id = pedidoId;
    print('ID del registro insertado: $pedidoId');

    for (int i = 0; i < pedidoModel.detallePedido!.length; i++) {
      final resultadoDetalle = await conn.query(
          'insert into detallePedido (idDetallePedido, idProducto, cantidadDetalle , precioDetalle , observacion, estadoDetalle) values (?,?,?,?,?,true);',
          [
            pedidoId,
            pedidoModel.detallePedido![i].producto!.id,
            pedidoModel.detallePedido![i].cantidadDetalle,
            pedidoModel.detallePedido![i].producto!.precioProducto,
            "",
          ]);
      for (int j = 0; j < pedidoModel.detallePedido![i].lista!.length; j++) {
        await conn.query(
            'insert into detalleProducto (idDetallePedido,idProducto, idAdicional, estadoDetalle) values (?,?,?,true);',
            [
              resultadoDetalle.insertId,
              pedidoModel.detallePedido![i].lista![j].producto!.id,
              pedidoModel.detallePedido![i].lista![j].adicional!.id,
            ]);
      }
    }

    return pedidoModel;

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
