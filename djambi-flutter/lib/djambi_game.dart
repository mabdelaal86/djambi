import 'package:flame/experimental.dart';
import 'package:flame/extensions.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/widgets.dart';
import 'package:flutter/material.dart';

import 'components/board.dart';
import 'components/piece.dart';

class DjambiGame extends FlameGame with HasTappableComponents {
  @override
  Future<void> onLoad() async {
    await Flame.images.load('test.png');

    final board = Board()
      ..size = Board.sideSize.toVector2()
      ..position = Vector2(500, 300);
    final pieces = List.generate(4, (index) => Piece()
        ..size = Board.cellSize.toVector2()
        ..position = Vector2(1000, 300 + 500 + index * 2000)
        ..isDead = index % 2 == 0
        ..color = Colors.red
    );

    final world = World()
      ..add(board)
      ..addAll(pieces);
    add(world);

    final camera = CameraComponent(world: world)
      ..viewfinder.visibleGameSize = Board.sideSize.toVector2() + Vector2.all(500)
      ..viewfinder.anchor = Anchor.topLeft;
    add(camera);
  }
}
