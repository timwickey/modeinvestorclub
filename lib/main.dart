import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:url_strategy/url_strategy.dart';
import 'package:window_size/window_size.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart'; // Import the package

import 'src/app.dart';

void main() async {
  // Use package:url_strategy until this pull request is released:
  // https://github.com/flutter/flutter/pull/77103

  // Use to setHashUrlStrategy() to use "/#/" in the address bar (default). Use
  // setPathUrlStrategy() to use the path. You may need to configure your web
  // server to redirect all paths to index.html.
  //
  // On mobile platforms, both functions are no-ops.
  // setHashUrlStrategy();
  setPathUrlStrategy();

  setupWindow();

  // databaseConnection();
  await dotenv.load(fileName: ".env.development.local"); // Load the .env file
  runApp(const InvestorClub());
}

const double windowWidth = 480;
const double windowHeight = 854;

void setupWindow() {
  if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
    WidgetsFlutterBinding.ensureInitialized();
    setWindowTitle('Navigation and routing');
    setWindowMinSize(const Size(windowWidth, windowHeight));
    setWindowMaxSize(const Size(windowWidth, windowHeight));
    getCurrentScreen().then((screen) {
      setWindowFrame(Rect.fromCenter(
        center: screen!.frame.center,
        width: windowWidth,
        height: windowHeight,
      ));
    });
  }
}
