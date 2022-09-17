import 'dart:math';

import 'package:flame/extensions.dart';

import '../models/game.dart';

extension PointExtension on Point {
  Vector2 toVector2() => Vector2(x.toDouble(), y.toDouble());
  Point<int> operator ~/(int scale) => Point(x ~/ scale, y ~/ scale);
}

abstract class Dimensions {
  static const double cellSide = 1000;
  static const double pieceRadius = 400;
  static const double margin = 500;
  static final Vector2 cellSize = Vector2.all(cellSide);
  static final Vector2 gridSize = cellSize * Configs.boardCells.toDouble();
  static final Vector2 gridOffset = Vector2.all(margin);
  static final Vector2 boardSize = gridOffset + gridSize;
  static final Vector2 mazeOffset = gridOffset + cellSize * Configs.mazeIndex.toDouble();
  static final Vector2 marginColCell = Vector2(cellSide, margin);
  static final Vector2 marginRowCell = Vector2(margin, cellSide);

  static Vector2 cellOffset(Point<int> cell) =>
      gridOffset + cell.toVector2() * cellSide.toDouble();

  static Vector2 cellCenterOffset(Point<int> cell) => cellOffset(cell) + cellSize / 2;
}
