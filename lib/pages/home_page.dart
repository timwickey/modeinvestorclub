import 'package:flutter/material.dart';
import 'package:modeinvestorclub/routes.dart';
import 'package:modeinvestorclub/globals.dart' as globals;

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
      title: const Text("HELLO WORLD"),
    ));
  }
}
