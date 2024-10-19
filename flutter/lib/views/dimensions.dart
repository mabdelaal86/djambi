import 'package:flame/extensions.dart';

import '../models/cell.dart';
import '../models/constants.dart' as constants;

const double cellSide = 100;
const double pieceRadius = 40;
const double pieceFontSize = 50;
const double pieceStroke = 3;
const double margin = 32;
const double marginFontSize = 30;
const double markStroke = 4;
final Vector2 cellSize = Vector2.all(cellSide);
final Vector2 pieceSize = Vector2.all(pieceRadius * 2);
final Vector2 gridSize = cellSize * constants.boardSize.toDouble();
final Vector2 gridOffset = Vector2.all(margin);
final Vector2 boardSize = gridOffset + gridSize;
final Vector2 mazeOffset = gridOffset + cellSize * constants.mazeIndex.toDouble();
final Vector2 mazeCentralOffset = mazeOffset + cellSize / 2;
final Vector2 marginColCell = Vector2(cellSide, margin);
final Vector2 marginRowCell = Vector2(margin, cellSide);

Vector2 cellOffset(Cell cell) => gridOffset + cell.toVector2() * cellSide;
Vector2 cellCenterOffset(Cell cell) => cellOffset(cell) + cellSize / 2;
Cell vector2cell(Vector2 v) => Cell(v.x ~/ cellSide, v.y ~/ cellSide);
