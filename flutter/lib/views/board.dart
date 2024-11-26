import 'package:flame/components.dart';

import '../models/contest.dart';
import 'dimensions.dart' as dimensions;
import 'renderers/background.dart';
import 'renderers/margins.dart';
import 'renderers/movements.dart';
import 'renderers/pieces.dart';
import 'theme.dart';
import 'utils.dart';

class Board extends PositionComponent {
  // @override
  // bool get debugMode => true;

  final Contest contest;
  final BoardTheme boardTheme;
  final PieceTheme pieceTheme;
  final MarginsVisibility showMargins;

  late final MovementsRenderer _movements;

  bool get enableTapUp => _movements.enableTapUp;
  set enableTapUp(bool value) => _movements.enableTapUp = value;

  Board(
      this.contest,
      this.boardTheme,
      this.pieceTheme,
      this.showMargins,
      {super.position, super.anchor, super.scale})
      : super(size: calcBoardSize(showMargins));

  @override
  Future<void> onLoad() async {
    final margins = Vector2.all(showMargins == MarginsVisibility.none ? 0 : dimensions.margin);
    await super.onLoad();
    await addAll([
      MarginsRenderer(boardTheme, showMargins),
      BackgroundRenderer(boardTheme, pieceTheme, position: margins),
      _movements = MovementsRenderer(contest, boardTheme, position: margins),
      PiecesRenderer(contest, boardTheme, pieceTheme, position: margins),
    ]);
  }
}
