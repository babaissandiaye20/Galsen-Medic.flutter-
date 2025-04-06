import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/devise_model.dart';

class DeviseService {
  final String baseUrl;

  DeviseService({required this.baseUrl});

  Future<List<DeviseModel>> fetchDevises() async {
    final url = Uri.parse('$baseUrl/devises');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body)['data'];
      return data.map((e) => DeviseModel.fromJson(e)).toList();
    } else {
      throw Exception('Erreur de chargement des devises');
    }
  }
}
