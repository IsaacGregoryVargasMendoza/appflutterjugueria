import 'package:mysql1/mysql1.dart';

class CategoriaModel {
  int? id;
  String? nombreCategoria;
  String? letraCategoria;

  CategoriaModel({this.id, this.nombreCategoria, this.letraCategoria});

  factory CategoriaModel.fromJson(Map<String, dynamic> json) {
    return CategoriaModel(
        id: json['id'] as int,
        nombreCategoria: json['nombreCategoria'] as String,
        letraCategoria: json['letraCategoria'] as String);
  }
}

// final conn = MySqlConnection.connect(ConnectionSettings(
//   host: '34.176.109.9',
//   port: 3306,
//   user: 'basesql-jugueria-2023',
//   password: '123456789.',
//   db: 'app-jugueria',
// ));
