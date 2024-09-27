import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart' show SystemMouseCursors;
import 'package:url_launcher/url_launcher.dart';

import '../button.dart';
import '../game.dart';
import '../header.dart';

class HomePage extends PositionComponent with HasGameReference<DjambiGame> {
  // bool get debugMode => true;

  late final Button _startButton,
      _settingsButton,
      _aboutButton,
      _advancedButton;

  @override
  Future<void> onLoad() async {
    await addAll([
      Header(),
      _startButton = Button(
        text: "Start",
        size: Vector2(300, 75),
        action: () => game.router.pushNamed("play"),
        onHover: () {
          game.mouseCursor = SystemMouseCursors.click;
        },
        onExit: () {
          game.mouseCursor = SystemMouseCursors.basic;
        },
      ),
      _advancedButton = Button(
        text: "Advanced",
        size: Vector2(300, 75),
        action: () {},
      ),
      _aboutButton = Button(
        text: "About & Rules",
        size: Vector2(300, 75),
        action: () async {
          const url =
              'assets/rules/Djambi_rules.pdf'; // Chemin relatif vers votre PDF
          final uri = Uri.parse(url);
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri);
          } else {
            throw 'Could not launch $url';
          }
        },
      ),
      _settingsButton = Button(
        text: "Settings",
        size: Vector2(300, 75),
        action: () => game.router.pushNamed("settings"),
      ),
    ]);
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    _startButton.position = Vector2(size.x / 2, size.y / 3);
    _advancedButton.position = _startButton.position + Vector2(0, 100);
    _aboutButton.position = _startButton.position + Vector2(0, 200);
    _settingsButton.position = _aboutButton.position + Vector2(0, 100);
  }
}
