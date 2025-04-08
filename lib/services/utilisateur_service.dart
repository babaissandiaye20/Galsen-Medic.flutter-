import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:galsen_medic/models/utilisateur.dart';
import 'package:galsen_medic/services/api_service.dart';

class UtilisateurService {
  final ApiService _apiService = ApiService();

  Future<List<Utilisateur>> getClients() async {
    final response = await _apiService.get('/utilisateur/Clients');
    final List<dynamic> data = response['data'];
    return data.map((json) => Utilisateur.fromJson(json)).toList();
  }

  Future<List<Utilisateur>> getUsersWithoutAdminAndClient() async {
    final response = await _apiService.get('/utilisateur/non-clients');
    final List<dynamic> data = response['data'];
    return data.map((json) => Utilisateur.fromJson(json)).toList();
  }

  /// 🔥 Nouvelle méthode pour créer un utilisateur
  Future<Utilisateur> createUtilisateur({
    required String nom,
    required String prenom,
    required String email,
    required String telephone,
    required String password,
    required int idPrivilege,
    File? image,
  }) async {
    final fields = {
      'nom': nom,
      'prenom': prenom,
      'email': email,
      'telephone': telephone,
      'password': password,
      'idPrivilege': idPrivilege.toString(),
    };

    final files = <http.MultipartFile>[];

    if (image != null) {
      final fileName = image.path.split('/').last;
      files.add(
        await http.MultipartFile.fromPath(
          'profilUrl',
          image.path,
          filename: fileName,
        ),
      );
    }

    final response = await _apiService.multipartPost(
      endpoint: '/utilisateur',
      fields: fields,
      files: files,
    );

    return Utilisateur.fromJson(response['data']);
  }

  /// 🔥 Nouvelle méthode pour récupérer les privilèges
  Future<List<Map<String, dynamic>>> getPrivileges() async {
    final response = await _apiService.get('/privileges');
    return List<Map<String, dynamic>>.from(response['data']);
  }
  Future<Utilisateur> getUtilisateurByEmail(String email) async {
    final response = await _apiService.get('/utilisateur/email/$email');
    return Utilisateur.fromJson(response['data']);
  }

}
