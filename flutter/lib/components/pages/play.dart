import 'dart:math';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../../views/board.dart';
import '../../views/dimensions.dart';
import '../../views/state.dart';
import '../buttons.dart';
import '../header.dart';
import '../settings.dart';

class PlayPage extends PositionComponent {
  // @override
  // bool get debugMode => true;

  late final Board _board;
  late final GameState _gameState;
  final _boardTheme = AppearanceSettings.instance.boardTheme;
  final _pieceTheme = AppearanceSettings.instance.pieceTheme;
  final _gameSettings = GameSettings.instance;

  late final RoundedButton _undo, _redo, _aiAct;

  @override
  Future<void> onLoad() async {
    _gameState = GameState(
        _gameSettings.startIdeology, _gameSettings.turnDirection);
    await addAll([
      Header(),
      _board = Board(
        _gameState, _boardTheme, _pieceTheme,
        anchor: Anchor.center,
      ),
      _undo = RoundedButton(
        icon: Icons.undo,
        size: RoundedButton.defaultSize,
        onReleased: () => _gameState.undo(),
      ),
      _redo = RoundedButton(
        icon: Icons.redo,
        size: RoundedButton.defaultSize,
        onReleased: () => _gameState.redo(),
      ),
      _aiAct = RoundedButton(
        icon: Icons.computer,
        size: RoundedButton.defaultSize,
        onReleased: () => _gameState.aiAct(2),
      ),
    ]);
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);

    _undo.position =  Vector2(size.x / 2 - 100, size.y - 50);
    _redo.position =  _undo.position + Vector2(100, 0);
    _aiAct.position = _redo.position + Vector2(100, 0);

    final scale = min(size.x, size.y - 200) / Dimensions.boardSize.x;
    _board.scale = Vector2.all(scale);
    _board.position = size / 2;
  }
}
