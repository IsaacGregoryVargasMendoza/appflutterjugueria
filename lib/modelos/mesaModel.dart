class MesaModel {
  int? _id;
  final String _numeroMesa;

  MesaModel(this._id, this._numeroMesa);

  int? get id => _id;
  String get numeroMesa => _numeroMesa;

  factory MesaModel.fromJson(Map<String, dynamic> json) {
    return MesaModel(json['id'] as int, json['numeroMesa'] as String);
  }
}
