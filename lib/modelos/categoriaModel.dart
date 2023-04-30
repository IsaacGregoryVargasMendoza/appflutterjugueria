import 'package:mysql1/mysql1.dart';

class CategoriaModel {
  int? _id;
  final String _nombreCategoria;

  CategoriaModel(this._id, this._nombreCategoria);

  String get nombreCategoria => _nombreCategoria;

  int? get id => _id;

  factory CategoriaModel.fromJson(Map<String, dynamic> json) {
    return CategoriaModel(json['id'] as int, json['nombreCategoria'] as String);
  }
}



// final conn = MySqlConnection.connect(ConnectionSettings(
//   host: '34.176.109.9',
//   port: 3306,
//   user: 'basesql-jugueria-2023',
//   password: '123456789.',
//   db: 'app-jugueria',
// ));
