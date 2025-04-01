import 'package:flutter/material.dart';
import 'package:galsen_medic/models/utilisateur.dart';
import 'package:galsen_medic/services/utilisateur_service.dart';

class UtilisateurProvider with ChangeNotifier {
  final UtilisateurService _service = UtilisateurService();

  List<Utilisateur> utilisateurs = [];
  bool isLoading = false;

  Future<void> fetchUtilisateurs() async {
    isLoading = true;
    notifyListeners();

    try {
      utilisateurs = await _service.getUsersWithoutAdminAndClient();
    } catch (e) {
      utilisateurs = [];
    }

    isLoading = false;
    notifyListeners();
  }

  void addUtilisateur(Utilisateur utilisateur) {
    utilisateurs.insert(0, utilisateur);
    notifyListeners();
  }
}
