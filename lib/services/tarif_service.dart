import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:galsen_medic/models/tarif_model.dart';

class TarifService {
  final String baseUrl;

  TarifService({required this.baseUrl});

  Future<List<TarifModel>> fetchTarifsBySousService(int idSousService) async {
    final url = Uri.parse('$baseUrl/tarifs/sous-service/$idSousService/full');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List body = jsonDecode(response.body)['data'];
      return body.map((json) => TarifModel.fromJson(json)).toList();
    } else {
      throw Exception('Erreur de chargement des tarifs');
    }
  }

  Future<void> activateTarif(int id) async {
    final url = Uri.parse('$baseUrl/tarifs/$id/activate');
    final response = await http.patch(url);
    if (response.statusCode != 200) {
      throw Exception('Impossible d\'activer le tarif');
    }
  }

  Future<void> deactivateTarif(int id) async {
    final url = Uri.parse('$baseUrl/tarifs/$id/deactivate');
    final response = await http.patch(url);
    if (response.statusCode != 200) {
      throw Exception('Impossible de désactiver le tarif');
    }
  }
  Future<void> createTarif({
    required int idSousService,
    required int idDevise,
    required double montant,
    bool actif = true,
  }) async {
    final url = Uri.parse('$baseUrl/tarifs');
    final body = jsonEncode({
      'idSousService': idSousService,
      'idDevise': idDevise,
      'montant': montant,
      'actif': actif,
    });

    final headers = {'Content-Type': 'application/json'};

    final response = await http.post(url, body: body, headers: headers);

    if (response.statusCode == 201) return;

    final responseData = jsonDecode(response.body);
    final message = responseData['message'] ?? 'Erreur inconnue lors de la création du tarif';
    throw Exception(message is List ? message.join(', ') : message);
  }

}
