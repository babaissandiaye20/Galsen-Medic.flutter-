class TarifModel {
  final int id;
  final double montant;
  final bool actif;
  final int idSousService;
  final int idDevise;
  final String deviseCode;

  TarifModel({
    required this.id,
    required this.montant,
    required this.actif,
    required this.idSousService,
    required this.idDevise,
    required this.deviseCode,
  });

  factory TarifModel.fromJson(Map<String, dynamic> json) {
    return TarifModel(
      id: json['id'],
      montant: json['montant'].toDouble(),
      actif: json['actif'],
      idSousService: json['idSousService'],
      idDevise: json['idDevise'],
      deviseCode: json['devise']['code'],
    );
  }
}

