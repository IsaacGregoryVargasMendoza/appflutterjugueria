import 'package:mysql1/mysql1.dart';

class TipoDocumentoModel {
  int? id;
  String? nombreDocumento;

  TipoDocumentoModel({this.id, this.nombreDocumento});

  factory TipoDocumentoModel.fromJson(Map<String, dynamic> json) {
    return TipoDocumentoModel(
        id: json['id'] as int,
        nombreDocumento: json['nombreDocumento'] as String);
  }
}
