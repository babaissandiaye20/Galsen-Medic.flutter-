import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:galsen_medic/services/api_service.dart';
import 'package:galsen_medic/models/auth_model.dart';

class AuthService {
  final ApiService _apiService = ApiService();

  Future<bool> login(AuthModel authModel) async {
    try {
      final response = await _apiService.post(
        '/auth/login',
        authModel.toJson(),
        withAuth: false,
      );

      final token = response['data']['access_token'];

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);

      return true;
    } catch (e) {
      print('Login failed: $e');
      return false;
    }
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }

  Map<String, dynamic> decodeJwtPayload(String token) {
    final parts = token.split('.');
    if (parts.length != 3) {
      throw Exception('Token JWT invalide');
    }

    final payload = parts[1];
    final normalized = base64.normalize(payload);
    final decoded = utf8.decode(base64Url.decode(normalized));
    return json.decode(decoded);
  }
}
