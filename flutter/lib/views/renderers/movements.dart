import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/painting.dart';

import '../../models.dart';
import '../dimensions.dart';
import '../theme.dart';
import '../utils.dart';

class MovementsRenderer extends PositionComponent with TapCallbacks {
  // @override
  // bool get debugMode => true;

  final Contest contest;
  final BoardStyle boardStyle;
  Member? _selectedMember;

  bool enableTapUp = true;

  MovementsRenderer(this.contest, this.boardStyle,
      {super.position, super.anchor, super.scale})
      : super(size: Dimensions.gridSize);

  bool get _gameIsNotFinished => !contest.parliament.isGameFinished;
  Party get _curParty => contest.parliament.currentParty;
  Member? get _curActor => contest.parliament.actor;

  @override
  void render(Canvas canvas) {
    _markLastMovement(canvas);
    if (_gameIsNotFinished) {
      _markAvailableMoves(canvas);
    }
  }

  @override
  void onTapUp(TapUpEvent event) {
    if (_gameIsNotFinished && enableTapUp) {
      final cell = vector2cell(event.localPosition);
      _handleCellTapUp(cell);
    }
  }

  void _markAvailableMoves(Canvas canvas) {
    // check if there is an actor (or ongoing manoeuvre)
    if (_curActor != null) {
      _markSelected(canvas, _curActor!.location);
      _markActions(canvas, _curActor!.cellsToAct());
      return;
    }
    // ---------------
    // no actor, so selection logic apply
    // mark selectable members
    _markSelectable(canvas, _curParty.movableMembers.map((m) => m.location));
    // check if there is a selected member
    if (_selectedMember == null) return;
    // ---------------
    // make sure selected member is from current party
    // might not, is AI clicked after selecting a member
    if (_selectedMember!.ideology != _curParty.ideology) {
      _selectedMember = null;
      return;
    }
    // ---------------
    // mark selected member
    _markSelected(canvas, _selectedMember!.location);
    _markActions(canvas, _selectedMember!.cellsToAct());
  }

  void _handleCellTapUp(Cell cell) {
    // check if there is an actor (or ongoing manoeuvre)
    if (_curActor != null) {
      _selectedMember = null; // just to make sure
      // check if actor can act on the selected cell
      if (_curActor!.cellsToAct().contains(cell)) {
        contest.doAction(_curActor!, cell);
      }
      return;
    }
    // ---------------
    // no actor, so selection logic apply
    if (_selectedMember == null) {
      final member = _curParty.getMemberAt(cell);
      if (member != null && member.cellsToAct().isNotEmpty) {
        _selectedMember = member;
      }
      return;
    }
    // ---------------
    // a member is selected
    // check if it is clicked again
    if (_selectedMember!.location == cell) {
      _selectedMember = null;
      return;
    }
    // ---------------
    // another cell is clicked
    // check if user try to select another member from current party
    final member = _curParty.getMemberAt(cell);
    if (member != null) {
      _selectedMember = null;
      if (member.cellsToAct().isNotEmpty) {
        _selectedMember = member;
      }
      return;
    }
    // ---------------
    // empty cell or an enemy is clicked
    // check if selected member can act on the selected cell
    if (_selectedMember!.cellsToAct().contains(cell)) {
      contest.doAction(_selectedMember!, cell);
    }
    _selectedMember = null;
  }

  void _markSelectable(Canvas canvas, Iterable<Cell> cells) {
    for (final cell in cells) {
      _markCircle(canvas, cell, boardStyle.selectableMarkPaint);
    }
  }

  void _markSelected(Canvas canvas, Cell cell) {
    _paintRect(canvas, cell, boardStyle.selectedMarkPaint);
  }

  void _markActions(Canvas canvas, Iterable<Cell> cells) {
    for (final cell in cells) {
      _markCircle(canvas, cell, boardStyle.actionMarkPaint);
    }
  }

  void _markLastMovement(Canvas canvas) {
    for (final cell in contest.lastMovedCells) {
      _markRect(canvas, cell, boardStyle.movedMarkPaint);
    }
  }

  void _markCircle(Canvas canvas, Cell cell, Paint paint) {
    final offset = cellCenterOffset(cell).toOffset();

    // draw circle
    const radius = Dimensions.pieceRadius + Dimensions.markStroke;
    canvas.drawCircle(offset, radius, paint..stroke());
  }

  void _markRect(Canvas canvas, Cell cell, Paint paint) {
    final offset = cellCenterOffset(cell).toOffset();

    // draw rect
    const radius = Dimensions.cellSide / 2 - Dimensions.markStroke;
    final rect = Rect.fromCircle(center: offset, radius: radius);
    canvas.drawRect(rect, paint..stroke());
  }

  void _paintRect(Canvas canvas, Cell cell, Paint paint) {
    final offset = cellOffset(cell);
    canvas.drawRect(offset & Dimensions.cellSize, paint);
  }
}
