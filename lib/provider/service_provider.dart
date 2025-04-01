import 'package:flutter/material.dart';
import 'package:galsen_medic/models/service_model.dart';
import 'package:galsen_medic/services/service_api.dart';

class ServiceProvider with ChangeNotifier {
  final ServiceApi _api = ServiceApi();

  List<ServiceModel> services = [];
  bool isLoading = false;

  Future<void> fetchServices() async {
    isLoading = true;
    notifyListeners();

    try {
      services = await _api.fetchServices();
    } catch (e) {
      services = [];
    }

    isLoading = false;
    notifyListeners();
  }

  void addService(ServiceModel service) {
    services.insert(0, service);
    notifyListeners();
  }
}
