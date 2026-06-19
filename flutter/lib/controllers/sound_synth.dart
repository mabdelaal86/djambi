import 'dart:math';
import 'dart:typed_data';

/// Tiny self-contained PCM/WAV synthesizer used to generate this game's
/// sound effects entirely in code, with no bundled audio assets. Everything
/// here is pure - it only builds byte buffers - so it has no dependency on
/// Flutter or any audio plugin and is easy to keep in `controllers` next to
/// the thing that actually plays the bytes.
class SoundSynth {
  const SoundSynth({this.sampleRate = 44100});

  final int sampleRate;

  /// A plain sine wave tone, optionally sweeping linearly from [frequency]
  /// to [endFrequency] (a "chirp"), shaped by a short linear fade in/out so
  /// it doesn't click at the start/end.
  Float64List tone({
    required double frequency,
    required Duration duration,
    double? endFrequency,
    double amplitude = 1,
  }) {
    final sampleCount = (duration.inMicroseconds * sampleRate / Duration.microsecondsPerSecond).round();
    final samples = Float64List(sampleCount);
    final endFreq = endFrequency ?? frequency;
    var phase = 0.0;
    for (var i = 0; i < sampleCount; i++) {
      final progress = sampleCount <= 1 ? 0.0 : i / (sampleCount - 1);
      final instantFreq = frequency + (endFreq - frequency) * progress;
      phase += 2 * pi * instantFreq / sampleRate;
      samples[i] = sin(phase) * amplitude;
    }
    return samples;
  }

  /// White noise, useful as the basis of percussive "thud"/"clack" sounds.
  Float64List noise({required Duration duration, double amplitude = 1, int? seed}) {
    final sampleCount = (duration.inMicroseconds * sampleRate / Duration.microsecondsPerSecond).round();
    final random = Random(seed);
    return Float64List.fromList([for (var i = 0; i < sampleCount; i++) (random.nextDouble() * 2 - 1) * amplitude]);
  }

  /// Mixes multiple same-rate sample buffers together (e.g. a tone over a
  /// noise burst), summing and then re-normalising so the result never
  /// clips past +-1.
  Float64List mix(List<Float64List> layers) {
    final length = layers.map((l) => l.length).reduce(max);
    final result = Float64List(length);
    for (final layer in layers) {
      for (var i = 0; i < layer.length; i++) {
        result[i] += layer[i];
      }
    }
    return _normalise(result);
  }

  /// Concatenates buffers back to back, e.g. two short blips for a
  /// "tap-tap" selection sound.
  Float64List sequence(List<Float64List> parts) {
    final length = parts.fold(0, (sum, p) => sum + p.length);
    final result = Float64List(length);
    var offset = 0;
    for (final part in parts) {
      result.setRange(offset, offset + part.length, part);
      offset += part.length;
    }
    return result;
  }

  /// Applies a simple attack/decay envelope: a linear ramp up over
  /// [attack], then a linear ramp down to silence over the rest of the
  /// buffer (or [decay] if given, measured from the end).
  Float64List envelope(Float64List samples, {Duration attack = Duration.zero, Duration? decay}) {
    final result = Float64List.fromList(samples);
    final attackSamples = (attack.inMicroseconds * sampleRate / Duration.microsecondsPerSecond).round();
    final decaySamples = decay == null
        ? result.length
        : (decay.inMicroseconds * sampleRate / Duration.microsecondsPerSecond).round();
    for (var i = 0; i < result.length; i++) {
      if (i < attackSamples) {
        result[i] *= i / max(1, attackSamples);
      }
      final fromEnd = result.length - 1 - i;
      if (fromEnd < decaySamples) {
        result[i] *= fromEnd / max(1, decaySamples);
      }
    }
    return result;
  }

  Float64List _normalise(Float64List samples) {
    final peak = samples.fold(0.0, (m, s) => max(m, s.abs()));
    if (peak <= 1) return samples;
    return Float64List.fromList([for (final s in samples) s / peak]);
  }

  /// Encodes [samples] (expected range roughly -1..1) as a 16-bit PCM mono
  /// WAV file, returned as raw bytes ready to hand to an audio player.
  Uint8List toWavBytes(Float64List samples) {
    const bitsPerSample = 16;
    const channels = 1;
    final byteRate = sampleRate * channels * bitsPerSample ~/ 8;
    final blockAlign = channels * bitsPerSample ~/ 8;
    final dataSize = samples.length * blockAlign;
    final buffer = ByteData(44 + dataSize);

    void writeString(int offset, String value) {
      for (var i = 0; i < value.length; i++) {
        buffer.setUint8(offset + i, value.codeUnitAt(i));
      }
    }

    writeString(0, "RIFF");
    buffer.setUint32(4, 36 + dataSize, Endian.little);
    writeString(8, "WAVE");
    writeString(12, "fmt ");
    buffer.setUint32(16, 16, Endian.little); // fmt chunk size
    buffer.setUint16(20, 1, Endian.little); // PCM
    buffer.setUint16(22, channels, Endian.little);
    buffer.setUint32(24, sampleRate, Endian.little);
    buffer.setUint32(28, byteRate, Endian.little);
    buffer.setUint16(32, blockAlign, Endian.little);
    buffer.setUint16(34, bitsPerSample, Endian.little);
    writeString(36, "data");
    buffer.setUint32(40, dataSize, Endian.little);

    for (var i = 0; i < samples.length; i++) {
      final clamped = samples[i].clamp(-1.0, 1.0);
      final intSample = (clamped * 32767).round();
      buffer.setInt16(44 + i * 2, intSample, Endian.little);
    }

    return buffer.buffer.asUint8List();
  }
}
