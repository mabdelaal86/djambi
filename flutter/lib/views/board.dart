import 'package:flame/components.dart';

import '../models.dart';
import 'dimensions.dart';
import 'renderers/grid.dart';
import 'renderers/margins.dart';
import 'renderers/movements.dart';
import 'renderers/pieces.dart';
import 'theme.dart';

class Board extends PositionComponent {
  // @override
  // bool get debugMode => true;

  final Contest contest;
  final BoardStyle boardStyle;
  final PieceTheme pieceTheme;
  final NotationVisibility notationVisibility;

  Board(
    this.contest,
    this.boardStyle,
    this.pieceTheme,
    this.notationVisibility, {
    super.position,
    super.anchor,
    super.scale,
    super.size,
  });

  @override
  Future<void> onLoad() async {
    final gridSize = Vector2.all(Dimensions.gridSide);
    await addAll([
      MarginsRenderer(boardStyle, notationVisibility, size: size),
      // grid
      PositionComponent(
        position: Vector2.all(notationVisibility == .none ? Dimensions.border : Dimensions.margin),
        children: [
          GridRenderer(boardStyle, pieceTheme, size: gridSize),
          MovementsRenderer(contest, boardStyle, size: gridSize),
          PiecesRenderer(contest, boardStyle, pieceTheme, size: gridSize),
        ],
      ),
    ]);
  }
}
