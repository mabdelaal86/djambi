import 'dart:typed_data';

import 'package:audioplayers/audioplayers.dart';

import '../models.dart';
import 'sound_synth.dart';

/// Game sound effects, fully synthesized in code (no bundled audio assets).
/// Owns a small pool of [AudioPlayer]s so that overlapping sounds (e.g. a
/// capture immediately followed by a chief-surrounded event in the same
/// turn) can play on top of each other instead of cutting one another off.
class SoundController {
  SoundController({this.enabled = true}) {
    _clips = {for (final effect in SoundEffect.values) effect: _render(effect)};
  }

  /// Master on/off switch; when false, [play] is a no-op. Kept mutable so
  /// the in-game mute toggle doesn't need to recreate the controller (and
  /// therefore doesn't need to re-synthesize all the clips).
  bool enabled;

  late final Map<SoundEffect, Uint8List> _clips;
  final List<AudioPlayer> _pool = [];
  var _nextPlayer = 0;

  static const _poolSize = 6;
  static const _synth = SoundSynth();

  /// Plays every sound implied by [events], one after another. A single
  /// action can imply more than one thing - e.g. capturing the last enemy
  /// chief produces both a `captureChief` and a `win` event - in which case
  /// both sounds play in the order they happened.
  Future<void> playForEvents(List<GameEvent> events) async {
    for (final event in events) {
      await play(_effectFor(event.type));
    }
  }

  Future<void> play(SoundEffect effect) async {
    if (!enabled) return;
    final player = _nextAudioPlayer();
    await player.play(BytesSource(_clips[effect]!, mimeType: "audio/wav"));
  }

  AudioPlayer _nextAudioPlayer() {
    if (_pool.length < _poolSize) {
      final player = AudioPlayer()..setReleaseMode(ReleaseMode.stop);
      _pool.add(player);
      return player;
    }
    final player = _pool[_nextPlayer % _pool.length];
    _nextPlayer++;
    return player;
  }

  void dispose() {
    for (final player in _pool) {
      player.dispose();
    }
  }

  static SoundEffect _effectFor(GameEventType type) => switch (type) {
    .move => .move,
    .kill => .kill,
    .captureChief => .captureChief,
    .chiefSurrounded => .chiefSurrounded,
    .bury => .bury,
    .win => .win,
  };

  static Uint8List _render(SoundEffect effect) => switch (effect) {
    .tapSelect => _renderTapSelect(),
    .move => _renderMove(),
    .kill => _renderKill(),
    .captureChief => _renderCaptureChief(),
    .chiefSurrounded => _renderChiefSurrounded(),
    .bury => _renderBury(),
    .win => _renderWin(),
  };

  // ------------------------------------
  // sound design
  // ------------------------------------

  /// A short, light double-tick - selecting a piece, or picking a
  /// destination cell for it.
  static Uint8List _renderTapSelect() {
    final blip = _synth.envelope(
      _synth.tone(frequency: 880, duration: const Duration(milliseconds: 40)),
      attack: const Duration(milliseconds: 3),
      decay: const Duration(milliseconds: 25),
    );
    return _synth.toWavBytes(blip);
  }

  /// A soft, low "slide" tone for a quiet, uneventful move.
  static Uint8List _renderMove() {
    final slide = _synth.envelope(
      _synth.tone(frequency: 320, endFrequency: 260, duration: const Duration(milliseconds: 90)),
      attack: const Duration(milliseconds: 5),
      decay: const Duration(milliseconds: 60),
    );
    return _synth.toWavBytes(slide);
  }

  /// A sharp noise "thud" for an ordinary capture.
  static Uint8List _renderKill() {
    final thud = _synth.mix([
      _synth.envelope(
        _synth.noise(duration: const Duration(milliseconds: 120), seed: 1),
        decay: const Duration(milliseconds: 110),
      ),
      _synth.envelope(
        _synth.tone(frequency: 180, endFrequency: 90, duration: const Duration(milliseconds: 140)),
        decay: const Duration(milliseconds: 130),
      ),
    ]);
    return _synth.toWavBytes(thud);
  }

  /// A heavier, lower variant of the capture thud, reserved for a chief
  /// going down - the most consequential kill in the game.
  static Uint8List _renderCaptureChief() {
    final hit = _synth.mix([
      _synth.envelope(
        _synth.noise(duration: const Duration(milliseconds: 180), seed: 2),
        decay: const Duration(milliseconds: 170),
      ),
      _synth.envelope(
        _synth.tone(frequency: 140, endFrequency: 55, duration: const Duration(milliseconds: 260)),
        decay: const Duration(milliseconds: 250),
      ),
    ]);
    return _synth.toWavBytes(hit);
  }

  /// A descending three-note "trapped" motif for a chief that died by
  /// being boxed in rather than directly attacked.
  static Uint8List _renderChiefSurrounded() {
    Float64List note(double freq) => _synth.envelope(
      _synth.tone(frequency: freq, duration: const Duration(milliseconds: 110)),
      attack: const Duration(milliseconds: 4),
      decay: const Duration(milliseconds: 70),
    );
    final motif = _synth.sequence([note(440), note(370), note(280)]);
    return _synth.toWavBytes(motif);
  }

  /// A dull, muffled double-knock for laying a body to rest.
  static Uint8List _renderBury() {
    Float64List knock() => _synth.mix([
      _synth.envelope(
        _synth.noise(duration: const Duration(milliseconds: 70), seed: 3),
        decay: const Duration(milliseconds: 65),
      ),
      _synth.envelope(
        _synth.tone(frequency: 110, duration: const Duration(milliseconds: 90)),
        decay: const Duration(milliseconds: 80),
      ),
    ]);
    final silence = Float64List((_synth.sampleRate * 0.05).round());
    final doubleKnock = _synth.sequence([knock(), silence, knock()]);
    return _synth.toWavBytes(doubleKnock);
  }

  /// A short, bright ascending fanfare for winning the game.
  static Uint8List _renderWin() {
    Float64List note(double freq, int ms) => _synth.envelope(
      _synth.tone(frequency: freq, duration: Duration(milliseconds: ms)),
      attack: const Duration(milliseconds: 5),
      decay: Duration(milliseconds: (ms * 0.6).round()),
    );
    final fanfare = _synth.sequence([note(523, 130), note(659, 130), note(784, 130), note(1046, 260)]);
    return _synth.toWavBytes(fanfare);
  }
}

/// All distinct sounds the game can play. `tapSelect` is purely a UI
/// interaction (selecting a piece/cell) and is triggered directly from the
/// input handler rather than via [GameEvent], since selection isn't a game
/// rule change.
enum SoundEffect { tapSelect, move, kill, captureChief, chiefSurrounded, bury, win }
