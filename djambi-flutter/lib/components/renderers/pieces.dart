import 'package:flame/extensions.dart';
import 'package:flame_svg/svg.dart';
import 'package:flutter/material.dart';

import '../../models/common.dart';
import '../../models/member.dart';
import '../../models/parliament.dart';
import '../dimensions.dart';
import '../extensions.dart';
import '../settings.dart';
import '../theme.dart';

class PiecesRenderer {
  late final Parliament parliament;
  GameTheme get _gameTheme => AppearanceSettings.instance.gameTheme;
  PieceTheme get _pieceTheme => AppearanceSettings.instance.pieceTheme;

  PiecesRenderer(this.parliament);

  late final Map<Role, Svg> _memberImages;

  Future<void> init() async {
    _memberImages = {
      for (final r in Role.values)
        r: await Utils.loadImage(r.name, _gameTheme.pieceForeColor)
    };
  }

  void render(Canvas canvas) {
    _drawMembers(canvas);
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
}
