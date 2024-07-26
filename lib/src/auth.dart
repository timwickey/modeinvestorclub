import 'package:flutter/widgets.dart';
import 'package:modeinvestorclub/src/backend.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ModeAuth extends ChangeNotifier {
  bool _signedIn = false;
  ApiResponse? _user;

  bool get signedIn => _signedIn;
  ApiResponse? get user => _user;

  Future<void> signOut() async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    _signedIn = false;
    _user = null;
    notifyListeners();
  }

  Future<bool> signIn(String email, String password) async {
    String url = 'https://nodejs-serverless-connector.vercel.app/api/login';
    Map<String, String> body = {'email': email, 'password': password};

    ApiResult<ApiResponse> result =
        await asyncCallApiData(url, method: 'POST', body: body);

    if (result.data != null) {
      _signedIn = true;
      _user = result.data;
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

class ApiResult<T> {
  final T? data;
  final String? error;

  ApiResult({this.data, this.error});
}

Future<ApiResult<ApiResponse>> asyncCallApiData(String endpointUrl,
    {String method = 'GET', Map<String, String>? body}) async {
  if (endpointUrl.isEmpty) {
    return ApiResult(error: 'Endpoint URL must be a non-empty string.');
  }

  if (method != 'GET' && method != 'POST') {
    return ApiResult(error: 'Method must be either "GET" or "POST".');
  }

  Uri uri = Uri.parse(endpointUrl);
  final client = http.Client();
  http.Response response;

  try {
    if (method == 'GET') {
      response = await client.get(uri);
    } else {
      response = await client.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );
    }

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = json.decode(response.body);

      ApiResponse data = ApiResponse.fromJson(jsonResponse);

      return ApiResult(data: data);
    } else {
      String errorBody = response.body;
      return ApiResult(
          error:
              'Failed to load data: ${response.reasonPhrase}. Error body: $errorBody');
    }
  } catch (e) {
    return ApiResult(error: 'Failed to load data: $e');
  } finally {
    client.close();
  }
}
