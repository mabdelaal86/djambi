import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'controllers/game.dart';

Future<void> main() async {
  await configureDeviceScreen();
  final djambiGame = DjambiGame();
  runApp(MaterialApp(
    home: Scaffold(
      body: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) => djambiGame.popPage(),
        child: GameWidget(game: djambiGame),
      ),
    ),
  ));
}

Future<void> configureDeviceScreen() async {
  const transparentColor = Color(0x00000000);
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
          statusBarColor: transparentColor,
          systemNavigationBarColor: transparentColor,
      ));
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.device.restoreFullscreen();
  await Flame.device.setPortrait();
}
