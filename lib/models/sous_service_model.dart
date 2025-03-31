class SousServiceModel {
  final int id;
  final String libelle;
  final String? iconUrl;
  final int idService;

  SousServiceModel({
    required this.id,
    required this.libelle,
    this.iconUrl,
    required this.idService,
  });

  factory SousServiceModel.fromJson(Map<String, dynamic> json) {
    return SousServiceModel(
      id: json['id'],
      libelle: json['libelle'],
      iconUrl: json['iconUrl'],
      idService: json['idService'],
    );
  }
}
