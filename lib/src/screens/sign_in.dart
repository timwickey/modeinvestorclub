import 'package:flutter/material.dart';
import '../data/globals.dart';
import '../widgets/ui.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:modeinvestorclub/src/auth.dart';
import '../backend.dart';

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
  int _isPasswordSet =
      -1; // -1 = checking, 0 = not set, 1 = set, 2 = user not found

  @override
  void initState() {
    super.initState();
    if (widget.initialEmail != null) {
      _emailController.text = widget.initialEmail!;
      _checkPasswordSet(widget.initialEmail!);
    } else {
      _isPasswordSet = 1; // if not passed in we asume they can log in
    }
  }

  Future<void> _checkPasswordSet(String email) async {
    setState(() {
      _isLoading = true;
    });
    final backend = BackEnd();
    final result = await backend.checkPasswordSet(email);
    setState(() {
      _isPasswordSet = result;
      _isLoading = false;
    });
  }

  Future<void> _signIn() async {
    setState(() {
      _isLoading = true;
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
    // Handle token submission logic here
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
        _isLoading
            ? CircularProgressIndicator()
            : RoundedButton(
                text: "Sign in",
                icon: Icon(Icons.login, color: Colors.white),
                color: transparentButton,
                onPressed: _signIn,
              ),
      ],
    );
  }

  Widget _buildTokenForm() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Token',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        TextField(
          decoration: InputDecoration(
              labelText: 'Check ${_emailController.value.text}'),
          controller: _tokenController,
        ),
        const SizedBox(height: 32),
        _isLoading
            ? CircularProgressIndicator()
            : RoundedButton(
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
                    child: _isPasswordSet == -1
                        ? CircularProgressIndicator()
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
              ],
            ),
          ),
        ),
      );
}
