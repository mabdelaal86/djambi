import 'package:flame/extensions.dart';
import 'package:flutter/painting.dart';

import '../../models/cell.dart';
import '../../models/contest.dart';
import '../../models/member.dart';
import '../../models/party.dart';
import '../dimensions.dart' as dimensions;
import '../theme.dart';
import '../utils.dart';

class MovementsRenderer {
  final Contest contest;
  final BoardTheme boardTheme;
  Member? _selectedMember;

  MovementsRenderer(this.contest, this.boardTheme);

  bool get _gameIsNotFinished => !contest.parliament.isGameFinished;
  Party get _curParty => contest.parliament.currentParty;
  Member? get _curActor => contest.parliament.actor;

  void render(Canvas canvas) {
    _markLastMovement(canvas);
    if (_gameIsNotFinished) {
      _markAvailableMoves(canvas);
    }
  }

  void onTapUp(Vector2 position) {
    if (_gameIsNotFinished) {
      final cell = dimensions.vector2cell(position - dimensions.gridOffset);
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
      _markCircle(canvas, cell, boardTheme.selectableMarkPaint);
    }
  }

  void _markSelected(Canvas canvas, Cell cell) {
    _paintRect(canvas, cell, boardTheme.selectedMarkPaint);
  }

  void _markActions(Canvas canvas, Iterable<Cell> cells) {
    for (final cell in cells) {
      _markCircle(canvas, cell, boardTheme.actionMarkPaint);
    }
  }

  void _markLastMovement(Canvas canvas) {
    for (final cell in contest.lastMovedCells) {
      _markRect(canvas, cell, boardTheme.movedMarkPaint);
    }
  }

  void _markCircle(Canvas canvas, Cell cell, Paint paint) {
    final offset = dimensions.cellCenterOffset(cell).toOffset();

    // draw circle
    const radius = dimensions.pieceRadius + dimensions.markStroke;
    canvas.drawCircle(offset, radius, paint..stroke());
  }

  void _markRect(Canvas canvas, Cell cell, Paint paint) {
    final offset = dimensions.cellCenterOffset(cell).toOffset();

    // draw rect
    const radius = dimensions.cellSide / 2 - dimensions.markStroke;
    final rect = Rect.fromCircle(center: offset, radius: radius);
    canvas.drawRect(rect, paint..stroke());
  }

  void _paintRect(Canvas canvas, Cell cell, Paint paint) {
    final offset = dimensions.cellOffset(cell);
    canvas.drawRect(offset & dimensions.cellSize, paint);
  }
}
