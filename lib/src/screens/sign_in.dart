import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../data/globals.dart';
import '../widgets/ui.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:modeinvestorclub/src/auth.dart';
import '../backend.dart';
import 'dart:html' as html;

class SignInScreen extends StatefulWidget {
  final String? initialEmail;

  const SignInScreen({this.initialEmail, super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _tokenController = TextEditingController();
  bool _isLoading = false;
  bool _tokenSpinner = false; // for token login else normal spinner
  bool _isForgotPassword = false;
  int _isPasswordSet =
      -1; // -1 = checking, 0 = not set, 1 = set, 2 = user not found, 3 = token log in (manually set below)
  String tokenLoginTitle = "YOU ARE INVITED";

  @override
  void initState() {
    super.initState();
    if (widget.initialEmail != null) {
      _isLoading = true;
      _tokenSpinner = true;
      _emailController.text = widget.initialEmail!;
      _checkPasswordSet(widget.initialEmail!);
    } else {
      _isPasswordSet = 1; // if not passed in we assume they can log in
    }
  }

  Future<void> _checkPasswordSet(String email) async {
    final backend = BackEnd();

    // Start a delayed future for 5 seconds
    final delay = Future.delayed(Duration(seconds: 5));

    // Make the backend call
    final result = await backend.checkPasswordSet(email);

    // Wait until both the backend call and the delay are complete
    await delay;

    setState(() {
      _isPasswordSet = result;
      if (_isPasswordSet == 1) {
        // If their password is set, we just show them a token login screen without the "you are invited" text
        _isPasswordSet = 0;
        tokenLoginTitle = "LOG IN WITH A TOKEN";
      }
      _isLoading = false;
    });
  }

  Future<void> _signIn() async {
    setState(() {
      _isLoading = true;
      _tokenSpinner = false;
    });

    final email = _emailController.value.text;
    final password = _passwordController.value.text;

    final auth = Provider.of<ModeAuth>(context, listen: false);
    bool success = await auth.signIn(email, password);

    setState(() {
      _isLoading = false;
    });

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login successful')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login failed')),
      );
    }
  }

  Future<void> _submitToken() async {
    setState(() {
      _isLoading = true;
      _tokenSpinner = false;
    });

    final email = _emailController.value.text;
    final token = _tokenController.value.text;

    final auth = Provider.of<ModeAuth>(context, listen: false);

    // Create a future that completes after 5 seconds
    final minLoadingTime = Future.delayed(const Duration(seconds: 5));

    // Validate the token submission
    final tokenSubmission = auth.validateTokenSubmission(email, token);

    // Wait for both the token submission and the minimum loading time to complete
    final results = await Future.wait([minLoadingTime, tokenSubmission]);

    // Get the result of the token submission
    bool success = results[1] as bool;

    setState(() {
      _isLoading = false;
    });

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Token validated')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid token')),
      );
    }
  }

  Future<void> _sendToken(String email) async {
    // Reload the current page with ?email=email at the end of the URL
    html.window.location.assign('/#/sign-in?email=$email');
    html.window.location.reload();
  }

  Widget _buildSignInForm() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Sign in',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        TextField(
          decoration: const InputDecoration(labelText: 'Email'),
          controller: _emailController,
        ),
        TextField(
          decoration: const InputDecoration(labelText: 'Password'),
          obscureText: true,
          controller: _passwordController,
        ),
        const SizedBox(height: 32),
        RoundedButton(
          text: "Sign in",
          icon: Icon(Icons.login, color: Colors.white),
          color: transparentButton,
          onPressed: _signIn,
        ),
        const SizedBox(height: 16),
        RichText(
          text: TextSpan(
            text: "Forgot your password? ",
            style: TextStyle(color: Colors.grey),
            children: [
              TextSpan(
                text: "Reset it",
                style: TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    setState(() {
                      _isForgotPassword = true;
                    });
                  },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildForgotPasswordForm() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Forgot Password',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        TextField(
          decoration: const InputDecoration(labelText: 'Enter your email'),
          controller: _emailController,
        ),
        const SizedBox(height: 32),
        RoundedButton(
          text: "Send Token",
          icon: Icon(Icons.send, color: Colors.white),
          color: transparentButton,
          onPressed: () => _sendToken(_emailController.text),
        ),
        const SizedBox(height: 16),
        TextButton(
          onPressed: () {
            setState(() {
              _isForgotPassword = false;
            });
          },
          child: const Text('Back to Sign In'),
        ),
      ],
    );
  }

  Widget _buildTokenEmailSpinner() {
    return SizedBox(
      height: 300,
      child: Column(
        children: [
          SvgPicture.asset(
            'images/mode_logo.svg', // Replace with your animation asset
            height: 100,
          ),
          const SizedBox(height: 20),
          const Text(
            'Sending your token via email...',
            style: TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 20),
          CircularProgressIndicator(),
        ],
      ),
    );
  }

  Widget _buildTokenForm() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          tokenLoginTitle,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        TextField(
          decoration: InputDecoration(
            labelText: 'Insert your token',
          ),
          controller: _tokenController,
        ),
        const SizedBox(height: 24),
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            text:
                "Didn't receive your token? Check your trash or Spam for ${_emailController.value.text}. \n",
            style: TextStyle(color: Colors.grey),
            children: [
              TextSpan(
                text: "Send it again",
                style: TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    // reloading this page will trigger the resend token logic
                    html.window.location.reload();
                  },
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
        RoundedButton(
          text: "Submit",
          icon: Icon(Icons.check, color: Colors.white),
          color: transparentButton,
          onPressed: _submitToken,
        ),
      ],
    );
  }

  Widget _buildUserNotFound() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'User not found',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 32),
        Text(
          "Account not created. Please email invest@modemobile.com for assistance.",
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'images/mode-investor-club-logo.svg',
                    height: 100,
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
                      child: _isLoading
                          ? (_tokenSpinner
                              ? _buildTokenEmailSpinner() // Custom spinner for token-related actions
                              : CircularProgressIndicator()) // Default spinner
                          : _isForgotPassword
                              ? _buildForgotPasswordForm()
                              : _isPasswordSet == 1
                                  ? _buildSignInForm()
                                  : _isPasswordSet == 0
                                      ? _buildTokenForm()
                                      : _buildUserNotFound(),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    "Mode Investor Club is currently in beta launch.\nIf you received an invitation via email, please use those credentials to log in.",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 32),
                  TextButton(
                    onPressed: () {
                      html.window.location.assign('/#/home');
                      html.window.location.reload();
                    },
                    child: const Text('Go Home'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}
