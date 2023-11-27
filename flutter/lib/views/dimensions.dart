import 'package:flame/extensions.dart';

import '../models/cell.dart';
import '../models/common.dart';

abstract class Dimensions {
  static const double cellSide = 100;
  static const double pieceRadius = 40;
  static const double pieceFontSize = 50;
  static const double pieceStroke = 3;
  static const double margin = 32;
  static const double marginFontSize = 30;
  static const double markStroke = 4;
  static final Vector2 cellSize = Vector2.all(cellSide);
  static final Vector2 pieceSize = Vector2.all(pieceRadius * 2);
  static final Vector2 gridSize = cellSize * Constants.boardSize.toDouble();
  static final Vector2 gridOffset = Vector2.all(margin);
  static final Vector2 boardSize = gridOffset + gridSize;
  static final Vector2 mazeOffset = gridOffset + cellSize * Constants.mazeIndex.toDouble();
  static final Vector2 mazeCentralOffset = mazeOffset + cellSize / 2;
  static final Vector2 marginColCell = Vector2(cellSide, margin);
  static final Vector2 marginRowCell = Vector2(margin, cellSide);

  static Vector2 cellOffset(Cell cell) => gridOffset + cell.toVector2() * cellSide;
  static Vector2 cellCenterOffset(Cell cell) => cellOffset(cell) + cellSize / 2;
  static Cell vector2cell(Vector2 v) => Cell(v.x ~/ cellSide, v.y ~/ cellSide);
}
