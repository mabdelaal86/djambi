import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'controllers/preferences.dart';
import 'screens/home.dart';

Future<void> main() async {
  // debugPaintSizeEnabled = true;
  WidgetsFlutterBinding.ensureInitialized();
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
      home: const HomePage(),
    ),
  );
}
