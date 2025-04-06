class Disponibilite {
  final int id;
  final String jourSemaine;
  final String heureDebut;
  final String heureFin;
  final List<String> horairesDisponibles;

  Disponibilite({
    required this.id,
    required this.jourSemaine,
    required this.heureDebut,
    required this.heureFin,
    required this.horairesDisponibles,
  });

  factory Disponibilite.fromJson(Map<String, dynamic> json) {
    return Disponibilite(
      id: json['id'],
      jourSemaine: json['jourSemaine'],
      heureDebut: json['heureDebut'],
      heureFin: json['heureFin'],
      horairesDisponibles:
      List<String>.from(json['horairesDisponibles'] ?? []),
    );
  }
}
