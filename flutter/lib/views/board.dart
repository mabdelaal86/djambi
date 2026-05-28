import 'package:flame/components.dart';

import '../models.dart';
import 'dimensions.dart';
import 'renderers/grid.dart';
import 'renderers/margins.dart';
import 'renderers/movements.dart';
import 'renderers/pieces.dart';
import 'theme.dart';

class Board extends PositionComponent {
  final Contest contest;
  final BoardStyle boardStyle;
  final PieceTheme pieceTheme;
  final NotationVisibility notationVisibility;

  /// Exposed so DjambiGame can call onStateChanged() for animations.
  PiecesRenderer? piecesRenderer;

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
    final marginOffset = notationVisibility == NotationVisibility.none
        ? Dimensions.border
        : Dimensions.margin;

    piecesRenderer = PiecesRenderer(
      contest, boardStyle, pieceTheme, size: gridSize,
    );

    await addAll([
      MarginsRenderer(boardStyle, notationVisibility, size: size),
      PositionComponent(
        position: Vector2.all(marginOffset),
        children: [
          GridRenderer(boardStyle, pieceTheme, size: gridSize),
          MovementsRenderer(contest, boardStyle, size: gridSize),
          piecesRenderer!,
        ],
      ),
    ]);
  }
}
