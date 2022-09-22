import 'package:collection/collection.dart';
import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame/extensions.dart';

import '../models/common.dart';
import '../models/member.dart';
import '../models/parliament.dart';
import 'dimensions.dart';

class Grid extends PositionComponent with TapCallbacks {
  // @override
  // bool get debugMode => true;

  late final Parliament tourney;

  Grid(this.tourney) : super(position: Dimensions.gridOffset, size: Dimensions.gridSize);

  @override
  void render(Canvas canvas) {
    //
  }

  @override
  void onTapUp(TapUpEvent event) {
    final Cell cell = event.localPosition.toCell(Dimensions.cellSide);
    final Member? piece = tourney.allMembers().firstWhereOrNull((p) => p.cell == cell);

    if (piece != null) {
      print("Piece clicked: ${piece.role}");
    }
    else {
      print("Grid clicked");
    }
  }
}
