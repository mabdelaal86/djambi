import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame_svg/svg.dart';

import '../../models.dart';
import '../dimensions.dart';
import '../theme.dart';
import '../utils.dart';

class GridRenderer extends PositionComponent {
  // @override
  // bool get debugMode => true;

  final BoardStyle boardStyle;
  final PieceTheme pieceTheme;
  late final Svg _mazeImage;

  GridRenderer(this.boardStyle, this.pieceTheme, {super.position, super.anchor, super.size, super.scale});

  @override
  Future<void> onLoad() async {
    _mazeImage = await loadPieceImage(Role.chief, pieceTheme, boardStyle.mazeForeColor);
  }

  @override
  void render(Canvas canvas) {
    _paintBackground(canvas);
    _drawMaze(canvas);
    if (boardStyle.drawLines) {
      _drawLines(canvas);
    }
  }

  void _paintBackground(Canvas canvas) {
    for (final cell in Cell.allCells()) {
      canvas.paintCellRect(cell, cell.isDark ? boardStyle.darkCellColor : boardStyle.lightCellColor);
    }
  }

  void _drawMaze(Canvas canvas) {
    canvas.paintCellRect(Cell.maze, boardStyle.mazeBackColor);
    canvas.paintCellSvg(Cell.maze, _mazeImage);
  }

  void _drawLines(Canvas canvas) {
    // draw 10 vertical/horizontal lines with board height/width
    final linePaint = boardStyle.lineColor.toPaint();
    for (var i = 0; i <= Constants.sideCellsCount; i++) {
      final d = i * Dimensions.cellSide;
      canvas.drawLine(Offset(d, 0), Offset(d, size.y), linePaint);
      canvas.drawLine(Offset(0, d), Offset(size.x, d), linePaint);
    }
  }
}
