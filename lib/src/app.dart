import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'auth.dart';
import 'screens/scaffold.dart';
import 'screens/home.dart';
import 'screens/deals.dart';
import 'screens/events.dart';
import 'screens/settings.dart';
import 'screens/sign_in.dart';
import 'widgets/fade_transition_page.dart';
import 'backend.dart';

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
  );
}

class _InvestorClubState extends State<InvestorClub> {
  final ModeAuth auth = ModeAuth();
  late BackEnd _backEnd;
  bool _isInitialized = false; // To track if initialization is complete

  @override
  void initState() {
    super.initState();
    // Initialize the Future with the fetch function
    _backEnd = BackEnd();
    _backEnd.init().then((_) {
      setState(() {
        _isInitialized = true;
      });
    });
  }

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
                child: ColorFiltered(
                  colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.5), // Adjust opacity to darken
                    BlendMode.darken,
                  ),
                  child: Image.asset(
                    'images/websiteglobe.webp',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned.fill(
                child: Opacity(
                  opacity: 0.5, // Adjust the opacity value as needed
                  child: SvgPicture.asset(
                    'images/websitegradient.svg',
                    fit: BoxFit.cover,
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
        initialLocation: '/',
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
                  var p when p.startsWith('/home') => 0,
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
                path: '/home',
                pageBuilder: (context, state) {
                  return FadeTransitionPage<dynamic>(
                    key: state.pageKey,
                    child: const HomeScreen(),
                  );
                },
              ),
              GoRoute(
                path: '/deals',
                pageBuilder: (context, state) {
                  return FadeTransitionPage<dynamic>(
                    key: state.pageKey,
                    child: const DealsScreen(),
                  );
                },
              ),
              GoRoute(
                path: '/events',
                pageBuilder: (context, state) {
                  return FadeTransitionPage<dynamic>(
                    key: state.pageKey,
                    child: const EventsScreen(),
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
                          .signIn(value.email, value.password);
                      router.go('/home');
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
