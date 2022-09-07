import 'package:flame/game.dart';
import 'package:flutter/widgets.dart';

import 'djambi_game.dart';

void main() {
  final game = DjambiGame();
  runApp(GameWidget(game: game));
}
