import '../models.dart';

abstract class Dimensions {
  static const cellSide = 100.0;
  static const gridSide = cellSide * Constants.sideCellsCount;
  static const pieceRadius = 40.0;
  static const pieceStroke = 3.0;
  static const markStroke = 6.0;
  // TODO: find a better name for margin/border
  static const margin = 32.0;
  static const border = 4.0;
}
