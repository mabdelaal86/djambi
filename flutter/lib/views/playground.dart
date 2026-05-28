import 'package:flame/components.dart';

import '../models.dart';
import 'board.dart';
import 'dimensions.dart';
import 'player_panel.dart';
import 'styles.dart';
import 'theme.dart';
import 'utils.dart';

class Playground extends PositionComponent {
  final Contest contest;
  final BoardTheme boardTheme;
  final PieceTheme pieceTheme;
  final NotationVisibility notationVisibility;

  /// Exposed so game can access piecesRenderer for animation callbacks.
  Board? board;

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
    await _buildLayout();
  }

  Future<void> rebuildLayout() async {
    removeAll(children.toList());
    board = null;
    await _buildLayout();
  }

  Future<void> _buildLayout() async {
    final boardStyle = getBoardStyle(boardTheme);
    final margins = Dimensions.margin * notationVisibility.index +
        Dimensions.border * notationVisibility.reversedIndex;
    final rawBoardSide = Dimensions.gridSide + margins;

    final isLandscape = size.x > size.y;
    const pad = 12.0;

    if (isLandscape) {
      await _buildLandscape(boardStyle, rawBoardSide, pad);
    } else {
      await _buildPortrait(boardStyle, rawBoardSide, pad);
    }
  }

  Future<void> _buildPortrait(
      BoardStyle boardStyle, double rawBoardSide, double pad) async {
    final availW = size.x - pad * 2;
    final boardScale = availW / rawBoardSide;
    final scaledBoard = rawBoardSide * boardScale;

    final remainH = size.y - scaledBoard - pad * 2;
    final panelH = ((remainH / 2) - pad).clamp(36.0, 100.0);
    final panelW = (availW / 2 - pad / 2).clamp(80.0, 280.0);

    board = Board(
      contest, boardStyle, pieceTheme, notationVisibility,
      anchor: Anchor.center,
      position: Vector2(size.x / 2, size.y / 2),
      size: Vector2.all(rawBoardSide),
      scale: Vector2.all(boardScale),
    );

    await addAll([
      board!,
      _panel(boardStyle, Ideology.green,
          anchor: Anchor.topLeft,
          pos: Vector2(pad, pad),
          sz: Vector2(panelW, panelH)),
      _panel(boardStyle, Ideology.yellow,
          anchor: Anchor.topRight,
          pos: Vector2(size.x - pad, pad),
          sz: Vector2(panelW, panelH)),
      _panel(boardStyle, Ideology.red,
          anchor: Anchor.bottomLeft,
          pos: Vector2(pad, size.y - pad),
          sz: Vector2(panelW, panelH)),
      _panel(boardStyle, Ideology.blue,
          anchor: Anchor.bottomRight,
          pos: Vector2(size.x - pad, size.y - pad),
          sz: Vector2(panelW, panelH)),
    ]);
  }

  Future<void> _buildLandscape(
      BoardStyle boardStyle, double rawBoardSide, double pad) async {
    final availH = size.y - pad * 2;
    final boardScale = availH / rawBoardSide;
    final scaledBoard = rawBoardSide * boardScale;

    final sideW =
        ((size.x - scaledBoard - pad * 4) / 2).clamp(60.0, 240.0);
    final panelH = (availH / 2 - pad / 2).clamp(36.0, 120.0);

    final boardX = pad + sideW + pad;

    board = Board(
      contest, boardStyle, pieceTheme, notationVisibility,
      anchor: Anchor.center,
      position: Vector2(boardX + scaledBoard / 2, size.y / 2),
      size: Vector2.all(rawBoardSide),
      scale: Vector2.all(boardScale),
    );

    await addAll([
      board!,
      _panel(boardStyle, Ideology.green,
          anchor: Anchor.topLeft,
          pos: Vector2(pad, pad),
          sz: Vector2(sideW, panelH)),
      _panel(boardStyle, Ideology.red,
          anchor: Anchor.bottomLeft,
          pos: Vector2(pad, size.y - pad),
          sz: Vector2(sideW, panelH)),
      _panel(boardStyle, Ideology.yellow,
          anchor: Anchor.topRight,
          pos: Vector2(size.x - pad, pad),
          sz: Vector2(sideW, panelH)),
      _panel(boardStyle, Ideology.blue,
          anchor: Anchor.bottomRight,
          pos: Vector2(size.x - pad, size.y - pad),
          sz: Vector2(sideW, panelH)),
    ]);
  }

  PlayerPanel _panel(
    BoardStyle boardStyle,
    Ideology ideology, {
    required Anchor anchor,
    required Vector2 pos,
    required Vector2 sz,
  }) =>
      PlayerPanel(
        contest, ideology, boardStyle, pieceTheme,
        anchor: anchor,
        position: pos,
        size: sz,
      );
}
