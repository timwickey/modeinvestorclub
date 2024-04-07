import 'package:modeinvestorclub/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:modeinvestorclub/routes.dart';
import 'package:modeinvestorclub/pages/profile_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(ModeInvestorClub());
}

class ModeInvestorClub extends StatelessWidget {
  const ModeInvestorClub({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mode Investor Club',
      theme: _buildDarkTheme(), // Setting the theme to dark
      darkTheme: _buildDarkTheme(), // Setting the dark theme
      themeMode: ThemeMode.dark, // Setting the theme mode to dark
      initialRoute: RouteConfiguration.rootRoute,
      onGenerateRoute: RouteConfiguration.generateRoute,
    );
  }

  ThemeData _buildDarkTheme() {
    return ThemeData(
      brightness: Brightness.dark,
      // Add your custom dark theme colors here
      // For example:
      // primaryColor: Colors.grey[800],
      // accentColor: Colors.blueGrey[600],
    );
  }
}

class Root extends StatefulWidget {
  const Root({super.key, required this.title});

  final String title;

  @override
  State<Root> createState() => _RootState();
}

class _RootState extends State<Root> {
  var selectedIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;

    Widget page;
    switch (selectedIndex) {
      case 0:
        page = HomePage(title: "Home");
      case 1:
        page = ProfilePage(args: []);
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    // The container for the current page, with its background color
    // and subtle switching animation.
    var mainArea = ColoredBox(
      color: colorScheme.surfaceVariant,
      child: AnimatedSwitcher(
        duration: Duration(milliseconds: 200),
        child: page,
      ),
    );

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          ThemeData themeData = Theme.of(context);
          if (constraints.maxWidth < 450) {
            // Mobile-friendly layout with BottomNavigationBar
            return Column(
              children: [
                Expanded(child: mainArea),
                BottomNavigationBar(
                  items: [
                    BottomNavigationBarItem(
                      icon: Icon(Icons.home),
                      label: 'Home',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.settings),
                      label: 'Settings',
                    ),
                  ],
                  currentIndex: selectedIndex,
                  onTap: (value) {
                    setState(() {
                      selectedIndex = value;
                    });
                  },
                  backgroundColor:
                      themeData.bottomNavigationBarTheme.backgroundColor,
                  selectedItemColor:
                      themeData.bottomNavigationBarTheme.selectedItemColor,
                  unselectedItemColor:
                      themeData.bottomNavigationBarTheme.unselectedItemColor,
                )
              ],
            );
          } else {
            // Wider-screen layout with NavigationRail
            return Row(
              children: [
                NavigationRail(
                  extended: constraints.maxWidth >= 600,
                  destinations: [
                    NavigationRailDestination(
                      icon: Icon(Icons.home),
                      label: Text('Home'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.settings),
                      label: Text('Settings'),
                    ),
                  ],
                  selectedIndex: selectedIndex,
                  onDestinationSelected: (value) {
                    setState(() {
                      selectedIndex = value;
                    });
                  },
                  backgroundColor: themeData.cardColor,
                  selectedIconTheme: themeData.iconTheme
                      .copyWith(color: themeData.primaryColor),
                  unselectedIconTheme: themeData.iconTheme
                      .copyWith(color: themeData.unselectedWidgetColor),
                  labelType: NavigationRailLabelType.none,
                ),
                Expanded(child: mainArea),
              ],
            );
          }
        },
      ),
    );
  }
}
