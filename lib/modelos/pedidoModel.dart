import 'package:app_jugueria/modelos/adicionalModel.dart';
import 'package:app_jugueria/modelos/clienteModel.dart';
import 'package:app_jugueria/modelos/mesaModel.dart';
import 'package:app_jugueria/modelos/productoModel.dart';

class PedidoModel {
  int? id;
  ClienteModel? cliente;
  MesaModel? mesa;
  String? fechaPedido;
  double? totalPedido;
  List<DetallePedidoModel>? detallePedido;

  PedidoModel(
      {this.id,
      this.cliente,
      this.mesa,
      this.fechaPedido,
      this.totalPedido,
      this.detallePedido});

  factory PedidoModel.fromJson(Map<String, dynamic> json) {
    return PedidoModel(
        id: json['id'],
        cliente: ClienteModel(
            id: json['idCliente'] as int,
            numeroDocumento: json['numeroDocumento'] as String,
            nombreCliente: json['nombreCliente'] as String,
            apellidoCliente: json['apellidoCliente'] as String,
            telefonoCliente: json['telefonoCliente'] as String),
        mesa: MesaModel(id: json['idMesa']),
        fechaPedido: json['fechaPedido'] as String,
        totalPedido: json['totalPedido'] as double);
  }
}

class DetallePedidoModel {
  int? id;
  PedidoModel? pedido;
  ProductoModel? producto;
  int? cantidadDetalle;
  double? precioDetalle;
  String? observacion;
  List<DetalleProductoModel>? lista;

  DetallePedidoModel(
      {this.id,
      this.pedido,
      this.producto,
      this.cantidadDetalle,
      this.precioDetalle,
      this.observacion,
      this.lista});

  factory DetallePedidoModel.fromJson(Map<String, dynamic> json) {
    return DetallePedidoModel(
        id: json['id'] as int,
        pedido: PedidoModel(id: json['idDetallePedido']),
        producto: ProductoModel(
            id: json["idProducto"],
            nombreProducto: json["nombreProducto"] as String,
            descripcionProducto: json["descripcionProducto"].toString(),
            imagenProducto: json["imagenProducto"].toString(),
            letraProducto: json["letraProducto"] as String),
        cantidadDetalle: json["cantidadDetalle"] as int,
        precioDetalle: json["precioDetalle"] as double,
        observacion: "");
  }
}

class DetalleProductoModel {
  int? id;
  DetallePedidoModel? detallePedido;
  ProductoModel? producto;
  AdicionalModel? adicional;

  DetalleProductoModel(
      {this.id, this.detallePedido, this.producto, this.adicional});

  factory DetalleProductoModel.fromJson(Map<String, dynamic> json) {
    return DetalleProductoModel(
        id: json['id'],
        detallePedido: DetallePedidoModel(id: json['idDetallePedido'] as int),
        producto: ProductoModel(id: json['idProducto'] as int),
        adicional: AdicionalModel(id: json['idAdicional'] as int));
  }
}
