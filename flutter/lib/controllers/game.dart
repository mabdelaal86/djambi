import 'dart:async';

import 'package:flame/components.dart' hide Timer;
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../../models.dart';
import '../../views.dart';
import '../common/utils.dart';
import 'preferences.dart';
import 'serialization.dart';

const noTapUpOverlayId = "noTapUpOverlay";

const _gameWidth = 1000.0;
const _gameHeight = 1380.0;

const _aiMaxDepth = 2;

/// used for developing and testing
const _saveLoadState = false;
const _statePath = "game.json";

class DjambiGame extends FlameGame {
  final Preferences preferences;
  final Color surface;

  late final Contest _contest;
  var _allowUndoRedo = false;

  DjambiGame({required this.preferences, required this.surface})
    : super(
        camera: CameraComponent.withFixedResolution(width: _gameWidth, height: _gameHeight),
      );

  @override
  Color backgroundColor() => surface;

  @override
  Future<void> onLoad() async {
    camera.viewfinder.anchor = .topLeft;

    await world.addAll([
      Playground(
        _contest = await _createContest(),
        boardTheme: preferences.boardTheme,
        pieceTheme: preferences.pieceTheme,
        notationVisibility: preferences.notationVisibility,
        size: Vector2(_gameWidth, _gameHeight),
      ),
    ]);

    overlays.addEntry(noTapUpOverlayId, (context, game) => GestureDetector(behavior: .opaque));
  }

  @override
  Future<void> onMount() async {
    await _onStatueChanged();
  }

  bool get canUndo => _contest.canUndo;
  void undo() {
    if (_allowUndoRedo) _contest.undo();
  }

  bool get canRedo => _contest.canRedo;
  void redo() {
    if (_allowUndoRedo) _contest.redo();
  }

  bool get finished => _contest.parliament.isGameFinished;
  bool get noHumans => _contest.noHumans;

  Future<Contest> _createContest() async {
    if (_saveLoadState) {
      final json = await load(_statePath);
      if (json != null) {
        return Contest.fromJson(json, onStateChanged: _onStatueChanged);
      }
    }

    return Contest(
      preferences.startIdeology,
      preferences.turnDirection,
      preferences.playerTypes.toList(),
      onStateChanged: _onStatueChanged,
    );
  }

  Future<void> _onStatueChanged() async {
    overlays.add(noTapUpOverlayId);
    _allowUndoRedo = true;
    if (_contest.noHumans) {
      return _showGameOverDialog("GAME OVER!");
    }
    if (_contest.parliament.isGameFinished) {
      return _showGameOverDialog("CONGRATULATION!", "${_contest.parliament.currentParty.ideology.title} win!");
    }
    if (_saveLoadState && _contest.parliament.isManoeuvreCompleted) {
      await save(_contest.toJson(), _statePath);
    }
    if (_contest.isCurHuman) {
      overlays.remove(noTapUpOverlayId);
      return;
    }
    _allowUndoRedo = false;
    Timer(preferences.gameSpeed.duration, () => _contest.aiAct(_aiMaxDepth));
  }

  Future<void> _showGameOverDialog(String title, [String? message]) => showDialog(
    context: buildContext!,
    barrierDismissible: false,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: message?.convert(Text.new),
      actions: <Widget>[
        TextButton(
          style: TextButton.styleFrom(textStyle: Theme.of(context).textTheme.labelLarge),
          child: const Text("Undo"),
          onPressed: () {
            Navigator.pop(context);
            undo();
          },
        ),
        TextButton(
          style: TextButton.styleFrom(textStyle: Theme.of(context).textTheme.labelLarge),
          child: const Text("Close"),
          onPressed: () {
            Navigator.pop(context); // pop the dialog
            Navigator.pop(context); // pop the game page
          },
        ),
      ],
    ),
  );
}
