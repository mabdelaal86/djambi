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
import 'dimensions.dart';
import 'extensions.dart';
import 'settings.dart';
import 'theme.dart';

class Pieces extends PositionComponent {
  // @override
  // bool get debugMode => true;

  late final Parliament parliament;
  GameTheme get _gameTheme => AppearanceSettings.instance.gameTheme;
  PieceTheme get _pieceTheme => AppearanceSettings.instance.pieceTheme;

  Pieces(this.parliament, {super.position})
      : super(size: Dimensions.boardSize);

  late final Map<Role, Svg> _memberImages;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    _memberImages = { for (final r in Role.values) r: await loadPieceSvg(r, _gameTheme.pieceForeColor) };
  }

  @override
  void render(Canvas canvas) {
    _markAvailableMoves(canvas);
    _drawMembers(canvas);
  }

  static Future<Svg> loadPieceSvg(Role role, Color color, {String style = "classic"}) async {
    String fileName = "$style/${role.name}.svg";
    final fileContent = await Flame.assets.readFile(fileName);
    final opacity = color.alpha.toDouble() / 0xff;
    final svgString = fileContent.replaceFirst(
        "fill:#000000;fill-opacity:1", "fill:${color.toHex()};fill-opacity:$opacity");
    return Svg(await svg.fromSvgString(svgString, svgString));
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
        _drawRoleClassicImage(canvas, member.role, centerOffset);
      } else {
        _drawRoleSymbol(canvas, member.role, centerOffset);
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

  void _drawRoleClassicImage(Canvas canvas, Role role, Offset offset) {
    final vector = offset.toVector2() - Vector2.all(Dimensions.pieceRadius);
    _memberImages[role]!.renderPosition(canvas, vector, Dimensions.pieceSize);
  }

  void _drawRoleSymbol(Canvas canvas, Role role, Offset offset) {
    final textPainter = TextPainter(textDirection: TextDirection.ltr)
      ..text = TextSpan(style: _gameTheme.pieceSymbolStyle, text: role.name[0].toUpperCase());
    textPainter.layout();
    textPainter.paint(canvas, offset + textPainter.size.toOffset() / -2);
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
