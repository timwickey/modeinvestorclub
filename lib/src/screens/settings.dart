import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:modeinvestorclub/src/data/globals.dart';
import 'package:provider/provider.dart';
import 'dart:convert'; // For converting JSON data
import 'package:http/http.dart' as http; // Importing the http package
import '../auth.dart';
import '../backend.dart';
import '../widgets/ui.dart'; // Ensure this import is correct

class SettingsScreen extends StatefulWidget {
  final ApiResponse? user;
  const SettingsScreen({super.key, this.user});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 20.0), // Add padding to start 20 pixels from the top
              child: Align(
                alignment: Alignment.topCenter,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: Column(
                    children: [
                      const Card(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 18, horizontal: 12),
                          child: SettingsContent(),
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      const AdminSection(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
}

class SettingsContent extends StatelessWidget {
  const SettingsContent({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<ModeAuth>(context);
    final user = auth.user;

    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
      child: Column(
        children: [
          Text(
            'Settings',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 16.0),
          Text('Name: ${user?.firstName ?? ''} ${user?.lastName ?? ''}'),
          const SizedBox(height: 8.0),
          Text('Email: ${user?.email ?? ''}'),
          const SizedBox(height: 26.0),
          RoundedButton(
            onPressed: () {
              auth.setTokenLogin(true);
              GoRouter.of(context).go('/home');
            },
            text: 'Change Password',
            color: transparentButton,
            icon: Icon(Icons.lock),
          ),
          const SizedBox(height: 20.0),
          RoundedButton(
            onPressed: () async {
              await auth.signOut();
              GoRouter.of(context).go('/sign-in');
            },
            text: 'Sign Out',
            color: transparentButton,
            icon: Icon(Icons.exit_to_app),
          ),
        ],
      ),
    );
  }
}

class AdminSection extends StatefulWidget {
  const AdminSection({super.key});

  @override
  _AdminSectionState createState() => _AdminSectionState();
}

class _AdminSectionState extends State<AdminSection> {
  final TextEditingController _searchController = TextEditingController();
  List<ApiResponse> _searchResults = [];
  bool _isLoading = false;
  String _errorMessage = '';

  Future<void> _searchUsers(String query) async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    final auth = Provider.of<ModeAuth>(context, listen: false);
    final token = auth.token;

    if (token == null) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Token is not available';
      });
      return;
    }

    String url = '${ApiUrl}/admin_search';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'query': query, 'token': token}),
      );

      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = json.decode(response.body);
        setState(() {
          _searchResults =
              jsonResponse.map((data) => ApiResponse.fromJson(data)).toList();
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = 'Failed to load search results';
          _isLoading = false;
        });
      }
    } catch (error) {
      setState(() {
        _errorMessage = 'Failed to load search results: $error';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<ModeAuth>(context);
    final user = auth.user;

    if (user == null || !user.admin) {
      return Container();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(thickness: 1.0),
        const Text(
          'ADMIN',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20.0),
        TextField(
          controller: _searchController,
          decoration: InputDecoration(
            labelText: 'Search',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),
        ),
        const SizedBox(height: 16.0),
        RoundedButton(
          onPressed: () => _searchUsers(_searchController.text),
          text: 'Search',
          color: transparentButton,
          icon: const Icon(Icons.search),
        ),
        const SizedBox(height: 20.0),
        if (_isLoading) const CircularProgressIndicator(),
        if (_errorMessage.isNotEmpty)
          Text(
            _errorMessage,
            style: const TextStyle(color: Colors.red),
          ),
        if (_searchResults.isNotEmpty)
          ListView.builder(
            shrinkWrap: true,
            itemCount: _searchResults.length,
            itemBuilder: (context, index) {
              final user = _searchResults[index];
              return ListTile(
                title: Text('${user.firstName} ${user.lastName}'),
                subtitle: Text(user.email),
              );
            },
          ),
      ],
    );
  }
}
