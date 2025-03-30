import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:galsen_medic/config/env.dart';

class ApiService {
  final String baseUrl = Env.apiBaseUrl;

  /// GET request
  Future<dynamic> get(String endpoint) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final response = await http.get(url);
    return _handleResponse(response);
  }

  /// POST request
  Future<dynamic> post(String endpoint, Map<String, dynamic> body) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );
    return _handleResponse(response);
  }

  /// PUT request
  Future<dynamic> put(String endpoint, Map<String, dynamic> body) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );
    return _handleResponse(response);
  }

  /// PATCH request
  Future<dynamic> patch(String endpoint, Map<String, dynamic> body) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final response = await http.patch(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );
    return _handleResponse(response);
  }

  /// DELETE request
  Future<dynamic> delete(String endpoint) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final response = await http.delete(url);
    return _handleResponse(response);
  }

  /// Test API connectivity
  Future<bool> ping() async {
    try {
      final url = Uri.parse('$baseUrl/ping');
      final response = await http.get(url);
      return response.statusCode == 200;
    } catch (e) {
      print('Ping failed: $e');
      return false;
    }
  }

  /// Common response handler
  dynamic _handleResponse(http.Response response) {
    final statusCode = response.statusCode;
    final body = response.body;

    if (statusCode >= 200 && statusCode < 300) {
      return jsonDecode(body);
    } else {
      throw Exception('Request failed: $statusCode → $body');
    }
  }
}
