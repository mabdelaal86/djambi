import 'dart:async';

import 'package:flame/components.dart' hide Timer;
import 'package:flutter/material.dart';

import '../../models/contest.dart';
import '../../views/board.dart';
import '../buttons.dart';
import '../configs.dart' as configs;
import '../dialogs.dart';
import '../header.dart';
import '../layouts.dart';
import '../utils.dart';
import 'base.dart';

class PlayPage extends BasePage {
  // @override
  // bool get debugMode => true;

  late final Board _board;
  late final Contest _contest;

  late final TextComponent _nextPlayerText;
  late final CircleComponent _nextPlayerIcon;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    _contest = Contest(
      game.options.startIdeology,
      game.options.turnDirection,
      onManoeuvreCompleted,
      onStateChanged,
    );

    await addAll([
      Header(onBackTapUp: onBackTapUp),
      MultiAlignComponent(
        size: size,
        padding: const EdgeInsets.all(configs.largeMargin),
        alignedChildren: {
          Anchor.center: _board = Board(
            _contest,
            game.settings.boardTheme,
            game.settings.pieceTheme,
            game.settings.showMargins,
          ),
          Anchor.bottomLeft: _createUndoRedoPanel(),
          Anchor.bottomRight: _createNextPlayerPanel(),
        },
      ),
    ]);
    _board.scale = Vector2.all(size.x / _board.width);
    onStateChanged();
    onManoeuvreCompleted();
  }

  PositionComponent _createUndoRedoPanel() =>
      FlexComponent(
        spacing: configs.smallMargin,
        axis: Axis.horizontal,
        children: [
          RoundedButton(
            icon: Icons.undo,
            fontSize: configs.iconFontSize,
            size: configs.smallBtnSize,
            onReleased: onUndoTapUp,
          ),
          RoundedButton(
            icon: Icons.redo,
            fontSize: configs.iconFontSize,
            size: configs.smallBtnSize,
            onReleased: onRedoTapUp,
          ),
        ],
      );

  PositionComponent _createNextPlayerPanel() =>
      FlexComponent(
        spacing: configs.smallMargin,
        axis: Axis.horizontal,
        children: [
          TextBoxComponent(
            text: "Next Player:",
            textRenderer: getRenderer(),
            size: Vector2(200, configs.smallBtnSize.y),
            align: Anchor.centerRight,
          ),
          _nextPlayerIcon = CircleComponent(
            radius: configs.smallBtnSize.x / 2,
            children: [
              _nextPlayerText = TextBoxComponent(
                size: configs.smallBtnSize,
                textRenderer: getRenderer(),
                align: Anchor.center,
              ),
            ],
          ),
        ],
      );

  bool get isCurPlayerHuman {
    final curIdeology = _contest.parliament.currentParty.ideology;
    return game.options.players[curIdeology]!.isHuman;
  }

  void onManoeuvreCompleted() {
    if (_board.isLoaded) {
      _board.enableTapUp = isCurPlayerHuman;
    }
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
