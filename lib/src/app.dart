import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import 'auth.dart';
import 'screens/scaffold.dart';
import 'screens/home.dart';
import 'screens/deals.dart';
import 'screens/events.dart';
import 'screens/settings.dart';
import 'screens/sign_in.dart';
import 'screens/not_found.dart';
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
    scaffoldBackgroundColor: Colors.transparent,
  );
}

class _InvestorClubState extends State<InvestorClub> {
  late BackEnd _backEnd;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _backEnd = BackEnd();
    _backEnd.init().then((_) {
      setState(() {
        _isInitialized = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ModeAuth(),
      child: Consumer<ModeAuth>(
        builder: (context, auth, _) {
          return MaterialApp.router(
            title: 'Mode Investor Club',
            theme: _buildDarkTheme(),
            darkTheme: _buildDarkTheme(),
            themeMode: ThemeMode.dark,
            builder: (context, child) {
              if (child == null) {
                throw ('No child in .router constructor builder');
              }
              return Stack(
                children: [
                  Positioned.fill(
                    child: ColorFiltered(
                      colorFilter: ColorFilter.mode(
                        Colors.black.withOpacity(0.5),
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
                      opacity: 0.5,
                      child: SvgPicture.asset(
                        'images/websitegradient.svg',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  child,
                ],
              );
            },
            routerConfig: GoRouter(
              refreshListenable: auth,
              debugLogDiagnostics: true,
              initialLocation: '/home',
              redirect: (context, state) {
                final signedIn = context.read<ModeAuth>().signedIn;
                if (state.uri.toString() != '/sign-in' && !signedIn) {
                  return '/sign-in';
                }
                return null;
              },
              errorPageBuilder: (context, state) {
                return MaterialPage<void>(
                  key: state.pageKey,
                  child: const NotFoundScreen(),
                );
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
                          child: HomeScreen(
                            user: context.read<ModeAuth>().user,
                          ),
                        );
                      },
                    ),
                    GoRoute(
                      path: '/deals',
                      pageBuilder: (context, state) {
                        return FadeTransitionPage<dynamic>(
                          key: state.pageKey,
                          child:
                              DealsScreen(user: context.read<ModeAuth>().user),
                        );
                      },
                    ),
                    GoRoute(
                      path: '/events',
                      pageBuilder: (context, state) {
                        return FadeTransitionPage<dynamic>(
                          key: state.pageKey,
                          child:
                              EventsScreen(user: context.read<ModeAuth>().user),
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
                    return const SignInScreen();
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
