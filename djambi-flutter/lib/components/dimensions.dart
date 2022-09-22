import 'package:flame/extensions.dart';

import '../models/common.dart';
import '../models/parliament.dart';

abstract class Dimensions {
  static const double cellSide = 1000;
  static const double pieceRadius = 400;
  static const double margin = 500;
  static final Vector2 cellSize = Vector2.all(cellSide);
  static final Vector2 gridSize = cellSize * Parliament.size.toDouble();
  static final Vector2 gridOffset = Vector2.all(margin);
  static final Vector2 boardSize = gridOffset + gridSize;
  static final Vector2 mazeOffset = gridOffset + cellSize * Parliament.maze.toDouble();
  static final Vector2 marginColCell = Vector2(cellSide, margin);
  static final Vector2 marginRowCell = Vector2(margin, cellSide);

  static Vector2 cellOffset(Cell cell) => gridOffset + cell.toVector2() * cellSide;
  static Vector2 cellCenterOffset(Cell cell) => cellOffset(cell) + cellSize / 2;
}
