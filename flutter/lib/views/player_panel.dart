import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame_svg/flame_svg.dart';
import 'package:flutter/painting.dart';

import '../models.dart';
import 'dimensions.dart';
import 'theme.dart';
import 'utils.dart';

class PlayerPanel extends PositionComponent {
  final Contest contest;
  final Ideology ideology;
  final BoardStyle boardStyle;
  final PieceTheme pieceTheme;

  late Svg _chiefImage;
  final String _playerName;

  late TextPainter _nameStroke, _nameAlive, _nameDead, _nextLabel;
  double _lastFontSize = -1;

  PlayerPanel(
    this.contest,
    this.ideology,
    this.boardStyle,
    this.pieceTheme, {
    super.anchor,
    super.position,
    super.size,
  }) : _playerName =
           '${ideology.name} - ${contest.playerTypes[ideology.index].isHuman ? 'human' : 'ai'}'
               .toUpperCase();

  @override
  Future<void> onLoad() async {
    _chiefImage =
        await loadPieceImage(Role.chief, pieceTheme, boardStyle.pieceForeColor);
    _rebuildText();
  }

  // Font size: 28% of panel height, clamped
  double get _fontSize => (size.y * 0.28).clamp(8.0, 28.0);

  // Icon radius: 40% of half-height so it fits inside the panel
  double get _iconRadius => (size.y * 0.38).clamp(10.0, 32.0);

  void _rebuildText() {
    final fs = _fontSize;
    if ((fs - _lastFontSize).abs() < 0.5) return;
    _lastFontSize = fs;
    final sw = fs / 4;

    Paint stroke(Color c) => c.toPaint()
      ..style = PaintingStyle.stroke
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = sw;

    _nameStroke = _tp(_playerName, stroke(boardStyle.pieceEdgeColor), fs);
    _nameAlive  = _tp(_playerName, boardStyle.partyColor[ideology.index].toPaint(), fs);
    _nameDead   = _tp(_playerName, boardStyle.deadColor.toPaint(), fs);
    _nextLabel  = _tp('[NEXT]', boardStyle.selectableMarkColor.toPaint(), fs * 0.75);
  }

  @override
  void render(Canvas canvas) {
    _rebuildText();
    final party = contest.parliament.getParty(ideology);
    _drawBg(canvas);
    _drawIcon(canvas, party);
    _drawName(canvas, party);
  }

  void _drawBg(Canvas canvas) {
    canvas.drawRRect(
      RRect.fromRectAndRadius(size.toRect(), const Radius.circular(10)),
      boardStyle.darkCellColor.toPaint(),
    );
  }

  void _drawIcon(Canvas canvas, Party party) {
    final r = _iconRadius;
    final cx = size.y / 2;      // center X = half of panel height
    final cy = size.y / 2;      // center Y = middle of panel

    // Glow ring if current party
    if (party == contest.parliament.currentParty) {
      canvas.drawCircle(
        Offset(cx, cy),
        r + Dimensions.markStroke / 2 + Dimensions.pieceStroke,
        boardStyle.selectableMarkColor.toPaint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = Dimensions.markStroke,
      );
    }

    // Edge ring
    canvas.drawCircle(
      Offset(cx, cy),
      r + Dimensions.pieceStroke / 2,
      boardStyle.pieceEdgeColor.toPaint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = Dimensions.pieceStroke,
    );

    // Fill
    canvas.drawCircle(
      Offset(cx, cy),
      r,
      (party.chief.isDead
              ? boardStyle.deadColor
              : boardStyle.partyColor[ideology.index])
          .toPaint(),
    );

    // SVG icon — scale from Dimensions.pieceRadius to our desired r
    canvas.renderAt(
      Vector2(cx, cy),
      (_) {
        final sf = r / Dimensions.pieceRadius;
        canvas.save();
        canvas.scale(sf);
        _chiefImage.renderPosition(
          canvas,
          Vector2.all(-Dimensions.pieceRadius),
          Vector2.all(Dimensions.pieceRadius * 2),
        );
        canvas.restore();
      },
    );
  }

  void _drawName(Canvas canvas, Party party) {
    final fs = _fontSize;
    final nameX = size.y + 4.0; // start after the icon column
    final nameY = (size.y - fs * 1.8) / 2; // vertically centred

    _nameStroke.paint(canvas, Offset(nameX, nameY));
    (party.chief.isDead ? _nameDead : _nameAlive)
        .paint(canvas, Offset(nameX, nameY));

    if (contest.parliament.isGameFinished) return;
    if (party == contest.parliament.getNextTurnState().$2) {
      _nextLabel.paint(canvas, Offset(nameX, nameY + fs + 1));
    }
  }

  static TextPainter _tp(String text, Paint paint, double fontSize) =>
      TextPainter(
        textDirection: TextDirection.ltr,
        text: TextSpan(
          text: text,
          style: TextStyle(
            foreground: paint,
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
      )..layout();
}
