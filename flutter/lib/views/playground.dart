import 'package:flame/components.dart';

import '../models.dart';
import 'board.dart';
import 'dimensions.dart';
import 'player_panel.dart';
import 'styles.dart';
import 'theme.dart';
import 'utils.dart';

const _ideologyAnchor = <Ideology, Anchor>{
  .red: .bottomLeft,
  .blue: .bottomRight,
  .yellow: .topRight,
  .green: .topLeft,
};

class Playground extends PositionComponent {
  // @override
  // bool get debugMode => true;

  final Contest contest;
  final BoardTheme boardTheme;
  final PieceTheme pieceTheme;
  final NotationVisibility notationVisibility;

  Playground(
    this.contest, {
    required this.boardTheme,
    required this.pieceTheme,
    required this.notationVisibility,
    super.position,
    super.size,
  });

  @override
  Future<void> onLoad() async {
    final padding = Vector2.all(20);
    final innerSize = size - padding * 2;
    final playerPanelSize = Vector2((innerSize.x - padding.x) / 2, (innerSize.y - size.x) / 2 - padding.y);
    final boardStyle = getBoardStyle(boardTheme);
    final margins = Dimensions.margin * notationVisibility.index + Dimensions.border * notationVisibility.reversedIndex;
    final boardSize = Vector2.all(Dimensions.gridSide + margins);
    await addAll([
      Board(
        contest,
        boardStyle,
        pieceTheme,
        notationVisibility,
        anchor: .center,
        position: Anchor.center.ofSize(size),
        size: boardSize,
        scale: Vector2.all(size.x / boardSize.x),
      ),
      PositionComponent(
        position: padding,
        size: innerSize,
        children: [
          for (final MapEntry(:key, :value) in _ideologyAnchor.entries)
            PlayerPanel(
              contest,
              key,
              boardStyle,
              pieceTheme,
              anchor: value,
              position: value.ofSize(innerSize),
              size: playerPanelSize,
            ),
        ],
      ),
    ]);
  }
}
