import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/widgets.dart';

class RoundedRectComponent extends PositionComponent with HasPaint {
  final Radius? _radius;

  RoundedRectComponent({
    super.position,
    super.anchor,
    super.size,
    super.scale,
    super.children,
    Paint? paint,
    Radius? radius,
  }) : _radius = radius {
    this.paint = paint ?? this.paint;
  }

  Radius get radius => _radius ?? Radius.circular(height / 2);

  @override
  void render(Canvas canvas) {
    canvas.drawRRect(
      RRect.fromRectAndRadius(size.toRect(), radius),
      paint,
    );
  }
}
