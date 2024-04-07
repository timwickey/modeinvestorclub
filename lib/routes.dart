import 'package:flutter/material.dart';

import 'package:modeinvestorclub/pages/home_page.dart';
import 'package:modeinvestorclub/main.dart';
import 'package:modeinvestorclub/pages/profile_page.dart';

class RouteConfiguration {
  static const String rootRoute = '/';
  static const String homeRoute = '/home';
  static const String profileRoute = '/profile';

  static Route<dynamic> generateRoute(RouteSettings settings,
      {List? arguments}) {
    switch (settings.name) {
      case homeRoute:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => HomePage(
            title: 'Home',
          ),
        );
      case profileRoute:
        // check if arguments is null and if so, assign an empty list
        final List args = arguments ?? [];
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => ProfilePage(args: args),
        );
      default:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => Root(title: "Home"),
        );
    }
  }
}
