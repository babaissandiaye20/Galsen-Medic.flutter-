import 'package:galsen_medic/models/utilisateur.dart';
import 'package:galsen_medic/services/api_service.dart';

class UtilisateurService {
  final ApiService _apiService = ApiService();

  Future<List<Utilisateur>> getClients() async {
    final response = await _apiService.get('/utilisateur/clients');
    final List<dynamic> data = response['data'];
    return data.map((json) => Utilisateur.fromJson(json)).toList();
  }

  Future<List<Utilisateur>> getUsersWithoutAdminAndClient() async {
    final response = await _apiService.get('/utilisateur/non-clients');
    final List<dynamic> data = response['data'];
    return data.map((json) => Utilisateur.fromJson(json)).toList();
  }
}
