import 'package:app_jugueria/modelos/categoriaModel.dart';
import 'package:mysql1/mysql1.dart';
import 'dart:convert';

class ProductoModel {
  int? _id;
  final CategoriaModel _categoria;
  final String _nombreProducto;
  final String _descripcionProducto;
  final double _precioProducto;
  final String _imagenProducto;

  ProductoModel(this._id, this._nombreProducto, this._descripcionProducto,
      this._precioProducto, this._imagenProducto, this._categoria);

  int? get id => _id;
  CategoriaModel get categoria => _categoria;
  String get nombreProducto => _nombreProducto;
  String get descripcionProducto => _descripcionProducto;
  double get precioProducto => _precioProducto;
  String get imagenProducto => _imagenProducto;

  factory ProductoModel.fromJson(Map<String, dynamic> json) {
    return ProductoModel(
        json['id'] as int,
        json['nombreProducto'] as String,
        json['descripcionProducto'].toString(),
        json['precioProducto'] as double,
        json['imagenProducto'].toString(),
        CategoriaModel(json['idCategoria'] as int, ""));
  }
}
