import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:http_parser/http_parser.dart';
import 'package:galsen_medic/services/api_service.dart';

class RegisterClientService {
  static Future<http.Response> register({
    required String nom,
    required String prenom,
    required String email,
    required String password,
    required String telephone,
    File? image,
  }) async {
    final api = ApiService();
    final url = Uri.parse("${api.baseUrl}/utilisateur");

    var request = http.MultipartRequest('POST', url);

    request.fields['nom'] = nom;
    request.fields['prenom'] = prenom;
    request.fields['email'] = email;
    request.fields['password'] = password;
    request.fields['telephone'] = telephone;

    if (image != null) {
      final ext = extension(image.path).toLowerCase();
      final fileSize = await image.length();

      if (!['.jpg', '.jpeg', '.png', '.webp'].contains(ext)) {
        throw Exception(
          "Format d'image non supporté (jpg, png, webp seulement).",
        );
      }

      if (fileSize > 3 * 1024 * 1024) {
        throw Exception("L'image dépasse 3 Mo.");
      }

      request.files.add(
        await http.MultipartFile.fromPath(
          'profilUrl',
          image.path,
          filename: basename(image.path),
          contentType: MediaType('image', ext.replaceAll('.', '')),
        ),
      );
    }

    final streamed = await request.send();
    return await http.Response.fromStream(streamed);
  }
}
