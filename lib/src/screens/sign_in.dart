import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../backend.dart';

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

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Center(
          child: Card(
            child: Container(
              constraints: BoxConstraints.loose(const Size(600, 600)),
              padding: const EdgeInsets.all(8),
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
                    decoration: const InputDecoration(labelText: 'Password'),
                    obscureText: true,
                    controller: _passwordController,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: TextButton(
                      onPressed: _signIn,
                      child: const Text('Sign in'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

  Future<void> _signIn() async {
    // _apiResponse = asyncCallApiData(
    //     'https://nodejs-serverless-connector.vercel.app/api/hello');
    final email = _emailController.value.text;
    final password = _passwordController.value.text;

    String url = 'https://nodejs-serverless-connector.vercel.app/api/login';
    Map<String, String> body = {'email': email, 'password': password};
    ApiResult<ApiResponse> result =
        await asyncCallApiData(url, method: 'POST', body: body);

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
        SnackBar(content: Text('Login successful')),
      );
    } else {
      // Handle error
      String error = result.error!;
      print('Error: $error');
      // Handle error (e.g., show error message)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login failed')),
      );
    }
  }
}
