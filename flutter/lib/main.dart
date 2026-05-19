import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'controllers/preferences.dart';
import 'screens.dart';

Future<void> main() async {
  // debugPaintSizeEnabled = true;
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(MyApp(preferences: await .create()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.preferences});

  final Preferences preferences;

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider.value(
    value: preferences,
    child: MaterialApp(
      title: "Djambi",
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.blueGrey)),
      routes: {
        "/": (_) => const HomePage(),
        "/about": (_) => const AboutPage(),
        "/settings": (_) => const SettingsPage(),
        "/options": (_) => const OptionsPage(),
        "/play": (_) => const PlayPage(),
      },
    ),
  );
}
