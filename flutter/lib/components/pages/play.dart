import 'dart:async';

import 'package:flame/components.dart' hide Timer;
import 'package:flutter/material.dart';

import '../../common/utils.dart';
import '../../models/contest.dart';
import '../../views/board.dart';
import '../buttons.dart';
import '../configs.dart' as configs;
import '../dialogs.dart';
import '../header.dart';
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

    final footerSize = Vector2(size.x * 0.75, configs.smallBtnSize.y);

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
        game.settings.showMargins,
        anchor: Anchor.center,
        position: Anchor.center.ofSize(size),
      ),
      PositionComponent(
        size: footerSize,
        anchor: Anchor.bottomCenter,
        position: Vector2(size.x / 2, size.y - configs.largeMargin),
        children: [
          RoundedButton(
            icon: Icons.undo,
            fontSize: configs.iconFontSize,
            size: configs.smallBtnSize,
            onReleased: onUndoTapUp,
            anchor: Anchor.centerLeft,
            position: Anchor.centerLeft.ofSize(footerSize),
          ),
          RoundedButton(
            icon: Icons.redo,
            fontSize: configs.iconFontSize,
            size: configs.smallBtnSize,
            onReleased: onRedoTapUp,
            anchor: Anchor.centerLeft,
            position: Anchor.centerLeft.ofSize(footerSize) +
                Vector2(configs.smallBtnSize.x + configs.smallMargin, 0),
          ),
          _nextPlayerIcon = CircleComponent(
            radius: configs.smallBtnSize.x / 2,
            anchor: Anchor.centerRight,
            position: Anchor.centerRight.ofSize(footerSize),
          ),
          _nextPlayerText = TextBoxComponent(
            size: configs.smallBtnSize,
            textRenderer: TextPaint(
              style: const TextStyle(fontSize: configs.defaultFontSize),
            ),
            align: Anchor.center,
            anchor: Anchor.centerRight,
            position: Anchor.centerRight.ofSize(footerSize),
          ),
          TextComponent(
            text: "Next Player:",
            textRenderer: getRenderer(),
            anchor: Anchor.centerRight,
            position: Anchor.centerRight.ofSize(footerSize) -
                Vector2(configs.smallBtnSize.x + configs.smallMargin, 0),
          ),
        ],
      ),
    ]);
    _board.scale = Vector2.all(size.x / _board.width);
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
