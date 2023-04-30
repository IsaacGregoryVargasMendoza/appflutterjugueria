import 'package:app_jugueria/modelos/categoriaModel.dart';
import 'package:app_jugueria/modelos/clienteModel.dart';
import 'package:app_jugueria/modelos/mesaModel.dart';
import 'package:app_jugueria/modelos/productoModel.dart';

class PedidoModel {
  int? _id;
  final ClienteModel _cliente;
  final MesaModel _mesa;
  final String _fechaPedido;
  final double _totalPedido;
  List<DetallePedidoModel>? _detallePedido;

  PedidoModel(this._id, this._cliente, this._mesa, this._fechaPedido,
      this._totalPedido);

  int? get id => _id;
  ClienteModel get cliente => _cliente;
  MesaModel get mesa => _mesa;
  String get fechaPedido => _fechaPedido;
  double get totalPedido => _totalPedido;
  List<DetallePedidoModel>? get detallePedido => _detallePedido;

  factory PedidoModel.fromJson(Map<String, dynamic> json) {
    return PedidoModel(
        json['id'] as int,
        ClienteModel(json['cliente'], "", "", "", ""),
        MesaModel(json['mesa'], ""),
        json['fechaPedido'] as String,
        json['totalPedido'] as double);
  }
}

class DetallePedidoModel {
  final PedidoModel _pedido;
  final ProductoModel _producto;
  final double _cantidadDetalle;
  final double _precioDetalle;

  DetallePedidoModel(
      this._pedido, this._producto, this._cantidadDetalle, this._precioDetalle);

  PedidoModel get pedido => _pedido;
  ProductoModel get producto => _producto;
  double get cantidadDetalle => _cantidadDetalle;
  double get precioDetalle => _precioDetalle;

  factory DetallePedidoModel.fromJson(Map<String, dynamic> json) {
    return DetallePedidoModel(
        PedidoModel(json['idPedido'], ClienteModel(0, "", "", "", ""),
            MesaModel(0, ""), "", 0),
        ProductoModel(json["idProducto"], "", "", 0, "", CategoriaModel(0, "")),
        json["cantidadDetalle"] as double,
        json["precioDetalle"] as double);
  }
}
