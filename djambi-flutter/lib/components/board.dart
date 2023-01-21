import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/flame.dart';
import 'package:flame_svg/svg.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart' show svg;

import '../models/cell.dart';
import '../models/common.dart';
import '../models/member.dart';
import '../models/parliament.dart';
import 'settings.dart';
import 'dimensions.dart';
import 'extensions.dart';
import 'theme.dart';

class Board extends PositionComponent {
  // @override
  // bool get debugMode => true;

  late final Parliament parliament;
  GameTheme get _gameTheme => AppearanceSettings.instance.gameTheme;
  PieceTheme get _pieceTheme => AppearanceSettings.instance.pieceTheme;

  Board(this.parliament, {super.position})
      : super(size: Dimensions.boardSize);

  late final Svg _mazeImage;
  late final Map<Role, Svg> _memberImages;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    _mazeImage = await _loadPieceSvg(Role.chief, _gameTheme.mazeForeColor);
    _memberImages = { for (final r in Role.values) r: await _loadPieceSvg(r, _gameTheme.pieceForeColor) };
  }

  @override
  void render(Canvas canvas) {
    _paintBackground(canvas);
    _drawMaze(canvas);
    _markAvailableMoves(canvas);
    if (AppearanceSettings.instance.drawLines) {
      _drawLines(canvas);
    }
    _writeIndexes(canvas);
    _drawMembers(canvas);
  }

  Future<Svg> _loadPieceSvg(Role role, Color color, {String style = "classic"}) async {
    String fileName = "$style/${role.name}.svg";
    final fileContent = await Flame.assets.readFile(fileName);
    final opacity = color.alpha.toDouble() / 0xff;
    final svgString = fileContent.replaceFirst(
        "fill:#000000;fill-opacity:1", "fill:${color.toHex()};fill-opacity:$opacity");
    return Svg(await svg.fromSvgString(svgString, svgString));
  }

  void _paintBackground(Canvas canvas) {
    // paint margin background
    canvas.drawRect(size.toRect(), _gameTheme.marginPaint);
    // paint cells background
    for (final cell in Cell.allCells()) {
      canvas.drawRect(
          Dimensions.cellOffset(cell) & Dimensions.cellSize,
          cell.isDark ? _gameTheme.darkCellPaint : _gameTheme.lightCellPaint
      );
    }
  }

  void _drawMaze(Canvas canvas) {
    canvas.drawRect(Dimensions.mazeOffset & Dimensions.cellSize, _gameTheme.mazePaint);
    final mazeOffset = Dimensions.mazeCentralOffset.toOffset();
    if (_pieceTheme == PieceTheme.classic) {
      _drawRoleClassicImage(canvas, _mazeImage, Dimensions.mazeCentralOffset.toOffset());
    } else {
      final symbolStyle = _gameTheme.pieceSymbolStyle.copyWith(color: _gameTheme.mazeForeColor);
      _drawRoleSymbol(canvas, Role.chief, mazeOffset, symbolStyle);
    }
  }

  void _drawLines(Canvas canvas) {
    // margins
    canvas.drawLine(Offset.zero, Offset(size.x, 0), _gameTheme.linePaint);
    canvas.drawLine(Offset.zero, Offset(0, size.y), _gameTheme.linePaint);
    // draw 10 vertical/horizontal lines with board height/width
    for (int i = 0; i <= Constants.boardSize; i++) {
      final d = Dimensions.margin + i * Dimensions.cellSide;
      canvas.drawLine(Offset(d, 0), Offset(d, size.y), _gameTheme.linePaint);
      canvas.drawLine(Offset(0, d), Offset(size.x, d), _gameTheme.linePaint);
    }
  }

  void _writeIndexes(Canvas canvas) {
    final textPainter = TextPainter(textDirection: TextDirection.ltr);

    void writeText(String text, Offset cellOffset, Vector2 cellSize) {
      textPainter.text = TextSpan(style: _gameTheme.marginTextStyle, text: text);
      textPainter.layout();
      final cellCenter = (cellSize - textPainter.size.toVector2()) / 2;
      textPainter.paint(canvas, cellOffset + cellCenter.toOffset());
    }

    const cols = "ABCDEFGHI", rows = "123456789";
    for (int i = 0; i < Constants.boardSize; i++) {
      final d = Dimensions.margin + i * Dimensions.cellSide;
      writeText(cols[i], Offset(d, 0), Dimensions.marginColCell);
      writeText(rows[i], Offset(0, d), Dimensions.marginRowCell);
    }
  }

  void _drawMembers(Canvas canvas) {
    for (final member in parliament.members) {
      _drawMember(canvas, member);
    }
  }

  void _drawMember(Canvas canvas, Member member) {
    final centerOffset = Dimensions.cellCenterOffset(member.location).toOffset();
    _paintMemberBackground(canvas, member, centerOffset);
    if (member.isAlive) {
      if (_pieceTheme == PieceTheme.classic) {
        _drawRoleClassicImage(canvas, _memberImages[member.role]!, centerOffset);
      } else {
        _drawRoleSymbol(canvas, member.role, centerOffset, _gameTheme.pieceSymbolStyle);
      }
    }
  }

  void _paintMemberBackground(Canvas canvas, Member member, Offset offset) {
    final bgPaint = member.isDead
        ? _gameTheme.deadPaint
        : _gameTheme.getPartyPaint(member.ideology);
    canvas.drawCircle(offset, Dimensions.pieceRadius, bgPaint);
    canvas.drawCircle(offset, Dimensions.pieceRadius, _gameTheme.pieceEdgePaint);
  }

  void _drawRoleSymbol(Canvas canvas, Role role, Offset offset, TextStyle style) {
    final textPainter = TextPainter(textDirection: TextDirection.ltr)
      ..text = TextSpan(style: style, text: role.name[0].toUpperCase());
    textPainter.layout();
    textPainter.paint(canvas, offset + textPainter.size.toOffset() / -2);
  }

  void _drawRoleClassicImage(Canvas canvas, Svg image, Offset offset) {
    final vector = offset.toVector2() - Vector2.all(Dimensions.pieceRadius);
    image.renderPosition(canvas, vector, Dimensions.pieceSize);
  }

  void _markAvailableMoves(Canvas canvas) {
    final actor = parliament.getActor();
    if (actor == null || actor.manoeuvre.isWaiting) {
      final cells = parliament.currentParty.members
          .where((m) => m.cellsToMove().isNotEmpty)
          .map((m) => m.location);
      _markSelectable(canvas, cells);
    }
    if (actor != null) {
      _markSelected(canvas, actor.location);
      _markActions(canvas, actor.cellsToAct());
    }
  }

  void _markSelectable(Canvas canvas, Iterable<Cell> cells) {
    for (final cell in cells) {
      _markCircle(canvas, cell, _gameTheme.cellMarkPaint);
    }
  }

  void _markSelected(Canvas canvas, Cell cell) {
    final offset = Dimensions.cellOffset(cell);
    canvas.drawRect(offset & Dimensions.cellSize, _gameTheme.cellMarkPaint);
  }

  void _markActions(Canvas canvas, Iterable<Cell> cells) {
    for (final cell in cells) {
      _markCircle(canvas, cell, _gameTheme.moveMarkPaint);
    }
  }

  void _markRect(Canvas canvas, Cell cell, Paint paint) {
    final offset = Dimensions.cellCenterOffset(cell).toOffset();
    const radius = Dimensions.cellSide / 2 - Dimensions.stroke;
    canvas.drawRect(
        Rect.fromCircle(center: offset, radius: radius), paint..stroke());
  }

  void _markCircle(Canvas canvas, Cell cell, Paint paint) {
    final offset = Dimensions.cellCenterOffset(cell).toOffset();
    const radius = Dimensions.pieceRadius + Dimensions.stroke;
    canvas.drawCircle(offset, radius, paint..stroke());
  }
}
