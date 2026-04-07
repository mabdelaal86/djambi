import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame_svg/svg.dart';

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

  PiecesRenderer(
    this.contest,
    this.boardStyle,
    this.pieceTheme, {
    super.position,
    super.anchor,
    super.size,
    super.scale,
  });

  late final Map<Role, Svg> _memberImages;

  @override
  Future<void> onLoad() async {
    _memberImages = {for (final r in Role.values) r: await loadPieceImage(r, pieceTheme, boardStyle.pieceForeColor)};
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
    canvas.paintCellCircle(member.location, boardStyle.pieceEdgeColor, Dimensions.pieceStroke);
    canvas.paintCellCircle(member.location, switch (member.state) {
      .dead => boardStyle.deadColor,
      .paralysed => boardStyle.paralysedColor,
      .active => boardStyle.partyColor[member.ideology.index],
    });
    if (member.isAlive) {
      canvas.paintCellSvg(member.location, _memberImages[member.role]!);
    }
  }
}
