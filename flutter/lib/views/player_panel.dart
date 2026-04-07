import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame_svg/flame_svg.dart';
import 'package:flutter/painting.dart';

import '../models.dart';
import 'dimensions.dart';
import 'theme.dart';
import 'utils.dart';

const _fontSize = 32.0;
const _fontStroke = 8.0;

class PlayerPanel extends PositionComponent {
  // @override
  // bool get debugMode => true;

  final Contest contest;
  final Ideology ideology;
  final BoardStyle boardStyle;
  final PieceTheme pieceTheme;

  late final Svg _chiefImage;
  final String playerName;
  late final TextPainter _playerNameStroke, _playerNameAlive, _playerNameDead, _nextSign;

  PlayerPanel(
    this.contest,
    this.ideology,
    this.boardStyle,
    this.pieceTheme, {
    super.anchor,
    super.position,
    super.scale,
    super.size,
  }) : playerName = "${ideology.name} - ${contest.playerTypes[ideology.index].isHuman ? 'human' : 'ai'}".toUpperCase(),
       _nextSign = _textPainter("[NEXT]", boardStyle.selectableMarkColor.toPaint()) {
    _playerNameStroke = _textPainter(playerName, boardStyle.pieceEdgeColor.toPaint()..stroke(_fontStroke));
    _playerNameDead = _textPainter(playerName, boardStyle.deadColor.toPaint());
    _playerNameAlive = _textPainter(playerName, boardStyle.partyColor[ideology.index].toPaint());
  }

  @override
  Future<void> onLoad() async {
    _chiefImage = await loadPieceImage(Role.chief, pieceTheme, boardStyle.pieceForeColor);
  }

  @override
  void render(Canvas canvas) {
    final party = contest.parliament.getParty(ideology);
    _drawBackground(canvas);
    _drawPlayerImage(canvas, party);
    _drawPlayerName(canvas, party);
  }

  void _drawBackground(Canvas canvas) {
    final rect = RRect.fromRectAndRadius(size.toRect(), const Radius.circular(20));
    canvas.drawRRect(rect, boardStyle.darkCellColor.toPaint());
  }

  void _drawPlayerImage(Canvas canvas, Party party) {
    canvas.renderAt(Vector2.all(size.y / 2), (_) {
      if (party == contest.parliament.currentParty) {
        canvas.paintCellCircle(null, boardStyle.selectableMarkColor, Dimensions.markStroke, Dimensions.pieceStroke);
      }
      canvas.paintCellCircle(null, boardStyle.pieceEdgeColor, Dimensions.pieceStroke);
      canvas.paintCellCircle(null, party.chief.isDead ? boardStyle.deadColor : boardStyle.partyColor[ideology.index]);
      canvas.paintCellSvg(null, _chiefImage);
    });
  }

  void _drawPlayerName(Canvas canvas, Party party) {
    final nameOffset = Offset(size.y, size.y * 0.25);
    _playerNameStroke.paint(canvas, nameOffset);
    (party.chief.isDead ? _playerNameDead : _playerNameAlive).paint(canvas, nameOffset);
    if (contest.parliament.isGameFinished) return;
    if (party == contest.parliament.getNextTurnState().$2) {
      _nextSign.paint(canvas, Offset(size.y, size.y * 0.5));
    }
  }

  static TextPainter _textPainter(String text, Paint paint) => TextPainter(
    textDirection: TextDirection.ltr,
    text: TextSpan(
      text: text,
      style: TextStyle(foreground: paint, fontSize: _fontSize, fontWeight: .bold),
    ),
  )..layout();
}
