class DeviseModel {
  final int id;
  final String code;
  final String libelle;
  final String symbole;
  final bool actif;

  DeviseModel({
    required this.id,
    required this.code,
    required this.libelle,
    required this.symbole,
    required this.actif,
  });

  factory DeviseModel.fromJson(Map<String, dynamic> json) {
    return DeviseModel(
      id: json['id'],
      code: json['code'],
      libelle: json['libelle'],
      symbole: json['symbole'],
      actif: json['actif'],
    );
  }
}
