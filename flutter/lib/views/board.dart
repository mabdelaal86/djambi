import 'package:flame/components.dart';

import '../models.dart';
import 'dimensions.dart';
import 'renderers/background.dart';
import 'renderers/margins.dart';
import 'renderers/movements.dart';
import 'renderers/pieces.dart';
import 'styles.dart';
import 'theme.dart';

class Board extends PositionComponent {
  // @override
  // bool get debugMode => true;

  final Contest contest;
  final BoardStyle boardStyle;
  final PieceTheme pieceTheme;
  final MarginsVisibility marginsVisibility;

  late final MovementsRenderer _movements;

  bool get enableTapUp => _movements.enableTapUp;
  set enableTapUp(bool value) => _movements.enableTapUp = value;

  Board(
      this.contest,
      BoardTheme boardTheme,
      this.pieceTheme,
      this.marginsVisibility,
      {super.position, super.anchor, super.scale})
      : boardStyle = getBoardStyle(boardTheme),
        super(size: _calcBoardSize(marginsVisibility));

  @override
  Future<void> onLoad() async {
    final margins = marginsVisibility == MarginsVisibility.none ?
        Vector2.zero() :
        Vector2.all(Dimensions.margin);
    await addAll([
      MarginsRenderer(boardStyle, marginsVisibility, size: size),
      BackgroundRenderer(boardStyle, pieceTheme, position: margins),
      _movements = MovementsRenderer(contest, boardStyle, position: margins),
      PiecesRenderer(contest, boardStyle, pieceTheme, position: margins),
    ]);
  }
}

Vector2 _calcBoardSize(MarginsVisibility visibility) => switch (visibility) {
  MarginsVisibility.none => Dimensions.gridSize,
  MarginsVisibility.half => Dimensions.gridSize + Dimensions.marginSize,
  MarginsVisibility.full => Dimensions.gridSize + Dimensions.marginSize * 2,
};
