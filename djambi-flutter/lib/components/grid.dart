import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame/extensions.dart';

import '../models/piece.dart';
import '../models/tourney.dart';
import 'dimensions.dart';

class Grid extends PositionComponent with TapCallbacks {
  // @override
  // bool get debugMode => true;

  late final Tourney tourney;

  Grid(this.tourney) : super(position: Dimensions.gridOffset, size: Dimensions.gridSize);

  @override
  void render(Canvas canvas) {
    //
  }

  @override
  void onTapUp(TapUpEvent event) {
    final Point<int> cell = event.localPosition.toPoint() ~/ 1000;
    final Piece? piece = tourney.allPieces().firstWhereOrNull((p) => p.cell == cell);

    if (piece != null) {
      print("Piece clicked: ${piece.type}");
    }
    else {
      print("Grid clicked");
    }
  }
}
