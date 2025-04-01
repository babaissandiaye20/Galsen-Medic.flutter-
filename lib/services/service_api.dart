import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:galsen_medic/models/service_model.dart';
import 'package:galsen_medic/services/api_service.dart';

class ServiceApi {
  final ApiService _apiService = ApiService();

  Future<List<ServiceModel>> fetchServices() async {
    final response = await _apiService.get('/services');
    final data = response['data'] as List;
    return data.map((item) => ServiceModel.fromJson(item)).toList();
  }

  Future<ServiceModel> createService({
    required String libelle,
    File? icon,
  }) async {
    final fields = {'libelle': libelle};
    final files = <http.MultipartFile>[];

    if (icon != null) {
      final fileName = icon.path.split('/').last;
      files.add(
        await http.MultipartFile.fromPath(
          'iconUrl',
          icon.path,
          filename: fileName,
        ),
      );
    }

    final response = await _apiService.multipartPost(
      endpoint: '/services',
      fields: fields,
      files: files,
    );

    return ServiceModel.fromJson(response['data']);
  }
}
