import 'package:galsen_medic/models/service_model.dart';
import 'package:galsen_medic/services/api_service.dart';

class ServiceApi {
  final ApiService _apiService = ApiService();

  Future<List<ServiceModel>> fetchServices() async {
    final response = await _apiService.get('/services');
    final data = response['data'] as List;
    return data.map((item) => ServiceModel.fromJson(item)).toList();
  }
}
