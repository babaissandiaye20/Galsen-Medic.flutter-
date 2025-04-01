import 'dart:io';
import 'package:http/http.dart' as http;
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

  Future<SousServiceModel> createSousService({
    required String libelle,
    required int idService,
    File? icon,
  }) async {
    final fields = {'libelle': libelle, 'idService': idService.toString()};

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
      endpoint: '/sous-services',
      fields: fields,
      files: files,
    );

    return SousServiceModel.fromJson(response['data']);
  }
}
