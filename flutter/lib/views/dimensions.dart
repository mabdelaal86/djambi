import 'package:flame/extensions.dart';

import '../models.dart';

// ignore: avoid_classes_with_only_static_members
abstract class Dimensions {
  static const cellSide = 100.0;
  static const gridSide = cellSide * Constants.sideCellsCount;
  static const pieceRadius = 40.0;
  static const pieceFontSize = 50.0;
  static const pieceStroke = 3.0;
  static const margin = 32.0;
  static const marginFontSize = 30.0;
  static const markStroke = 4.0;
  static final cellSize = Vector2.all(cellSide);
  static final pieceSize = Vector2.all(pieceRadius * 2);
  static final gridSize = Vector2.all(gridSide);
  static final marginSize = Vector2.all(margin);
  static final mazeOffset = cellOffset(const Cell.maze());
  static final mazeCentralOffset = mazeOffset + cellSize / 2;
  static final marginColCell = Vector2(cellSide, margin);
  static final marginRowCell = Vector2(margin, cellSide);
}

Vector2 cellOffset(Cell cell) => cell.toVector2() * Dimensions.cellSide;
Vector2 cellCenterOffset(Cell cell) => cellOffset(cell) + Dimensions.cellSize / 2;
Cell vector2cell(Vector2 v) => Cell(v.x ~/ Dimensions.cellSide, v.y ~/ Dimensions.cellSide);
