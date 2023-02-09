import 'package:flame/extensions.dart';
import 'package:flutter/material.dart';

import '../../models/cell.dart';
import '../../models/parliament.dart';
import '../dimensions.dart';
import '../extensions.dart';
import '../settings.dart';
import '../theme.dart';

class MovementsRenderer {
  late final Parliament parliament;
  GameTheme get _gameTheme => AppearanceSettings.instance.gameTheme;

  MovementsRenderer(this.parliament);

  void render(Canvas canvas) {
    _markAvailableMoves(canvas);
  }

  void onTapUp(Vector2 position) {
    final cell = Dimensions.vector2cell(position - Dimensions.gridOffset);
    parliament.uiAct(cell);
  }

  void _markAvailableMoves(Canvas canvas) {
    final actor = parliament.getActor();
    if (actor == null || actor.manoeuvre.isWaiting) {
      final cells = parliament.currentParty.members
          .where((m) => m.cellsToMove().isNotEmpty)
          .map((m) => m.location);
      _markSelectable(canvas, cells);
    }
    if (actor != null) {
      _markSelected(canvas, actor.location);
      _markActions(canvas, actor.cellsToAct());
    }
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
