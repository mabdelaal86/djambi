import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame_svg/svg.dart';

import '../../models.dart';
import '../dimensions.dart';
import '../theme.dart';
import '../utils.dart';

/// A piece position that is currently being animated from [from] to [to].
class _AnimatingPiece {
  final int memberId;
  final Offset from;
  final Offset to;
  double progress; // 0.0 → 1.0

  _AnimatingPiece({
    required this.memberId,
    required this.from,
    required this.to,
    this.progress = 0.0,
  });

  Offset get current => Offset.lerp(from, to, _ease(progress))!;

  /// Ease-out cubic for natural deceleration
  static double _ease(double t) => 1 - (1 - t) * (1 - t) * (1 - t);
}

class PiecesRenderer extends PositionComponent {
  final Contest contest;
  final BoardStyle boardStyle;
  final PieceTheme pieceTheme;

  /// Duration of each move animation in seconds
  static const _animDuration = 0.28;

  late final Map<Role, Svg> _memberImages;

  /// Currently animating pieces, keyed by member id
  final Map<int, _AnimatingPiece> _animating = {};

  /// Previous cell positions, to detect moves
  Map<int, Cell> _prevCells = {};

  /// Called by DjambiGame/Contest when a new state arrives.
  /// Starts animations for pieces whose cells changed.
  void onStateChanged() {
    final members = contest.parliament.members;
    for (final member in members) {
      final prev = _prevCells[member.id];
      if (prev != null && prev != member.location) {
        _animating[member.id] = _AnimatingPiece(
          memberId: member.id,
          from: _cellCenter(prev),
          to: _cellCenter(member.location),
        );
      }
    }
    _prevCells = {for (final m in members) m.id: m.location};
  }

  PiecesRenderer(
    this.contest,
    this.boardStyle,
    this.pieceTheme, {
    super.position,
    super.anchor,
    super.size,
    super.scale,
  });

  @override
  Future<void> onLoad() async {
    _memberImages = {
      for (final r in Role.values)
        r: await loadPieceImage(r, pieceTheme, boardStyle.pieceForeColor)
    };
    // Snapshot starting positions
    _prevCells = {
      for (final m in contest.parliament.members) m.id: m.location
    };
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (_animating.isEmpty) return;
    final done = <int>[];
    for (final anim in _animating.values) {
      anim.progress = (anim.progress + dt / _animDuration).clamp(0.0, 1.0);
      if (anim.progress >= 1.0) done.add(anim.memberId);
    }
    for (final id in done) {
      _animating.remove(id);
    }
  }

  @override
  void render(Canvas canvas) {
    _drawMembers(canvas);
    // Re-draw actor on top to keep it above other pieces
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
    final anim = _animating[member.id];
    if (anim != null) {
      _drawMemberAt(canvas, member, anim.current);
    } else {
      _drawMemberAt(canvas, member, _cellCenter(member.location));
    }
  }

  void _drawMemberAt(Canvas canvas, Member member, Offset center) {
    final r = Dimensions.pieceRadius;
    final fillColor = switch (member.state) {
      MemberState.dead => boardStyle.deadColor,
      MemberState.paralysed => boardStyle.paralysedColor,
      MemberState.active => boardStyle.partyColor[member.ideology.index],
    };

    // Edge circle
    canvas.drawCircle(center, r + Dimensions.pieceStroke / 2,
        boardStyle.pieceEdgeColor.toPaint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = Dimensions.pieceStroke);

    // Fill circle
    canvas.drawCircle(center, r, fillColor.toPaint());

    // SVG icon
    if (member.isAlive) {
      canvas.renderAt(
        Vector2(center.dx, center.dy),
        (_) => _memberImages[member.role]!.renderPosition(
          canvas,
          Vector2.all(-r),
          Vector2.all(r * 2),
        ),
      );
    }
  }

  static Offset _cellCenter(Cell cell) => Offset(
        (cell.x + 0.5) * Dimensions.cellSide,
        (cell.y + 0.5) * Dimensions.cellSide,
      );
}
