import 'package:flutter/material.dart';
import 'package:galsen_medic/models/tarif_model.dart';
import 'package:galsen_medic/services/tarif_service.dart';

class TarifProvider with ChangeNotifier {
  final TarifService _api = TarifService(baseUrl: 'http://localhost:3000');

  List<TarifModel> tarifs = [];
  bool isLoading = false;

  Future<void> fetchTarifs(int idSousService) async {
    isLoading = true;
    notifyListeners();

    try {
      tarifs = await _api.fetchTarifsBySousService(idSousService);
    } catch (e) {
      tarifs = [];
    }

    isLoading = false;
    notifyListeners();
  }

  Future<String?> addTarif({
    required int idSousService,
    required int idDevise,
    required double montant,
  }) async {
    try {
      await _api.createTarif(
        idSousService: idSousService,
        idDevise: idDevise,
        montant: montant,
      );
      await fetchTarifs(idSousService);
      return null; // pas d'erreur
    } catch (e) {
      return e.toString(); // retourne le message d’erreur
    }
  }
}
