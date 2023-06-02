import 'package:app_jugueria/modelos/categoriaModel.dart';

class ProductoModel {
  int? id;
  CategoriaModel? categoria;
  String? nombreProducto;
  String? descripcionProducto;
  double? precioProducto;
  String? imagenProducto;
  String? letraProducto;

  ProductoModel(
      {this.id,
      this.nombreProducto,
      this.descripcionProducto,
      this.precioProducto,
      this.imagenProducto,
      this.categoria,
      this.letraProducto});

  factory ProductoModel.fromJson(Map<String, dynamic> json) {
    return ProductoModel(
        id: json['id'] as int,
        nombreProducto: json['nombreProducto'] as String,
        descripcionProducto: json['descripcionProducto'].toString(),
        precioProducto: json['precioProducto'] as double,
        imagenProducto: json['imagenProducto'].toString(),
        categoria: CategoriaModel(
            id: json['idCategoria'] as int,
            nombreCategoria: json['nombreCategoria'] as String),
        letraProducto: json['letraProducto'] as String);
  }
}
