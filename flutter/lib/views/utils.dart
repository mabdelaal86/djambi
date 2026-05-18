import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/flame.dart';
import 'package:flame_svg/flame_svg.dart' show Svg;
import 'package:flutter/painting.dart';

import '../common/utils.dart';
import '../models.dart';
import 'dimensions.dart';
import 'theme.dart';

final _cellSize = Vector2.all(Dimensions.cellSide);
final _pieceSize = Vector2.all(Dimensions.pieceRadius * 2);

extension ColorExtension on Color {
  Paint toPaint() => Paint()..color = this;
}

extension PaintExtension on Paint {
  void stroke(double width) {
    style = .stroke;
    strokeJoin = .round;
    strokeWidth = width;
  }
}

extension CanvasExtension on Canvas {
  void paintCellRect(Cell cell, Color color, [double? stroke]) {
    var rect = _cellOffset(cell) & _cellSize;
    final paint = color.toPaint();
    if (stroke != null) {
      rect = rect.deflate(stroke / 2);
      paint.stroke(stroke);
    }
    drawRect(rect, paint);
  }

  void paintCellCircle(Cell? cell, Color color, [double? stroke, double peel = 0]) {
    final offset = cell?.convert(_cellCenterOffset).toOffset() ?? Offset.zero;
    var radius = Dimensions.pieceRadius + peel;
    final paint = color.toPaint();
    if (stroke != null) {
      radius += stroke / 2;
      paint.stroke(stroke);
    }
    drawCircle(offset, radius, paint);
  }

  void paintCellSvg(Cell? cell, Svg image) {
    if (cell == null) {
      image.renderPosition(this, Vector2.all(-Dimensions.pieceRadius), _pieceSize);
    } else {
      renderAt(cell.convert(_cellCenterOffset), (_) {
        image.renderPosition(this, Vector2.all(-Dimensions.pieceRadius), _pieceSize);
      });
    }
  }
}

extension AnchorExtension on Anchor {
  Vector2 ofSize(Vector2 size) => Vector2(x * size.x, y * size.y);
}

Future<Svg> loadPieceImage(Role role, PieceTheme theme, Color color) async {
  final fileContent = await Flame.assets.readFile("images/${theme.name}/${role.name}.svg");
  final svgString = fileContent.replaceFirst(
    "fill:#000000;fill-opacity:1",
    "fill:#${_hex(color.r)}${_hex(color.g)}${_hex(color.b)};fill-opacity:${color.a}",
  );
  return Svg.loadFromString(svgString);
}

String _hex(double v) => (v * 255).round().toRadixString(16).padLeft(2, "0");

Vector2 _cellOffset(Cell cell) => Vector2(cell.x * Dimensions.cellSide, cell.y * Dimensions.cellSide);
Vector2 _cellCenterOffset(Cell cell) => _cellOffset(cell) + _cellSize / 2;
