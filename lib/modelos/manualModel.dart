class ManualModel {
  int? id;
  int? pasoManual;
  int? tipoManual;
  String? descripcionManual;
  String? imagenManual;

  ManualModel(
      {this.id,
      this.pasoManual,
      this.tipoManual,
      this.descripcionManual,
      this.imagenManual});

  factory ManualModel.fromJson(Map<String, dynamic> json) {
    return ManualModel(
        id: json['id'] as int,
        pasoManual: json['pasoManual'] as int,
        tipoManual: json['tipoManual'] as int,
        descripcionManual: json['descripcionManual'] as String,
        imagenManual: json['imagenManual'].toString());
  }
}
