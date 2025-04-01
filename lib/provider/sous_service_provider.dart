import 'package:flutter/material.dart';
import 'package:galsen_medic/models/sous_service_model.dart';
import 'package:galsen_medic/services/sous_service_api.dart';

class SousServiceProvider with ChangeNotifier {
  final SousServiceApi _api = SousServiceApi();

  List<SousServiceModel> sousServices = [];
  bool isLoading = false;

  Future<void> fetchSousServices(int serviceId) async {
    isLoading = true;
    notifyListeners();

    try {
      sousServices = await _api.fetchSousServices(serviceId);
    } catch (e) {
      sousServices = [];
    }

    isLoading = false;
    notifyListeners();
  }

  void addSousService(SousServiceModel sousService) {
    sousServices.insert(0, sousService);
    notifyListeners();
  }
}
