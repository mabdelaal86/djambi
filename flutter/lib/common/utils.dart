import 'dart:ui';

import 'package:flame/components.dart';
import 'package:url_launcher/url_launcher.dart';

extension NotNullExtension<T> on T {
  R convert<R>(R Function(T e) fun) => fun(this);
}

extension AnchorExtension on Anchor {
  Vector2 ofSize(Vector2 size) => Vector2(x * size.x, y * size.y);
}

extension ColorExtension on Color {
  Paint toPaint() => Paint()..color = this;
}

Future<void> openUrl(String url) async {
  final uri = Uri.parse(url);
  if (!await launchUrl(uri)) {
    throw Exception("Couldn't launch '$url'");
  }
}
