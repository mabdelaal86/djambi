import 'package:flame/extensions.dart';
import 'package:flutter/material.dart';

import '../../models/cell.dart';
import '../../models/member.dart';
import '../../models/parliament.dart';
import '../../models/state.dart';
import '../dimensions.dart';
import '../extensions.dart';
import '../settings.dart';
import '../theme.dart';

class MovementsRenderer {
  final GameState gameState;
  Parliament get parliament => gameState.parliament;
  Member? _selectedMember;
  GameTheme get _gameTheme => AppearanceSettings.instance.gameTheme;

  MovementsRenderer(this.gameState);

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
    final actor = parliament.actor;
    if (actor != null) {
      _markSelected(canvas, actor.location);
      _markActions(canvas, actor.cellsToAct());
      return;
    }
    // ---------------
    // no actor, so selection logic apply
    // mark selectable members
    _markSelectable(canvas, parliament.currentParty.movableMembers.map((m) => m.location));
    // mark selected member if exists
    if (_selectedMember != null) {
      _markSelected(canvas, _selectedMember!.location);
      _markActions(canvas, _selectedMember!.cellsToAct());
    }
  }

  void _handleCellTapUp(Cell cell) {
    // check if there is an actor (or ongoing manoeuvre)
    final actor = parliament.actor;
    if (actor != null) {
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
      final member = parliament.getMemberAt(cell);
      if (member != null &&
          member.ideology == parliament.currentParty.ideology &&
          member.cellsToAct().isNotEmpty
      ) {
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
    for (final cell in cells) {
      _markCircle(canvas, cell, _gameTheme.selectMarkPaint);
    }
  }

  void _markSelected(Canvas canvas, Cell cell) {
    final offset = Dimensions.cellOffset(cell);
    canvas.drawRect(offset & Dimensions.cellSize, _gameTheme.selectMarkPaint);
  }

  void _markActions(Canvas canvas, Iterable<Cell> cells) {
    for (final cell in cells) {
      _markCircle(canvas, cell, _gameTheme.actionMarkPaint);
    }
  }

  void _markLastMovement(Canvas canvas) {
    for (final cell in gameState.lastMovementCells()) {
      _markRect(canvas, cell, _gameTheme.movedMarkPaint);
    }
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
}
