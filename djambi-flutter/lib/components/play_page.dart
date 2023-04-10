import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../models/state.dart';
import 'button.dart';
import 'dimensions.dart';

class PlayPage extends PositionComponent {
  // @override
  // bool get debugMode => true;

  final GameState gameState;

  PlayPage(this.gameState, {super.position}):
        super(size: Dimensions.boardSize + Vector2(0, Dimensions.cellSide), anchor: Anchor.center) {

    final y = Dimensions.boardSize.y + 100;
    final size = Vector2.all(800);
    void createButton(double x, String text, Function tapUpCallback) {
      final button = Button(Colors.grey, Vector2(x, y), size, text: text, tapUpCallback: tapUpCallback);
      add(button);
    }

    createButton(100, "<=", () => { gameState.undo() });
    createButton(1100, "=>", () => { gameState.redo() });
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRect(size.toRect(), Paint()..color = Colors.green.shade900);
  }
}
