import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/extensions.dart';

import '../../models.dart';
import '../dimensions.dart';
import '../theme.dart';
import '../utils.dart';

/// Draw last movements, selectable pieces, available movements for the
/// selected piece and pass tap-up events into the underlying models.
class MovementsRenderer extends PositionComponent with TapCallbacks {
  final Contest contest;
  final BoardStyle boardStyle;
  Member? _selectedMember;

  // ── Animation state ───────────────────────────────────────────────────────
  /// Cells that are currently animating a "flash" after a move.
  final Map<Cell, double> _flashCells = {}; // cell → remaining alpha (0-1)
  static const _flashDuration = 0.6; // seconds

  MovementsRenderer(this.contest, this.boardStyle,
      {super.position, super.anchor, super.size, super.scale});

  bool get _gameRunning => !contest.parliament.isGameFinished;
  Party get _curParty => contest.parliament.currentParty;
  Member? get _curActor => contest.parliament.actor;

  // ── Flame update loop ─────────────────────────────────────────────────────
  @override
  void update(double dt) {
    super.update(dt);
    if (_flashCells.isEmpty) return;
    final toRemove = <Cell>[];
    for (final entry in _flashCells.entries) {
      final next = entry.value - dt / _flashDuration;
      if (next <= 0) {
        toRemove.add(entry.key);
      } else {
        _flashCells[entry.key] = next;
      }
    }
    for (final c in toRemove) {
      _flashCells.remove(c);
    }
  }

  // ── Rendering ─────────────────────────────────────────────────────────────
  @override
  void render(Canvas canvas) {
    _markLastMovement(canvas);
    _drawFlashCells(canvas);
    if (_gameRunning) _markAvailableMoves(canvas);
  }

  void _drawFlashCells(Canvas canvas) {
    for (final entry in _flashCells.entries) {
      final alpha = entry.value; // 1 → 0
      final color = boardStyle.actionMarkColor.withValues(alpha: alpha);
      canvas.paintCellRect(entry.key, color);
    }
  }

  void _markAvailableMoves(Canvas canvas) {
    if (_curActor != null) {
      _markSelected(canvas, _curActor!.location);
      _markActions(canvas, _curActor!.cellsToAct());
      return;
    }
    _markSelectable(canvas, _curParty.movableMembers.map((m) => m.location));
    if (_selectedMember == null) return;
    if (_selectedMember!.ideology != _curParty.ideology) {
      _selectedMember = null;
      return;
    }
    _markSelected(canvas, _selectedMember!.location);
    _markActions(canvas, _selectedMember!.cellsToAct());
  }

  // ── Tap handling ──────────────────────────────────────────────────────────
  @override
  void onTapUp(TapUpEvent event) {
    if (_gameRunning) {
      final cell = Cell(
        event.localPosition.x ~/ Dimensions.cellSide,
        event.localPosition.y ~/ Dimensions.cellSide,
      );
      _handleCellTap(cell);
    }
  }

  void _handleCellTap(Cell cell) {
    if (_curActor != null) {
      _selectedMember = null;
      if (_curActor!.cellsToAct().contains(cell)) {
        _flashCells[cell] = 1.0; // start flash animation
        contest.doAction(_curActor!, cell);
      }
      return;
    }
    if (_selectedMember == null) {
      final member = _curParty.getMemberAt(cell);
      if (member != null && member.cellsToAct().isNotEmpty) {
        _selectedMember = member;
      }
      return;
    }
    if (_selectedMember!.location == cell) {
      _selectedMember = null;
      return;
    }
    final member = _curParty.getMemberAt(cell);
    if (member != null) {
      _selectedMember = null;
      if (member.cellsToAct().isNotEmpty) _selectedMember = member;
      return;
    }
    if (_selectedMember!.cellsToAct().contains(cell)) {
      _flashCells[cell] = 1.0;
      contest.doAction(_selectedMember!, cell);
    }
    _selectedMember = null;
  }

  // ── Mark helpers ──────────────────────────────────────────────────────────
  void _markSelectable(Canvas canvas, Iterable<Cell> cells) {
    for (final cell in cells) {
      canvas.paintCellCircle(
          cell, boardStyle.selectableMarkColor, Dimensions.markStroke, Dimensions.pieceStroke);
    }
  }

  void _markSelected(Canvas canvas, Cell cell) {
    canvas.paintCellRect(cell, boardStyle.selectedMarkColor);
  }

  void _markActions(Canvas canvas, Iterable<Cell> cells) {
    for (final cell in cells) {
      canvas.paintCellCircle(
          cell, boardStyle.actionMarkColor, Dimensions.markStroke, Dimensions.pieceStroke);
    }
  }

  void _markLastMovement(Canvas canvas) {
    for (final cell in contest.lastMovedCells) {
      canvas.paintCellRect(cell, boardStyle.movedMarkColor, Dimensions.markStroke);
    }
  }
}
