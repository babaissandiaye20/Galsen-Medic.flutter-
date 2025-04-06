import 'package:galsen_medic/models/disponibilite_model.dart';
import 'package:galsen_medic/services/api_service.dart';

class DisponibiliteService {
  final ApiService _apiService = ApiService();

  /// 🔁 Récupérer toutes les disponibilités actives d’un médecin
  Future<List<Disponibilite>> getDisponibilitesByMedecin(int idMedecin) async {
    final response = await _apiService.get('/disponibilites/medecin/$idMedecin');

    if (response['data'] == null) {
      return [];
    }

    final List<dynamic> data = response['data'];

    return data.map((item) => Disponibilite.fromJson(item)).toList();
  }

  /// ✅ Récupérer une disponibilité avec ses créneaux disponibles (via ID)
  Future<Disponibilite> getDisponibiliteById(int id) async {
    final response = await _apiService.get('/disponibilites/$id');

    return Disponibilite.fromJson(response['data']);
  }
}
