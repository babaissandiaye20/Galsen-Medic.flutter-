class Privilege {
  final int id;
  final String libelle;

  Privilege({required this.id, required this.libelle});

  factory Privilege.fromJson(Map<String, dynamic> json) {
    print("⚙️ JSON reçu pour Privilege: $json");

    if (json['id'] == null || json['libelle'] == null) {
      print("⚠️ Données incomplètes pour Privilege : $json");
      return Privilege(id: 0, libelle: "Inconnu");
    }

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
    print("🔍 JSON reçu pour Utilisateur: $json");

    if (json['privilege'] == null) {
      print("❌ ATTENTION : Le champ 'privilege' est NULL !");
    }

    return Utilisateur(
      id: json['id'],
      nom: json['nom'],
      prenom: json['prenom'],
      email: json['email'],
      telephone: json['telephone'],
      profil: json['profil'],
      profilUrl: json['profilUrl'],
      privilege:
          json['privilege'] != null
              ? Privilege.fromJson(json['privilege'])
              : Privilege(id: 0, libelle: 'Inconnu'),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nom': nom,
      'prenom': prenom,
      'email': email,
      'telephone': telephone,
      'profil': profil,
      'profilUrl': profilUrl,
      'privilege': {'id': privilege.id, 'libelle': privilege.libelle},
    };
  }
}
