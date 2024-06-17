import 'package:adaptive_navigation/adaptive_navigation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class WebsiteScaffold extends StatelessWidget {
  final Widget child;
  final int selectedIndex;

  const WebsiteScaffold({
    required this.child,
    required this.selectedIndex,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final goRouter = GoRouter.of(context);

    return Scaffold(
      body: AdaptiveNavigationScaffold(
        selectedIndex: selectedIndex,
        body: child,
        onDestinationSelected: (idx) {
          if (idx == 0) goRouter.go('/home');
          if (idx == 1) goRouter.go('/deals');
          if (idx == 2) goRouter.go('/events');
          if (idx == 3) goRouter.go('/settings');
        },
        destinations: const [
          AdaptiveScaffoldDestination(
            title: 'Home',
            icon: Icons.book,
          ),
          AdaptiveScaffoldDestination(
            title: 'Deals',
            icon: Icons.shopping_cart,
          ),
          AdaptiveScaffoldDestination(
            title: 'Events',
            icon: Icons.event,
          ),
          AdaptiveScaffoldDestination(
            title: 'Settings',
            icon: Icons.settings,
          ),
        ],
      ),
    );
  }
}
