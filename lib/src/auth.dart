import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'backend.dart';
import '../src/data/globals.dart';

class ModeAuth extends ChangeNotifier {
  bool _signedIn = false;
  ApiResponse? _user;

  bool get signedIn => _signedIn;
  ApiResponse? get user => _user;

  ModeAuth() {
    _loadUserFromPrefs();
  }

  Future<void> _loadUserFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    if (token != null) {
      bool isValid = await _validateToken(token);
      if (isValid) {
        notifyListeners();
      } else {
        await _removeUserFromPrefs();
      }
    }
  }

  Future<bool> _validateToken(String token) async {
    String url = '${ApiUrl}/validate_auth_token';
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'token': token}),
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      _user = ApiResponse.fromJson(jsonResponse);
      _signedIn = true;
      return true;
    } else {
      return false;
    }
  }

  Future<void> _saveUserToPrefs(String token) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('auth_token', token);
  }

  Future<void> _removeUserFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('auth_token');
  }

  Future<void> signOut() async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    _signedIn = false;
    _user = null;
    await _removeUserFromPrefs();
    notifyListeners();
  }

  Future<bool> signIn(String email, String password) async {
    final backend = BackEnd();
    String url = '${ApiUrl}/login';
    Map<String, String> body = {'email': email, 'password': password};

    ApiResult<ApiResponse> result =
        await backend.asyncCallApiData(url, method: 'POST', body: body);

    if (result.data != null) {
      _signedIn = true;
      _user = result.data;
      await _saveUserToPrefs(_user!.token);
      notifyListeners();
      return true;
    } else {
      return false;
    }
  }

  @override
  bool operator ==(Object other) =>
      other is ModeAuth && other._signedIn == _signedIn;

  @override
  int get hashCode => _signedIn.hashCode;

  static ModeAuth of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<ModeAuthScope>()!.notifier!;
}

class ModeAuthScope extends InheritedNotifier<ModeAuth> {
  const ModeAuthScope({
    required super.notifier,
    required super.child,
    super.key,
  });
}
