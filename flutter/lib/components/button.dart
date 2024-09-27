import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/material.dart' show SystemMouseCursors;

mixin Hoverable on PositionComponent {
  bool onHoverEnter(PointerHoverInfo info) => false;
  bool onHoverExit(PointerHoverInfo info) => false;
}

class Button extends PositionComponent
    with TapCallbacks, Hoverable, HasGameRef {
  final String text;
  final Paint paint;
  final void Function() action;
  final void Function()? onHover;
  final void Function()? onExit;
  final RRect _rect;
  bool _isPressed =
      false; // Variable d'état pour suivre si le bouton est pressé

  Button({
    required this.action,
    required this.text,
    this.onHover,
    this.onExit,
    Color color = const Color(0xff757575),
    super.position,
    required super.size,
    super.anchor = Anchor.center,
  })  : paint = Paint()..color = color,
        _rect = RRect.fromRectAndRadius(
            size!.toRect(), Radius.circular(size.y / 4));

  @override
  Future<void> onLoad() async {
    await add(TextComponent(
      text: text,
      anchor: Anchor.center,
      position: size / 2,
    ));
  }

  @override
  void onTapUp(TapUpEvent event) {
    if (kDebugMode) {
      print('Button tapped: $text');
    }
    _isPressed = false; // Réinitialiser l'état lorsque le bouton est relâché
    paint.color = const Color(0xff757575); // Réinitialiser la couleur
    action(); // Exécuter l'action associée au bouton
    super.onTapUp(event);
    action();
  }

  @override
  void onTapDown(TapDownEvent event) {
    _isPressed = true; // Mettre à jour l'état lorsque le bouton est pressé
    paint.color = const Color(
        0xff555555); // Changer la couleur pour indiquer l'état pressé
    super.onTapDown(event);
  }

  @override
  bool onHoverEnter(PointerHoverInfo info) {
    onHover?.call();
    gameRef.mouseCursor = SystemMouseCursors.click;
    if (kDebugMode) {
      print('Hovering over button: $text');
    }
    return true;
  }

  @override
  bool onHoverExit(PointerHoverInfo info) {
    onExit?.call();
    gameRef.mouseCursor = SystemMouseCursors.basic;
    if (kDebugMode) {
      print('Stopped hovering over button: $text');
    }
    return true;
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRRect(_rect, paint);
  }
}
