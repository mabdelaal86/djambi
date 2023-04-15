import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../models/state.dart';
import 'button.dart';
import 'dimensions.dart';
import 'settings.dart';

class PlayPage extends PositionComponent {
  // @override
  // bool get debugMode => true;

  final GameState gameState;

  PlayPage(this.gameState, {super.position}):
        super(size: Dimensions.boardSize + Vector2(0, Dimensions.cellSide), anchor: Anchor.center) {
    _addButton(0, Icons.undo, () => { debugPrint("Tap up Undo"), gameState.undo() });
    _addButton(1, Icons.redo, () => { debugPrint("Tap up Redo"), gameState.redo() });
    _addButton(2, Icons.computer, () => { debugPrint("Tap up AI"), gameState.aiAct(2) });
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRect(size.toRect(), Paint()..color = Colors.green.shade900);
  }

  void _addButton(int count, IconData icon, Function tapUpCallback) {
    final gameTheme = AppearanceSettings.instance.gameTheme;
    const space = Dimensions.cellSide / 2 - Dimensions.pieceRadius;
    final y = Dimensions.boardSize.y + space;
    final x = Dimensions.margin + (count * Dimensions.cellSide) + space;
    final button = Button(
        Vector2(x, y), Dimensions.pieceSize,
        gameTheme.buttonPaint, gameTheme.buttonTextStyle,
        icon: icon, tapUpCallback: tapUpCallback
    );
    add(button);
  }
}
