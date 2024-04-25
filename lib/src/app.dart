import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'auth.dart';
import 'screens/scaffold.dart';
import 'screens/settings.dart';
import 'screens/sign_in.dart';
import 'widgets/fade_transition_page.dart';
import 'package:flutter_svg/flutter_svg.dart';

class InvestorClub extends StatefulWidget {
  const InvestorClub({super.key});

  @override
  State<InvestorClub> createState() => _InvestorClubState();
}

ThemeData _buildDarkTheme() {
  return ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor:
        Colors.transparent, // Makes scaffold background default to transparent
    // Add your custom dark theme colors here
    // For example:
    // primaryColor: Colors.grey[800],
    // accentColor: Colors.blueGrey[600],
  );
}

class _InvestorClubState extends State<InvestorClub> {
  final ModeAuth auth = ModeAuth();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Mode Investor Club',
      theme: _buildDarkTheme(), // Setting the theme to dark
      darkTheme: _buildDarkTheme(), // Setting the dark theme
      themeMode: ThemeMode.dark, // Setting the theme mode to dark
      builder: (context, child) {
        if (child == null) {
          throw ('No child in .router constructor builder');
        }
        return ModeAuthScope(
          notifier: auth,
          child: Stack(
            children: [
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.blueGrey
                            .shade800, // Adjust these colors to match your theme
                        Colors.black, // Adjust these colors to match your theme
                      ],
                    ),
                  ),
                ),
              ),
              child, // This is your original child from MaterialApp.router
            ],
          ),
        );
      },
      routerConfig: GoRouter(
        refreshListenable: auth,
        debugLogDiagnostics: true,
        initialLocation: '/home',
        redirect: (context, state) {
          final signedIn = ModeAuth.of(context).signedIn;
          if (state.uri.toString() != '/sign-in' && !signedIn) {
            return '/sign-in';
          }
          return null;
        },
        routes: [
          ShellRoute(
            builder: (context, state, child) {
              return WebsiteScaffold(
                selectedIndex: switch (state.uri.path) {
                  var p when p.startsWith('/news') => 0,
                  var p when p.startsWith('/deals') => 1,
                  var p when p.startsWith('/events') => 2,
                  var p when p.startsWith('/settings') => 3,
                  _ => 0,
                },
                child: child,
              );
            },
            routes: [
              GoRoute(
                path: '/news',
                pageBuilder: (context, state) {
                  return FadeTransitionPage<dynamic>(
                    key: state.pageKey,
                    child: const SettingsScreen(),
                  );
                },
              ),
              GoRoute(
                path: '/deals',
                pageBuilder: (context, state) {
                  return FadeTransitionPage<dynamic>(
                    key: state.pageKey,
                    child: const SettingsScreen(),
                  );
                },
              ),
              GoRoute(
                path: '/events',
                pageBuilder: (context, state) {
                  return FadeTransitionPage<dynamic>(
                    key: state.pageKey,
                    child: const SettingsScreen(),
                  );
                },
              ),
              GoRoute(
                path: '/settings',
                pageBuilder: (context, state) {
                  return FadeTransitionPage<dynamic>(
                    key: state.pageKey,
                    child: const SettingsScreen(),
                  );
                },
              ),
            ],
          ),
          GoRoute(
            path: '/sign-in',
            builder: (context, state) {
              // Use a builder to get the correct BuildContext
              // TODO (johnpryan): remove when https://github.com/flutter/flutter/issues/108177 lands
              return Builder(
                builder: (context) {
                  return SignInScreen(
                    onSignIn: (value) async {
                      final router = GoRouter.of(context);
                      await ModeAuth.of(context)
                          .signIn(value.username, value.password);
                      router.go('/news');
                    },
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
