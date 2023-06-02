class MesaModel {
  int? id;
  String? numeroMesa;
  int? ocupadoMesa;

  MesaModel({this.id, this.numeroMesa, this.ocupadoMesa});

  factory MesaModel.fromJson(Map<String, dynamic> json) {
    return MesaModel(
        id: json['id'] as int,
        numeroMesa: json['numeroMesa'] as String,
        ocupadoMesa: json['ocupadoMesa'] as int);
  }
}
