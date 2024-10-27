import 'dart:async';

import 'package:flame/components.dart' hide Timer;
import 'package:flutter/material.dart';

import '../../models/contest.dart';
import '../../views/board.dart';
import '../../views/dimensions.dart' as dimensions;
import '../buttons.dart';
import '../configs.dart' as configs;
import '../dialogs.dart';
import '../game.dart';
import '../header.dart';
import '../utils.dart';

class PlayPage extends PositionComponent with HasGameReference<DjambiGame> {
  // @override
  // bool get debugMode => true;

  late final Board _board;
  late final Contest _contest;

  late final TextComponent _nextPlayerText;
  late final CircleComponent _nextPlayerIcon;

  @override
  Future<void> onLoad() async {
    size = game.size;
    final footerSize = Vector2(600, configs.smallBtnSize.y);
    const space = 20.0;

    _contest = Contest(
      game.options.startIdeology,
      game.options.turnDirection,
      onManoeuvreCompleted,
      onStateChanged,
    );

    await addAll([
      Header(onBackTapUp: onBackTapUp),
      _board = Board(
        _contest,
        game.settings.boardTheme,
        game.settings.pieceTheme,
        anchor: Anchor.center,
        position: Anchor.center.ofSize(size),
        scale: Vector2.all(size.x / dimensions.boardSize.x),
      ),
      PositionComponent(
        size: footerSize,
        anchor: Anchor.bottomCenter,
        position: Vector2(size.x / 2, size.y - 50),
        children: [
          RoundedButton(
            icon: Icons.undo,
            size: configs.smallBtnSize,
            onReleased: onUndoTapUp,
            anchor: Anchor.centerLeft,
            position: Anchor.centerLeft.ofSize(footerSize),
          ),
          RoundedButton(
            icon: Icons.redo,
            size: configs.smallBtnSize,
            onReleased: onRedoTapUp,
            anchor: Anchor.centerLeft,
            position: Anchor.centerLeft.ofSize(footerSize) +
                Vector2(configs.smallBtnSize.x + space, 0),
          ),
          _nextPlayerIcon = CircleComponent(
            radius: configs.smallBtnSize.x / 2,
            anchor: Anchor.centerRight,
            position: Anchor.centerRight.ofSize(footerSize),
          ),
          _nextPlayerText = TextBoxComponent(
            size: configs.smallBtnSize,
            align: Anchor.center,
            anchor: Anchor.centerRight,
            position: Anchor.centerRight.ofSize(footerSize),
          ),
          TextComponent(
            text: "Next Player:",
            anchor: Anchor.centerRight,
            position: Anchor.centerRight.ofSize(footerSize) -
                Vector2(configs.smallBtnSize.x + space, 0),
          ),
        ],
      ),
    ]);
    onStateChanged();
    onManoeuvreCompleted();
  }

  bool get isCurPlayerHuman {
    final curIdeology = _contest.parliament.currentParty.ideology;
    return game.options.players[curIdeology]!.isHuman;
  }

  void onManoeuvreCompleted() {
    _board.enableTapUp = isCurPlayerHuman;
    if (!isCurPlayerHuman) {
      Timer(configs.actionDuration, () => _contest.aiAct(2));
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
