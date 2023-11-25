import 'package:flame/extensions.dart';
import 'package:flutter/material.dart';

import '../../models/cell.dart';
import '../../models/member.dart';
import '../../models/parliament.dart';
import '../dimensions.dart';
import '../extensions.dart';
import '../state.dart';
import '../theme.dart';

class MovementsRenderer {
  final GameState gameState;
  Parliament get parliament => gameState.parliament;
  Member? _selectedMember;
  final BoardTheme boardTheme;

  MovementsRenderer(this.gameState, this.boardTheme);

  void render(Canvas canvas) {
    _markLastMovement(canvas);
    if (!parliament.isGameFinished) {
      _markAvailableMoves(canvas);
    }
  }

  void onTapUp(Vector2 position) {
    if (!parliament.isGameFinished) {
      final cell = Dimensions.vector2cell(position - Dimensions.gridOffset);
      _handleCellTapUp(cell);
    }
  }

  void _markAvailableMoves(Canvas canvas) {
    // check if there is an actor (or ongoing manoeuvre)
    if (parliament.actor case final actor?) {
      _markSelected(canvas, actor.location);
      _markActions(canvas, actor.cellsToAct());
      return;
    }
    // ---------------
    // no actor, so selection logic apply
    // mark selectable members
    _markSelectable(canvas, parliament.currentParty.movableMembers.map((m) => m.location));
    // check if there is a selected member
    if (_selectedMember == null) return;
    // ---------------
    // make sure selected member is from current party
    // might not, is AI clicked after selecting a member
    if (_selectedMember!.ideology != parliament.currentParty.ideology) {
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
    if (parliament.actor case final actor?) {
      _selectedMember = null; // just to make sure
      // check if actor can act on the selected cell
      if (actor.cellsToAct().contains(cell)) {
        gameState.doAction(actor, cell);
      }
      return;
    }
    // ---------------
    // no actor, so selection logic apply
    if (_selectedMember == null) {
      final member = parliament.currentParty.getMemberAt(cell);
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
    final member = parliament.currentParty.getMemberAt(cell);
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
      gameState.doAction(_selectedMember!, cell);
    }
    _selectedMember = null;
  }

  void _markSelectable(Canvas canvas, Iterable<Cell> cells) {
    cells.forEach((c) => _markCircle(canvas, c, boardTheme.selectableMarkPaint));
  }

  void _markSelected(Canvas canvas, Cell cell) {
    _paintRect(canvas, cell, boardTheme.selectedMarkPaint);
  }

  void _markActions(Canvas canvas, Iterable<Cell> cells) {
    cells.forEach((c) => _markCircle(canvas, c, boardTheme.actionMarkPaint));
  }

  void _markLastMovement(Canvas canvas) {
    gameState.lastMovementCells().forEach((c) => _markRect(canvas, c, boardTheme.movedMarkPaint));
  }

  void _markCircle(Canvas canvas, Cell cell, Paint paint) {
    final offset = Dimensions.cellCenterOffset(cell).toOffset();

    // draw circle
    const radius = Dimensions.pieceRadius + Dimensions.stroke;
    canvas.drawCircle(offset, radius, paint..stroke());
  }

  void _markRect(Canvas canvas, Cell cell, Paint paint) {
    final offset = Dimensions.cellCenterOffset(cell).toOffset();

    // draw rect
    const radius = Dimensions.cellSide / 2 - Dimensions.stroke;
    final rect = Rect.fromCircle(center: offset, radius: radius);
    canvas.drawRect(rect, paint..stroke());
  }

  void _paintRect(Canvas canvas, Cell cell, Paint paint) {
    final offset = Dimensions.cellOffset(cell);
    canvas.drawRect(offset & Dimensions.cellSize, paint);
  }
}
