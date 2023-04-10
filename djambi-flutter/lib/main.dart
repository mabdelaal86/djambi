import 'package:flame/game.dart';
import 'package:flutter/widgets.dart';

import 'components/game.dart';

void main() {
  final game = DjambiGame();
  runApp(GameWidget(game: game));
}
