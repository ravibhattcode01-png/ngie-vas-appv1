import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/api_client.dart';

class AuthProvider extends ChangeNotifier {
  final _api = ApiClient.instance;
  AppUser? _user;
  bool _loading = true;

  AppUser? get user => _user;
  bool get loading => _loading;
  bool get isLoggedIn => _user != null;

  /// Called at startup — restores session from a stored token.
  Future<void> bootstrap() async {
    await _api.loadToken();
    if (_api.hasToken) {
      try {
        final data = await _api.get('me');
        _user = AppUser.fromJson(data['user']);
      } catch (_) {
        await _api.clearToken();
      }
    }
    _loading = false;
    notifyListeners();
  }

  Future<void> login(String email, String password) async {
    final data = await _api.post('login', {
      'email': email,
      'password': password,
      'device_name': 'android',
    });
    await _api.setToken(data['token']);
    _user = AppUser.fromJson(data['user']);
    notifyListeners();
  }

  Future<void> register(Map<String, dynamic> body) async {
    final data = await _api.post('register', body);
    await _api.setToken(data['token']);
    _user = AppUser.fromJson(data['user']);
    notifyListeners();
  }

  Future<void> refresh() async {
    final data = await _api.get('me');
    _user = AppUser.fromJson(data['user']);
    notifyListeners();
  }

  Future<void> logout() async {
    try {
      await _api.post('logout', {});
    } catch (_) {}
    await _api.clearToken();
    _user = null;
    notifyListeners();
  }
}
