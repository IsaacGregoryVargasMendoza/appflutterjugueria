class ComprobanteModel {
  int? id;
  String? nombreComprobante;
  String? serieComprobante;
  int? correlativoComprobante;

  ComprobanteModel(
      {this.id,
      this.nombreComprobante,
      this.serieComprobante,
      this.correlativoComprobante});

  factory ComprobanteModel.fromJson(Map<String, dynamic> json) {
    return ComprobanteModel(
        id: json['id'] as int,
        nombreComprobante: json['nombreComprobante'] as String,
        serieComprobante: json['serieComprobante'] as String,
        correlativoComprobante: json['correlativoComprobante'] as int);
  }
}
