class ServiceModel {
  final int id;
  final String libelle;
  final String? iconUrl;

  ServiceModel({required this.id, required this.libelle, this.iconUrl});

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['id'],
      libelle: json['libelle'],
      iconUrl: json['iconUrl'],
    );
  }
}
