class ClienteModel {
  int? _id;
  final String _nombreCliente;
  final String _apellidoCliente;
  final String _telefonoCliente;
  final String _emailCliente;

  ClienteModel(this._id, this._nombreCliente, this._apellidoCliente,
      this._telefonoCliente, this._emailCliente);

  int? get id => _id;
  String get nombreCliente => _nombreCliente;
  String get apellidoCliente => _apellidoCliente;
  String get telefonoCliente => _telefonoCliente;
  String get emailCliente => _emailCliente;

  factory ClienteModel.fromJson(Map<String, dynamic> json) {
    return ClienteModel(
        json['id'] as int,
        json['nombreCliente'] as String,
        json['apellidoCliente'] as String,
        json['telefonoCliente'] as String,
        json['emailCliente'] as String);
  }
}
