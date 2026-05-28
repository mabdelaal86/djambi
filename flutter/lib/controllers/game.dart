import 'dart:async';
import 'dart:convert';

import 'package:flame/game.dart';
import 'package:flame/components.dart' hide Timer;
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models.dart';
import '../views.dart';
import 'preferences.dart';

const noTapUpOverlayId = 'noTapUpOverlay';
const _saveKey = 'saved_game_v1';

class DjambiGame extends FlameGame {
  final Preferences preferences;
  final Color surface;

  late Contest _contest;
  Playground? _playground;
  bool _allowUndoRedo = false;
  bool _soundReady = false;

  final bool continueGame;

  DjambiGame({required this.preferences, required this.surface, this.continueGame = false});

  @override
  Color backgroundColor() => surface;

  @override
  Future<void> onLoad() async {
    camera.viewfinder.anchor = Anchor.topLeft;

    // Pre-load sounds (non-fatal if unavailable)
    try {
      await FlameAudio.audioCache.loadAll(
          ['move.wav', 'kill.wav', 'win.wav', 'select.wav']);
      _soundReady = true;
    } catch (_) {
      _soundReady = false;
    }

    _contest = await _createContest(continueGame: continueGame);
    _playground = Playground(
      _contest,
      boardTheme: preferences.boardTheme,
      pieceTheme: preferences.pieceTheme,
      notationVisibility: preferences.notationVisibility,
      size: size,
    );
    await world.add(_playground!);

    overlays.addEntry(
      noTapUpOverlayId,
      (context, game) => GestureDetector(behavior: HitTestBehavior.opaque),
    );
  }

  @override
  Future<void> onMount() async {
    await _onStateChanged();
  }

  @override
  void onGameResize(Vector2 newSize) {
    super.onGameResize(newSize);
    if (_playground != null) {
      _playground!.size = newSize;
      _playground!.rebuildLayout();
    }
  }

  // ── Public API ─────────────────────────────────────────────────────────────

  bool get canUndo => _contest.canUndo;
  void undo() {
    if (_allowUndoRedo) {
      _playSound('select.wav');
      _contest.undo();
    }
  }

  bool get canRedo => _contest.canRedo;
  void redo() {
    if (_allowUndoRedo) {
      _playSound('select.wav');
      _contest.redo();
    }
  }

  bool get finished => _contest.parliament.isGameFinished;
  bool get noHumans => _contest.noHumans;

  // ── Save / Restore ─────────────────────────────────────────────────────────

  static Future<bool> hasSavedGame() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_saveKey);
  }

  static Future<void> deleteSavedGame() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_saveKey);
  }

  Future<void> _saveGame() async {
    if (!_contest.parliament.isManoeuvreCompleted) return;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_saveKey, jsonEncode(_contest.toJson()));
    } catch (_) {}
  }

  // ── Contest creation ───────────────────────────────────────────────────────

  Future<Contest> _createContest({bool continueGame = false}) async {
    if (continueGame) {
      try {
        final prefs = await SharedPreferences.getInstance();
        final raw = prefs.getString(_saveKey);
        if (raw != null) {
          return Contest.fromJson(
            jsonDecode(raw) as Map<String, dynamic>,
            onStateChanged: _onStateChanged,
            onBeforeStateChanged: _onBeforeStateChanged,
            aiDifficulty: preferences.aiDifficulty,
          );
        }
      } catch (_) {}
    }
    return Contest(
      preferences.startIdeology,
      preferences.turnDirection,
      preferences.playerTypes.toList(),
      onStateChanged: _onStateChanged,
      onBeforeStateChanged: _onBeforeStateChanged,
      aiDifficulty: preferences.aiDifficulty,
    );
  }

  // ── State callbacks ────────────────────────────────────────────────────────

  /// Called immediately after a new parliament is committed — starts animations.
  void _onBeforeStateChanged() {
    _playground?.board?.piecesRenderer?.onStateChanged();
  }

  Future<void> _onStateChanged() async {
    overlays.add(noTapUpOverlayId);
    _allowUndoRedo = true;

    // Determine sound based on what changed
    final lastCells = _contest.lastMovedCells;
    final anyKill = _contest.parliament.members
        .any((m) => m.isDead && lastCells.contains(m.location));
    if (anyKill) {
      _playSound('kill.wav');
    } else if (lastCells.isNotEmpty) {
      _playSound('move.wav');
    }

    if (_contest.noHumans) {
      return _showGameOverDialog('GAME OVER!');
    }
    if (_contest.parliament.isGameFinished) {
      _playSound('win.wav');
      await DjambiGame.deleteSavedGame();
      return _showGameOverDialog(
        '${_contest.parliament.currentParty.ideology.name} win!'.toUpperCase(),
      );
    }

    // Persist state after every completed manoeuvre
    if (_contest.parliament.isManoeuvreCompleted) {
      _saveGame();
    }

    if (_contest.isCurHuman) {
      overlays.remove(noTapUpOverlayId);
      return;
    }
    _allowUndoRedo = false;
    Timer(preferences.gameSpeed.duration, () => _contest.aiAct());
  }

  void _playSound(String file) {
    if (!_soundReady || !preferences.soundEnabled) return;
    FlameAudio.play(file);
  }

  Future<void> _showGameOverDialog(String title, [String? message]) =>
      showDialog(
        context: buildContext!,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: Text(title),
          content: message != null ? Text(message) : null,
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.labelLarge),
              child: const Text('Undo'),
              onPressed: () {
                Navigator.pop(context);
                undo();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.labelLarge),
              child: const Text('Close'),
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );
}
