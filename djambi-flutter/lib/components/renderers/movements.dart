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
    _markAvailableMoves(canvas);
  }

  void onTapUp(Vector2 position) {
    final cell = Dimensions.vector2cell(position - Dimensions.gridOffset);
    _handleCellTapUp(cell);
  }

  void _markAvailableMoves(Canvas canvas) {
    if (parliament.isGameFinished) {
      return;
    }
    // ---------------
    // game is still going
    final actor = parliament.getActor();
    if (actor != null) {
      _markSelected(canvas, actor.location);
      _markActions(canvas, actor.cellsToAct());
      return;
    }
    // ---------------
    // no actor, so selection logic apply
    // mark selectable members
    final movableMembers = parliament.currentParty.members
        .where((m) => m.cellsToAct().isNotEmpty);
    _markSelectable(canvas, movableMembers.map((m) => m.location));
    // mark selected member if exists
    if (_selectedMember != null) {
      _markSelected(canvas, _selectedMember!.location);
      _markActions(canvas, _selectedMember!.cellsToAct());
    }
  }

  void _handleCellTapUp(Cell cell) {
    if (parliament.isGameFinished) {
      return;
    }
    // ---------------
    // game is still going
    // check if there is an actor (or ongoing manoeuvre)
    final actor = parliament.getActor();
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
