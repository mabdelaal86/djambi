import 'dart:math';

import 'package:flame/components.dart';

import '../../views/board.dart';
import '../../views/dimensions.dart';
import '../../views/state.dart';
import '../button.dart';
import '../header.dart';
import '../settings.dart';

class PlayPage extends PositionComponent {
  // @override
  // bool get debugMode => true;

  late final Board _board;
  final GameState gameState = GameState();
  final boardTheme = AppearanceSettings.instance.boardTheme;
  final pieceTheme = AppearanceSettings.instance.pieceTheme;

  late final Button _undo, _redo, _aiAct;
  final _btnSize = Vector2.all(40);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    await addAll([
      Header(),
      _board = Board(
        gameState,
        boardTheme,
        pieceTheme,
        anchor: Anchor.center,
      ),
      _undo = Button(
        text: "<",
        size: _btnSize,
        action: () => gameState.undo(),
      ),
      _redo = Button(
        text: ">",
        size: _btnSize,
        action: () => gameState.redo(),
      ),
      _aiAct = Button(
        text: "?",
        size: _btnSize,
        action: () => gameState.aiAct(2),
      ),
    ]);
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);

    _undo.position = Vector2(size.x / 2 - 100, size.y - 50);
    _redo.position = _undo.position + Vector2(100, 0);
    _aiAct.position = _redo.position + Vector2(100, 0);

    final scale = min(size.x, size.y - 200) / Dimensions.boardSize.x;
    _board.scale = Vector2.all(scale);
    _board.position = size / 2;
  }
}
