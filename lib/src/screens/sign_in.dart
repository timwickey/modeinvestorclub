import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../data/globals.dart';
import '../widgets/ui.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Credentials {
  final String email;
  final String password;

  Credentials(this.email, this.password);
}

class SignInScreen extends StatefulWidget {
  final ValueChanged<Credentials> onSignIn;

  const SignInScreen({
    required this.onSignIn,
    super.key,
  });

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false; // To track the loading state

  Future<void> _signIn() async {
    setState(() {
      _isLoading = true;
    });

    final email = _emailController.value.text;
    final password = _passwordController.value.text;

    String url = 'https://nodejs-serverless-connector.vercel.app/api/login';
    // Map<String, String> body = {'email': email, 'password': password};
    // Map<String, String> body = {
    //   'email': 'tim.wickey@modemobile.com',
    //   'password': 'ilovet'
    // };
    Map<String, String> body = {'email': email, 'password': password};
    ApiResult<ApiResponse> result =
        await asyncCallApiData(url, method: 'POST', body: body);

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    if (result.data != null) {
      // Handle successful response
      ApiResponse data = result.data!;
      print('Login successful. Token: ${data.token}');
      print('User ID: ${data.id}');
      print('First Name: ${data.firstName}');
      print('Last Name: ${data.lastName}');
      print('Email: ${data.email}');

      // Call the onSignIn callback with the credentials
      widget.onSignIn(Credentials(email, password));
      // Handle success (e.g., navigate to another screen, show success message, etc.)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login successful')),
      );
    } else {
      // Handle error
      String error = result.error!;
      // Handle error (e.g., show error message)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login failed: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'images/mode-investor-club-logo.svg',
                  height: 100, // Adjust the height as needed
                ),
                const SizedBox(height: 32),
                Container(
                  constraints: BoxConstraints.loose(const Size(600, 600)),
                  child: Text(
                    "Welcome to the Mode Investor Club Portal! Discover exclusive events, special deals, and real-time investment tracking all in one place.",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
                const SizedBox(height: 32),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    side: BorderSide(
                      color: borderColor,
                      width: borderThickness,
                    ),
                  ),
                  child: Container(
                    constraints: BoxConstraints.loose(const Size(600, 600)),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Sign in',
                            style: Theme.of(context).textTheme.headlineMedium),
                        TextField(
                          decoration: const InputDecoration(labelText: 'Email'),
                          controller: _emailController,
                        ),
                        TextField(
                          decoration:
                              const InputDecoration(labelText: 'Password'),
                          obscureText: true,
                          controller: _passwordController,
                        ),
                        const SizedBox(height: 32),
                        _isLoading
                            ? CircularProgressIndicator()
                            : RoundedButton(
                                text: "Sign in",
                                icon: Icon(Icons.login, color: Colors.white),
                                color: transparentButton,
                                onPressed: _signIn, // Call the _signIn method
                              ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                Text(
                    "Mode Investor Club is currently in beta launch.\nIf you received an invitation via email, please use those credentials to log in.",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ),
        ),
      );
}

class ApiResponse {
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final String message;
  final String token;
  // create a list of investments
  List<dynamic> investments = [];

  ApiResponse({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.message,
    required this.token,
    required this.investments,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      id: json['user']['id'],
      firstName: json['user']['firstname'],
      lastName: json['user']['lastname'],
      email: json['user']['email'],
      message: json['message'],
      token: json['token'],
      investments: json['investments'],
    );
  }
}

class ApiResult<T> {
  final T? data;
  final String? error;

  ApiResult({this.data, this.error});
}

Future<ApiResult<ApiResponse>> asyncCallApiData(String endpointUrl,
    {String method = 'GET', Map<String, String>? body}) async {
  // Ensure endpointUrl is a valid String
  if (endpointUrl.isEmpty) {
    return ApiResult(error: 'Endpoint URL must be a non-empty string.');
  }

  // Ensure method is either 'GET' or 'POST'
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

      return ApiResult(data: data); // Return the parsed data
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
