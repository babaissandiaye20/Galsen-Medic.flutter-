import 'package:flutter/material.dart';
import 'package:galsen_medic/models/disponibilite_model.dart';
import 'package:galsen_medic/services/disponibilite_service.dart';

class DisponibiliteProvider with ChangeNotifier {
  final DisponibiliteService _service = DisponibiliteService();

  List<Disponibilite> disponibilites = [];
  bool isLoading = false;

  Future<void> fetchDisponibilites(int idMedecin) async {
    isLoading = true;
    notifyListeners();

    try {
      final result = await _service.getDisponibilitesByMedecin(idMedecin);
      disponibilites = result;
      print("📦 Disponibilités chargées : ${disponibilites.length}");
    } catch (e) {
      print("❌ Erreur récupération disponibilités : $e");
      disponibilites = [];
    }

    isLoading = false;
    notifyListeners();
  }

  void clear() {
    disponibilites = [];
    notifyListeners();
  }
}
