import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/material.dart';

import '../models/parliament.dart';
import 'dimensions.dart';
import 'renderers/background.dart';
import 'renderers/movements.dart';
import 'renderers/pieces.dart';

class Board extends PositionComponent with TapCallbacks {
  // @override
  // bool get debugMode => true;

  final Parliament parliament;

  final BackgroundRenderer _background;
  final MovementsRenderer _movements;
  final PiecesRenderer _pieces;

  Board(this.parliament, {super.position}):
        _background = BackgroundRenderer(),
        _movements = MovementsRenderer(parliament),
        _pieces = PiecesRenderer(parliament),
        super(size: Dimensions.boardSize);

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    await _background.init();
    await _pieces.init();
  }

  @override
  void render(Canvas canvas) {
    _background.render(canvas);
    _movements.render(canvas);
    _pieces.render(canvas);
  }

  @override
  void onTapUp(TapUpEvent event) {
    final position = event.localPosition - Dimensions.gridOffset;
    final cell = Dimensions.vector2cell(position);
    parliament.uiAct(cell);
  }
}
