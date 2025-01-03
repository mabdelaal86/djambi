import 'package:flame/extensions.dart';

import '../models/cell.dart';
import '../models/constants.dart' as constants;

const cellSide = 100.0;
const gridSide = cellSide * constants.sideCellsCount;
const pieceRadius = 40.0;
const pieceFontSize = 50.0;
const pieceStroke = 3.0;
const margin = 32.0;
const marginFontSize = 30.0;
const markStroke = 4.0;
final cellSize = Vector2.all(cellSide);
final pieceSize = Vector2.all(pieceRadius * 2);
final gridSize = Vector2.all(gridSide);
final marginSize = Vector2.all(margin);
final mazeOffset = cellOffset(const Cell.maze());
final mazeCentralOffset = mazeOffset + cellSize / 2;
final marginColCell = Vector2(cellSide, margin);
final marginRowCell = Vector2(margin, cellSide);

Vector2 cellOffset(Cell cell) => cell.toVector2() * cellSide;
Vector2 cellCenterOffset(Cell cell) => cellOffset(cell) + cellSize / 2;
Cell vector2cell(Vector2 v) => Cell(v.x ~/ cellSide, v.y ~/ cellSide);
