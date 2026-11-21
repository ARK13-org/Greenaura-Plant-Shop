import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:http_parser/http_parser.dart';
import 'package:pant_app/models/plant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiConfig {
  static const String host = String.fromEnvironment(
    'API_HOST',
    defaultValue: '127.0.0.1:8000',
  );
  static String get baseUrl => 'http://$host';
  static Uri uri(String path, [Map<String, String>? query]) =>
      Uri.http(host, path, query);
}

class PlantApi {
  static final http.Client _client = http.Client();
  static const _tokenKey = 'greenaura_access_token';
  static String? _token;
  static Map<String, dynamic>? currentUser;
  static bool get isAuthenticated => _token != null && _token!.isNotEmpty;

  static Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString(_tokenKey);
    if (_token != null) {
      try {
        currentUser = await getMe();
        await refreshFavorites();
      } catch (_) {
        await logout();
      }
    }
  }

  static Map<String, String> _headers({bool authenticated = false}) {
    final headers = <String, String>{'Accept': 'application/json'};
    if (authenticated && isAuthenticated) {
      headers['Authorization'] = 'Bearer $_token';
    }
    return headers;
  }

  static Future<List<Plant>> fetchPlants({
    int? categoryId,
    String? search,
  }) async {
    final query = <String, String>{};
    if (categoryId != null) query['category_id'] = '$categoryId';
    if (search != null && search.trim().isNotEmpty)
      query['search'] = search.trim();
    final response = await _client
        .get(
          ApiConfig.uri('plants/', query.isEmpty ? null : query),
          headers: _headers(),
        )
        .timeout(const Duration(seconds: 15));
    _check(response, 'Could not load plants');
    final decoded = jsonDecode(utf8.decode(response.bodyBytes));
    if (decoded is! List)
      throw const ApiException(
        'The plants endpoint returned an invalid response.',
      );
    final plants = decoded
        .map(
          (item) => Plant.fromJson(
            Map<String, dynamic>.from(item as Map),
            baseUrl: ApiConfig.baseUrl,
          ),
        )
        .toList();
    return plants;
  }

  static Future<Plant> fetchPlantById(int plantId) async {
    final response = await _client
        .get(ApiConfig.uri('plants/$plantId'), headers: _headers())
        .timeout(const Duration(seconds: 15));
    _check(response, 'Could not load plant details');
    return Plant.fromJson(
      Map<String, dynamic>.from(jsonDecode(utf8.decode(response.bodyBytes))),
      baseUrl: ApiConfig.baseUrl,
    );
  }

  static Future<List<Map<String, dynamic>>> fetchCategories() async {
    final response = await _client
        .get(ApiConfig.uri('category'), headers: _headers())
        .timeout(const Duration(seconds: 15));
    _check(response, 'Could not load categories');
    final decoded = jsonDecode(utf8.decode(response.bodyBytes));
    if (decoded is! List) return [];
    return decoded
        .map((item) => Map<String, dynamic>.from(item as Map))
        .toList();
  }

  static Future<Map<String, dynamic>> register({
    required String username,
    required String name,
    required String lastName,
    required String phoneNumber,
    required String email,
    required String password,
  }) async {
    final response = await _client
        .post(
          ApiConfig.uri('user'),
          headers: const {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            'username': username,
            'name': name,
            'last_name': lastName,
            'phone_number': phoneNumber,
            'email': email,
            'password': password,
          }),
        )
        .timeout(const Duration(seconds: 15));
    _check(response, 'Registration failed');
    return Map<String, dynamic>.from(
      jsonDecode(utf8.decode(response.bodyBytes)),
    );
  }

  static Future<Map<String, dynamic>> login(
    String username,
    String password,
  ) async {
    final response = await _client
        .post(
          ApiConfig.uri('auth/login'),
          headers: const {
            'Accept': 'application/json',
            'Content-Type': 'application/x-www-form-urlencoded',
          },
          body: {'username': username, 'password': password},
        )
        .timeout(const Duration(seconds: 15));
    _check(response, 'Login failed');
    final data = Map<String, dynamic>.from(
      jsonDecode(utf8.decode(response.bodyBytes)),
    );
    _token = data['access_token']?.toString();
    if (!isAuthenticated)
      throw const ApiException('The server did not return an access token.');
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, _token!);
    currentUser = await getMe();
    await refreshFavorites();
    return currentUser!;
  }

  static Future<Map<String, dynamic>> getMe() async {
    final response = await _client
        .get(ApiConfig.uri('auth/me'), headers: _headers(authenticated: true))
        .timeout(const Duration(seconds: 15));
    _check(response, 'Could not load your profile');
    currentUser = Map<String, dynamic>.from(
      jsonDecode(utf8.decode(response.bodyBytes)),
    );
    return currentUser!;
  }

  static Future<Map<String, dynamic>> uploadProfilePicture(XFile image) async {
    if (!isAuthenticated) {
      throw const ApiException(
        'Please sign in before uploading a profile picture.',
      );
    }

    // The existing FastAPI route is PUT /user/{user_id}/profile-picture.
    final userId = currentUser?['id'];
    if (userId == null) {
      await getMe();
    }
    final resolvedUserId = currentUser?['id'];
    if (resolvedUserId == null) {
      throw const ApiException(
        'Could not identify the signed-in user. Please sign in again.',
      );
    }

    final bytes = await image.readAsBytes();
    if (bytes.isEmpty) {
      throw const ApiException('The selected image is empty.');
    }
    if (bytes.length > 5 * 1024 * 1024) {
      throw const ApiException('Please choose an image smaller than 5 MB.');
    }

    final request = http.MultipartRequest(
      'PUT',
      ApiConfig.uri('user/$resolvedUserId/profile-picture'),
    );
    request.headers.addAll(_headers(authenticated: true));
    final extension = image.name.split('.').last.toLowerCase();
    final mimeSubtype = switch (extension) {
      'jpg' || 'jpeg' => 'jpeg',
      'png' => 'png',
      'webp' => 'webp',
      _ => null,
    };
    if (mimeSubtype == null) {
      throw const ApiException('Choose a JPG, PNG or WEBP image.');
    }

    request.files.add(
      http.MultipartFile.fromBytes(
        'file',
        bytes,
        filename: image.name,
        contentType: MediaType('image', mimeSubtype),
      ),
    );

    final streamedResponse = await request.send().timeout(
      const Duration(seconds: 30),
    );
    final response = await http.Response.fromStream(streamedResponse);
    _check(response, 'Could not upload your profile picture');
    currentUser = Map<String, dynamic>.from(
      jsonDecode(utf8.decode(response.bodyBytes)),
    );
    return currentUser!;
  }

  static Future<void> logout() async {
    _token = null;
    currentUser = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    Plant.favoritePlantIds.clear();
    for (final plant in Plant.plantList) {
      plant.isFavorated = false;
    }
  }

  static Future<Map<String, dynamic>> updateProfile({
    String? name,
    String? lastName,
    String? phoneNumber,
    String? email,
  }) async {
    if (!isAuthenticated) throw const ApiException('Please sign in first.');
    final changes = <String, dynamic>{};
    if (name != null) changes['name'] = name;
    if (lastName != null) changes['last_name'] = lastName;
    if (phoneNumber != null) changes['phone_number'] = phoneNumber;
    if (email != null) changes['email'] = email;
    final response = await _client
        .patch(
          ApiConfig.uri('user/me'),
          headers: {
            ..._headers(authenticated: true),
            'Content-Type': 'application/json',
          },
          body: jsonEncode(changes),
        )
        .timeout(const Duration(seconds: 15));
    _check(response, 'Could not update your profile');
    currentUser = Map<String, dynamic>.from(
      jsonDecode(utf8.decode(response.bodyBytes)),
    );
    return currentUser!;
  }

  static Future<List<Plant>> refreshFavorites() async {
    if (!isAuthenticated) return [];
    final response = await _client
        .get(
          ApiConfig.uri('user/me/favorites'),
          headers: _headers(authenticated: true),
        )
        .timeout(const Duration(seconds: 15));
    _check(response, 'Could not load favorites');
    final decoded = jsonDecode(utf8.decode(response.bodyBytes));
    if (decoded is! List) return [];
    final favorites = decoded
        .map(
          (item) => Plant.fromJson(
            Map<String, dynamic>.from(item as Map),
            baseUrl: ApiConfig.baseUrl,
          ),
        )
        .toList();
    final ids = favorites.map((plant) => plant.plantId).toSet();
    Plant.favoritePlantIds = ids;
    for (final plant in Plant.plantList) {
      plant.isFavorated = ids.contains(plant.plantId);
    }
    return favorites;
  }

  static Future<void> setFavorite(int plantId, bool isFavorite) async {
    if (!isAuthenticated)
      throw const ApiException('Please sign in to save your favorites.');
    final response = await _client
        .put(
          ApiConfig.uri('plants/$plantId/favorite'),
          headers: {
            ..._headers(authenticated: true),
            'Content-Type': 'application/json',
          },
          body: jsonEncode({'is_favorite': isFavorite}),
        )
        .timeout(const Duration(seconds: 15));
    _check(response, 'Could not update favorite');
    if (isFavorite) {
      Plant.favoritePlantIds.add(plantId);
    } else {
      Plant.favoritePlantIds.remove(plantId);
    }
    for (final plant in Plant.plantList) {
      if (plant.plantId == plantId) plant.isFavorated = isFavorite;
    }
  }

  static void _check(http.Response response, String context) {
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ApiException(
        '$context (${response.statusCode}): ${_errorMessage(response)}',
      );
    }
  }

  static String _errorMessage(http.Response response) {
    try {
      final body = jsonDecode(utf8.decode(response.bodyBytes));
      if (body is Map && body['detail'] != null)
        return body['detail'].toString();
    } catch (_) {}
    return response.reasonPhrase ?? 'Unknown server error';
  }
}

class ApiException implements Exception {
  final String message;
  const ApiException(this.message);
  @override
  String toString() => message;
}
