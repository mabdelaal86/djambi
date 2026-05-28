import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'controllers/preferences.dart';
import 'screens.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // No orientation lock — the game handles both portrait and landscape
  runApp(MyApp(preferences: await Preferences.create()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.preferences});

  final Preferences preferences;

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider.value(
    value: preferences,
    child: MaterialApp(
      title: "Djambi",
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey)),
      routes: {
        "/": (_) => const HomePage(),
        "/about": (_) => const AboutPage(),
        "/settings": (_) => const SettingsPage(),
        "/options": (_) => const OptionsPage(),
        "/play": (_) => const PlayPage(),
        "/rules": (_) => const RulesPage(),
      },
    ),
  );
}
