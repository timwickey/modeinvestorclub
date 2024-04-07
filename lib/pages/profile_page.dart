import 'package:flutter/material.dart';
import 'package:modeinvestorclub/routes.dart';
import 'package:modeinvestorclub/globals.dart' as globals;

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key, required this.args});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title = 'Profile';
  final List args;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();

    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Add your widget tree here
    return Scaffold(
        appBar: AppBar(
      title: const Text("HELLO PROFILE"),
    ));
  }
}
