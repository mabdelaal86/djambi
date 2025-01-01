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
import '../layouts/indexed_stack.dart';
import '../options.dart';
import '../utils/serialization.dart';
import '../utils/ui.dart';
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
    await super.onLoad();

    _contest = await _createContest();

    await addAll([
      Header(onBackTapUp: _onBackTapUp),
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
          Anchor.bottomRight: _statusPanel = IndexedStackComponent(
            children: [
              _createNextPlayerPanel(),
              _statusLabel = TextBoxComponent(
                size: Vector2(300, 100),
                align: Anchor.center,
                textRenderer: getRenderer(
                  color: configs.emphaticTextColor,
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
        spacing: configs.smallMargin,
        axis: Axis.horizontal,
        children: [
          _undoButton = RoundedButton(
            icon: Icons.undo,
            fontSize: configs.iconFontSize,
            size: configs.smallBtnSize,
            onReleased: _onUndoTapUp,
          ),
          _redoButton = RoundedButton(
            icon: Icons.redo,
            fontSize: configs.iconFontSize,
            size: configs.smallBtnSize,
            onReleased: _onRedoTapUp,
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
    if (_isGameOver()) {
      await _displayGameOver();
      return;
    }
    if (configs.saveLoadState && _contest.parliament.isManoeuvreCompleted) {
      await save(_contest.curState, configs.statePath);
    }
    if (_isCurPlayerHuman()) {
      _board.enableTapUp = true;
      return;
    }
    _allowUndoRedo = false;
    Timer(configs.actionDuration, () => _contest.aiAct(2));
  }

  bool _isCurPlayerHuman() {
    final curIdeology = _contest.parliament.currentParty.ideology;
    return game.options.players[curIdeology]!.isHuman;
  }

  bool _isGameOver() => _contest.parliament.activeParties
      .every((p) => game.options.players[p.ideology] != PlayerType.human);

  Future<void> _displayNextPlayer() async {
    await _statusPanel.setIndex(0);
    final (_, next) = _contest.parliament.getNextTurnState();
    final color = _board.boardTheme.partyPaint[next.ideology.index].color;
    _nextPlayerIcon.setColor(color);
    _nextPlayerText.text = next.ideology.name.toUpperCase()[0];
  }

  Future<void> _displayWinner() async {
    await _statusPanel.setIndex(1);
    var name = _contest.parliament.currentParty.ideology.name;
    name = name[0].toUpperCase() + name.substring(1);
    _statusLabel.text = "$name party win!";
  }

  Future<void> _displayGameOver() async {
    await _statusPanel.setIndex(1);
    _statusLabel.text = "Game over!";
  }

  Future<void> _onBackTapUp() async {
    const msg = "Are you sure?\nThe match state will not be saved!";
    final result = await game.router.pushAndWait(ConfirmDialog(msg));
    if (result == "Yes") {
      game.router.pop();
    }
  }

  Future<Contest> _createContest() async {
    if (configs.saveLoadState) {
      final state = await load(configs.statePath);
      if (state != null) {
        return Contest.fromState(state, onStateChanged: _onStatueChanged);
      }
    }

    return Contest(
      game.options.startIdeology,
      game.options.turnDirection,
      onStateChanged: _onStatueChanged,
    );
  }
}
