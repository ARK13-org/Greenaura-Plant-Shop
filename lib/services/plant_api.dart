import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pant_app/models/plant.dart';

class ApiConfig {
  static const String host = String.fromEnvironment(
    'API_HOST',
    defaultValue: '127.0.0.1:8000',
  );

  static String get baseUrl => 'http://$host';

  static Uri uri(String path, [Map<String, String>? query]) {
    return Uri.http(host, path, query);
  }
}

class PlantApi {
  static final http.Client _client = http.Client();

  static Future<List<Plant>> fetchPlants() async {
    final uri = ApiConfig.uri('plants/');
    final response = await _client
        .get(uri, headers: const {'Accept': 'application/json'})
        .timeout(const Duration(seconds: 15));

    if (response.statusCode != 200) {
      throw ApiException(
        'Could not load plants (${response.statusCode}): ${_errorMessage(response)}',
      );
    }

    final decoded = jsonDecode(utf8.decode(response.bodyBytes));
    if (decoded is! List) {
      throw const ApiException(
        'The plants endpoint returned an invalid response.',
      );
    }

    return decoded
        .map(
          (item) => Plant.fromJson(
            Map<String, dynamic>.from(item as Map),
            baseUrl: ApiConfig.baseUrl,
          ),
        )
        .toList();
  }

  static Future<List<Map<String, dynamic>>> fetchCategories() async {
    final response = await _client
        .get(
          ApiConfig.uri('category'),
          headers: const {'Accept': 'application/json'},
        )
        .timeout(const Duration(seconds: 15));

    if (response.statusCode != 200) {
      throw ApiException(
        'Could not load categories (${response.statusCode}): ${_errorMessage(response)}',
      );
    }

    final decoded = jsonDecode(utf8.decode(response.bodyBytes));
    if (decoded is! List) return [];
    return decoded
        .map((item) => Map<String, dynamic>.from(item as Map))
        .toList();
  }

  static String _errorMessage(http.Response response) {
    try {
      final body = jsonDecode(utf8.decode(response.bodyBytes));
      if (body is Map && body['detail'] != null) {
        return body['detail'].toString();
      }
    } catch (_) {
      // Keep the status code as the useful error when the body is not JSON.
    }
    return response.reasonPhrase ?? 'Unknown server error';
  }
}

class ApiException implements Exception {
  final String message;
  const ApiException(this.message);

  @override
  String toString() => message;
}
