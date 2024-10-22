import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart' hide Timer;
import 'package:flutter/material.dart';

import '../../models/contest.dart';
import '../../views/board.dart';
import '../../views/dimensions.dart' as dimensions;
import '../buttons.dart';
import '../dialogs.dart';
import '../game.dart';
import '../header.dart';
import '../settings.dart';

class PlayPage extends PositionComponent with HasGameReference<DjambiGame> {
  // @override
  // bool get debugMode => true;

  late final Board _board;
  late final Contest _contest;

  late final RoundedButton _undoButton, _redoButton;
  late final TextComponent _nextPlayerLabel, _nextPlayerText;
  late final CircleComponent _nextPlayerIcon;

  @override
  Future<void> onLoad() async {
    _contest = Contest(
      game.options.startIdeology,
      game.options.turnDirection,
      onManoeuvreCompleted,
      onStateChanged,
    );
    await addAll([
      Header(onBackTapUp: onBackTapUp),
      _board = Board(
        _contest, game.settings.boardTheme, game.settings.pieceTheme,
        anchor: Anchor.center,
      ),
      _undoButton = RoundedButton(
        icon: Icons.undo,
        size: RoundedButton.defaultSize,
        onReleased: onUndoTapUp,
      ),
      _redoButton = RoundedButton(
        icon: Icons.redo,
        size: RoundedButton.defaultSize,
        onReleased: onRedoTapUp,
      ),
      _nextPlayerLabel = TextComponent(
        text: "Next Player:",
        anchor: Anchor.center,
      ),
      _nextPlayerIcon = CircleComponent(
        radius: RoundedButton.defaultSize.x / 2,
        anchor: Anchor.center,
      ),
      _nextPlayerText = TextComponent(
        anchor: Anchor.center,
      ),
    ]);
    onStateChanged();
    onManoeuvreCompleted();
  }

  bool get isCurPlayerHuman {
    final curIdeology = _contest.parliament.currentParty.ideology;
    return game.options.players[curIdeology]!.isHuman;
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);

    _undoButton.position = Vector2(size.x / 2 - 150, size.y - 50);
    _redoButton.position = _undoButton.position + Vector2(100, 0);
    _nextPlayerLabel.position = _redoButton.position + Vector2(150, 0);
    _nextPlayerIcon.position = _nextPlayerLabel.position + Vector2(100, 0);
    _nextPlayerText.position = _nextPlayerIcon.position;

    final scale = min(size.x, size.y - 200) / dimensions.boardSize.x;
    _board.scale = Vector2.all(scale);
    _board.position = size / 2;
  }

  void onManoeuvreCompleted() {
    _board.enableTapUp = isCurPlayerHuman;
    if (!isCurPlayerHuman) {
      Timer(Settings.actionDuration, () => _contest.aiAct(2));
    }
  }

  void onStateChanged() {
    final (_, next) = _contest.parliament.getNextTurnState();
    final nextPlayerColor = game.settings.boardTheme.partyPaint[next.ideology.index].color;
    _nextPlayerIcon.setColor(nextPlayerColor);
    _nextPlayerText.text = next.ideology.name.toUpperCase()[0];
  }

  void onUndoTapUp() {
    if (isCurPlayerHuman) {
      _contest.undo();
    }
  }

  void onRedoTapUp() {
    if (isCurPlayerHuman) {
      _contest.redo();
    }
  }

  Future<void> onBackTapUp() async {
    const msg = "Are you sure?\nThe match state will not be saved!";
    final result = await game.router.pushAndWait(ConfirmDialog(msg));
    if (result) {
      game.router.pop();
    }
  }
}
