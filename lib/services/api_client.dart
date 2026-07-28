import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;
  ApiException(this.message, [this.statusCode]);
  @override
  String toString() => message;
}

class ApiClient {
  static final ApiClient instance = ApiClient._();
  ApiClient._();

  String? _token;

  Future<void> loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('auth_token');
  }

  Future<void> setToken(String token) async {
    _token = token;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  Future<void> clearToken() async {
    _token = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }

  bool get hasToken => _token != null;

  Map<String, String> get _headers => {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        if (_token != null) 'Authorization': 'Bearer $_token',
      };

  Uri _uri(String path) => Uri.parse('${AppConfig.apiBaseUrl}/$path');

  Future<dynamic> get(String path) async {
    final res = await http.get(_uri(path), headers: _headers);
    return _handle(res);
  }

  Future<dynamic> post(String path, Map<String, dynamic> body) async {
    final res = await http.post(_uri(path), headers: _headers, body: jsonEncode(body));
    return _handle(res);
  }

  dynamic _handle(http.Response res) {
    final decoded = res.body.isNotEmpty ? jsonDecode(res.body) : null;
    if (res.statusCode >= 200 && res.statusCode < 300) {
      return decoded;
    }
    String msg = 'Something went wrong.';
    if (decoded is Map) {
      if (decoded['message'] != null) msg = decoded['message'].toString();
      if (decoded['errors'] is Map && (decoded['errors'] as Map).isNotEmpty) {
        final first = (decoded['errors'] as Map).values.first;
        if (first is List && first.isNotEmpty) msg = first.first.toString();
      }
    }
    throw ApiException(msg, res.statusCode);
  }
}
