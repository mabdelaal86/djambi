import 'dart:async';

import 'package:flame/components.dart' hide Timer;
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../../models.dart';
import '../../views.dart';
import '../common/utils.dart';
import 'preferences.dart';
import 'serialization.dart';
import 'sound.dart';

const noTapUpOverlayId = "noTapUpOverlay";

const _gameWidth = 1000.0;
const _gameHeight = 1380.0;

/// used for developing and testing
const _saveLoadState = false;
const _statePath = "game.json";

class DjambiGame extends FlameGame {
  final Preferences preferences;
  final Color surface;

  late final Contest _contest;
  late final SoundController _sound;
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
    _sound = SoundController(enabled: preferences.soundEnabled);

    await world.addAll([
      Playground(
        _contest = await _createContest(),
        boardTheme: preferences.boardTheme,
        pieceTheme: preferences.pieceTheme,
        notationVisibility: preferences.notationVisibility,
        onTapSound: playTapSound,
        size: Vector2(_gameWidth, _gameHeight),
      ),
    ]);

    overlays.addEntry(noTapUpOverlayId, (context, game) => GestureDetector(behavior: .opaque));
  }

  @override
  void onRemove() {
    _sound.dispose();
    super.onRemove();
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

  /// Lets the board renderer play a tap/select sound directly, since
  /// selecting a piece or a destination cell is a pure UI interaction and
  /// not a [GameEvent] produced by the models layer.
  void playTapSound() {
    _sound.enabled = preferences.soundEnabled;
    _sound.play(SoundEffect.tapSelect);
  }

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
    _sound.enabled = preferences.soundEnabled;
    unawaited(_sound.playForEvents(_contest.lastEvents));
    if (_contest.noHumans) {
      return _showGameOverDialog("GAME OVER!");
    }
    if (_contest.parliament.isGameFinished) {
      return _showGameOverDialog("${_contest.parliament.currentParty.ideology.name} win!".toUpperCase());
    }
    if (_saveLoadState && _contest.parliament.isManoeuvreCompleted) {
      await save(_contest.toJson(), _statePath);
    }
    if (_contest.isCurHuman) {
      overlays.remove(noTapUpOverlayId);
      return;
    }
    _allowUndoRedo = false;
    Timer(preferences.gameSpeed.duration, () => _contest.aiAct());
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
