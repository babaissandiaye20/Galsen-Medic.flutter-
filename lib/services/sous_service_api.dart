import 'package:galsen_medic/models/sous_service_model.dart';
import 'package:galsen_medic/services/api_service.dart';

class SousServiceApi {
  final ApiService _apiService = ApiService();

  Future<List<SousServiceModel>> fetchSousServices(int serviceId) async {
    final response = await _apiService.get(
      '/sous-services/by-service/$serviceId',
    );
    final data = response['data'] as List;
    return data.map((item) => SousServiceModel.fromJson(item)).toList();
  }
}
