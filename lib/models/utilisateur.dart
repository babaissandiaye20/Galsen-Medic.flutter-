class Privilege {
  final int id;
  final String libelle;

  Privilege({required this.id, required this.libelle});

  factory Privilege.fromJson(Map<String, dynamic> json) {
    return Privilege(id: json['id'], libelle: json['libelle']);
  }
}

class Utilisateur {
  final int id;
  final String nom;
  final String prenom;
  final String email;
  final String telephone;
  final String? profil;
  final String? profilUrl;
  final Privilege privilege;

  Utilisateur({
    required this.id,
    required this.nom,
    required this.prenom,
    required this.email,
    required this.telephone,
    this.profil,
    this.profilUrl,
    required this.privilege,
  });

  factory Utilisateur.fromJson(Map<String, dynamic> json) {
    return Utilisateur(
      id: json['id'],
      nom: json['nom'],
      prenom: json['prenom'],
      email: json['email'],
      telephone: json['telephone'],
      profil: json['profil'],
      profilUrl: json['profilUrl'],
      privilege: Privilege.fromJson(json['privilege']),
    );
  }
}
