import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame_svg/svg.dart';
import 'package:flutter/painting.dart';

import '../../models.dart';
import '../dimensions.dart';
import '../theme.dart';
import '../utils.dart';

class PiecesRenderer extends PositionComponent {
  // @override
  // bool get debugMode => true;

  final Contest contest;
  final BoardStyle boardStyle;
  final PieceTheme pieceTheme;

  PiecesRenderer(this.contest, this.boardStyle, this.pieceTheme,
      {super.position, super.anchor, super.scale})
      : super(size: Dimensions.gridSize);

  late final Map<Role, Svg> _memberImages;

  @override
  Future<void> onLoad() async {
    _memberImages = {
      for (final r in Role.values)
        r: await loadImage(r.name, boardStyle.pieceForeColor)
    };
  }

  @override
  void render(Canvas canvas) {
    _drawMembers(canvas);
    // draw actor again to make sure it is shown on top of other members
    _drawActor(canvas);
  }

  void _drawMembers(Canvas canvas) {
    for (final member in contest.parliament.members) {
      _drawMember(canvas, member);
    }
  }

  void _drawActor(Canvas canvas) {
    if (contest.parliament.actor case final actor?) {
      _drawMember(canvas, actor);
    }
  }

  void _drawMember(Canvas canvas, Member member) {
    final centerOffset = cellCenterOffset(member.location).toOffset();
    _paintMemberBackground(canvas, member, centerOffset);
    if (member.isAlive) {
      switch (pieceTheme) {
        case PieceTheme.classic: _drawRoleClassicImage(canvas, member.role, centerOffset);
        case PieceTheme.characters: _drawRoleSymbol(canvas, member.role, centerOffset);
      }
    }
  }

  void _paintMemberBackground(Canvas canvas, Member member, Offset offset) {
    final bgPaint = switch (member.state) {
      MemberState.dead => boardStyle.deadPaint,
      MemberState.paralysed => boardStyle.paralysedPaint,
      MemberState.active => boardStyle.partyPaint[member.ideology.index],
    };
    canvas.drawCircle(offset, Dimensions.pieceRadius, bgPaint);
    canvas.drawCircle(offset, Dimensions.pieceRadius, boardStyle.pieceEdgePaint);
  }

  void _drawRoleClassicImage(Canvas canvas, Role role, Offset offset) {
    final vector = offset.toVector2() - Vector2.all(Dimensions.pieceRadius);
    _memberImages[role]!.renderPosition(canvas, vector, Dimensions.pieceSize);
  }

  void _drawRoleSymbol(Canvas canvas, Role role, Offset offset) {
    final textPainter = TextPainter(textDirection: TextDirection.ltr)
      ..text = TextSpan(
          style: boardStyle.pieceSymbolStyle,
          text: role.name[0].toUpperCase());
    textPainter.layout();
    textPainter.paint(canvas, offset + textPainter.size.toOffset() / -2);
  }
}
