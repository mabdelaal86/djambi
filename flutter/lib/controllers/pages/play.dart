import 'dart:async';

import 'package:flame/components.dart' hide Timer;
import 'package:flutter/material.dart';

import '../../common/serialization.dart';
import '../../models.dart';
import '../../views.dart';
import '../components.dart';
import '../configs.dart';
import 'base.dart';

class PlayPage extends BasePage {
  // @override
  // bool get debugMode => true;

  late final Board _board;
  late final Contest _contest;

  late final CircleComponent _nextPlayerIcon;
  late final TextComponent _nextPlayerText;

  late final TextComponent _statusLabel;
  late final IndexedStackComponent _statusPanel;

  late final AdvancedButtonComponent _undoButton, _redoButton;
  var _allowUndoRedo = false;

  @override
  Future<void> onLoad() async {
    super.onLoad();

    _contest = await _createContest();

    await addAll([
      Header(onBackTapUp: _onBackTapUp),
      MultiAlignComponent(
        size: size,
        padding: const EdgeInsets.all(Configs.largeMargin),
        alignedChildren: {
          Anchor.center: _board = Board(
            _contest,
            game.prefs.getBoardTheme(),
            game.prefs.getPieceTheme(),
            game.prefs.getMarginsVisibility(),
          ),
          Anchor.bottomLeft: _createUndoRedoPanel(),
          Anchor.bottomRight: _statusPanel = IndexedStackComponent(
            children: [
              _createNextPlayerPanel(),
              _statusLabel = TextBoxComponent(
                size: Vector2(300, 100),
                align: Anchor.center,
                textRenderer: getTextRenderer(
                  color: Configs.emphaticTextColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        },
      ),
    ]);
    _board.scale = Vector2.all(size.x / _board.width);
  }

  @override
  Future<void> onMount() async {
    await _onStatueChanged();
  }

  PositionComponent _createUndoRedoPanel() =>
      FlexComponent(
        spacing: Configs.smallMargin,
        axis: Axis.horizontal,
        children: [
          _undoButton = RoundedButton(
            icon: Icons.undo,
            fontSize: Configs.iconFontSize,
            size: Configs.smallBtnSize,
            onReleased: _onUndoTapUp,
          ),
          _redoButton = RoundedButton(
            icon: Icons.redo,
            fontSize: Configs.iconFontSize,
            size: Configs.smallBtnSize,
            onReleased: _onRedoTapUp,
          ),
        ],
      );

  PositionComponent _createNextPlayerPanel() =>
      FlexComponent(
        spacing: Configs.smallMargin,
        axis: Axis.horizontal,
        children: [
          TextBoxComponent(
            text: "Next Player:",
            textRenderer: getTextRenderer(),
            size: Vector2(200, Configs.smallBtnSize.y),
            align: Anchor.centerRight,
          ),
          _nextPlayerIcon = CircleComponent(
            radius: Configs.smallBtnSize.x / 2,
            children: [
              _nextPlayerText = TextBoxComponent(
                size: Configs.smallBtnSize,
                textRenderer: getTextRenderer(),
                align: Anchor.center,
              ),
            ],
          ),
        ],
      );

  void _onUndoTapUp() {
    if (_allowUndoRedo) {
      _contest.undo();
    }
  }

  void _onRedoTapUp() {
    if (_allowUndoRedo) {
      _contest.redo();
    }
  }

  Future<void> _onStatueChanged() async {
    _undoButton.isDisabled = !_contest.canUndo;
    _redoButton.isDisabled = !_contest.canRedo;
    _board.enableTapUp = false;
    _allowUndoRedo = true;
    if (_contest.parliament.isGameFinished) {
      await _displayWinner();
      return;
    }
    await _displayNextPlayer();
    if (_contest.noHumans()) {
      await _displayGameOver();
      return;
    }
    if (Configs.saveLoadState && _contest.parliament.isManoeuvreCompleted) {
      await save(_contest.toJson(), Configs.statePath);
    }
    if (_contest.isCurHuman()) {
      _board.enableTapUp = true;
      return;
    }
    _allowUndoRedo = false;
    Timer(Configs.actionDuration, () => _contest.aiAct(Configs.aiMaxDepth));
  }

  Future<void> _displayNextPlayer() async {
    await _statusPanel.setIndex(0);
    final (_, next) = _contest.parliament.getNextTurnState();
    final color = _board.boardStyle.partyPaint[next.ideology.index].color;
    _nextPlayerIcon.setColor(color);
    _nextPlayerText.text = next.ideology.name.toUpperCase()[0];
  }

  Future<void> _displayWinner() async {
    await _statusPanel.setIndex(1);
    var name = _contest.parliament.currentParty.ideology.name;
    name = name[0].toUpperCase() + name.substring(1);
    _statusLabel.text = "$name win!".toUpperCase();
  }

  Future<void> _displayGameOver() async {
    await _statusPanel.setIndex(1);
    _statusLabel.text = "GAME OVER!";
  }

  Future<void> _onBackTapUp() async {
    if (_contest.parliament.isGameFinished || _contest.noHumans()) {
      game.router.pop();
      return;
    }
    const msg = "Are you sure?\nThe match state will not be saved!";
    final result = await game.router.pushAndWait(ConfirmDialog(msg));
    if (result == "Yes") {
      game.router.pop();
    }
  }

  Future<Contest> _createContest() async {
    if (Configs.saveLoadState) {
      final json = await load(Configs.statePath);
      if (json != null) {
        return Contest.fromJson(json, onStateChanged: _onStatueChanged);
      }
    }

    return Contest(
        game.prefs.getStartIdeology(),
        game.prefs.getTurnDirection(),
        game.prefs.getPlayerTypes(),
        onStateChanged: _onStatueChanged);
  }
}
