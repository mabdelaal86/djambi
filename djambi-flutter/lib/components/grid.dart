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

  late final Parliament parliament;

  Grid(this.parliament) : super(position: Dimensions.gridOffset, size: Dimensions.gridSize);

  @override
  void render(Canvas canvas) {
    //
  }

  @override
  void onTapUp(TapUpEvent event) {
    final Cell cell = Cell.fromVector2(event.localPosition, factor: Dimensions.cellSide);
    final Member? member = parliament.allMembers().firstWhereOrNull((p) => p.cell == cell);

    if (member != null) {
      print("Member clicked: ${member.role}");
      final x = parliament.nextPlayer();
      print(x);
      parliament.nextTurn();
      final y = parliament.nextPlayer();
      print(y);
    }
    else {
      print("Grid clicked");
    }
  }
}
