class AdicionalModel {
  int? id;
  String? nombreAdicional;
  String? letraAdicional;
  int? visibleAdicional;

  AdicionalModel(
      {this.id,
      this.nombreAdicional,
      this.letraAdicional,
      this.visibleAdicional});

  factory AdicionalModel.fromJson(Map<String, dynamic> json) {
    return AdicionalModel(
        id: json['id'] as int,
        nombreAdicional: json['nombreAdicional'] as String,
        letraAdicional: json['letraAdicional'] as String,
        visibleAdicional: json['visibleAdicional'] as int);
  }
}

class CategoriaAdicionalModel {
  int? idCategoria;
  int? idAdicional;
  int? estaActivo;

  CategoriaAdicionalModel(
      {this.idCategoria, this.idAdicional, this.estaActivo});

  factory CategoriaAdicionalModel.fromJson(Map<String, dynamic> json) {
    return CategoriaAdicionalModel(
        idCategoria: json['idCategoria'] as int,
        idAdicional: json['idAdicional'] as int,
        estaActivo: json['estaActivo'] as int);
  }
}
