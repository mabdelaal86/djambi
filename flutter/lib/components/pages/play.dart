import 'package:flame/components.dart';
import 'package:flutter/widgets.dart';

import '../../views/board.dart';
import '../../views/dimensions.dart';
import '../../views/state.dart';
import '../button.dart';
import '../settings.dart';

class PlayPage extends PositionComponent {
  // @override
  // bool get debugMode => true;

  static final Vector2 pageSize = Dimensions.boardSize + Vector2(0, Dimensions.cellSide);
  final GameState gameState;
  final boardTheme = AppearanceSettings.instance.boardTheme;
  final pieceTheme = AppearanceSettings.instance.pieceTheme;
  final guiTheme = AppearanceSettings.instance.guiTheme;

  PlayPage(this.gameState, {super.position})
      : super(size: pageSize, anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    await addAll([
      Board(gameState, boardTheme, pieceTheme),
      _addButton(0, "<", _undo),
      _addButton(1, ">", _redo),
      _addButton(2, "?", _aiAct),
    ]);
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRect(size.toRect(), guiTheme.bgPaint);
  }

  void _undo() {
    debugPrint("Tap up Undo");
    gameState.undo();
  }

  void _redo() {
    debugPrint("Tap up Redo");
    gameState.redo();
  }

  void _aiAct() {
    debugPrint("Tap up AI");
    if (!gameState.parliament.isManoeuvreCompleted) return;
    if (gameState.parliament.isGameFinished) return;
    gameState.aiAct(2);
  }

  Button _addButton(int count, String text, void Function() action) {
    const space = Dimensions.cellSide / 2 - Dimensions.pieceRadius;
    final x = Dimensions.margin + (count * Dimensions.cellSide) + space;
    final y = Dimensions.boardSize.y + space;
    return Button(
        position: Vector2(x, y),
        size: Dimensions.pieceSize,
        bgPaint: guiTheme.buttonPaint,
        textStyle: guiTheme.buttonTextStyle,
        text: text,
        action: action
    );
  }
}
