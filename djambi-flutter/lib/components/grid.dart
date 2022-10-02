import 'package:collection/collection.dart';
import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame/extensions.dart';

import '../models/common.dart';
import '../models/manoeuvre.dart';
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
    final Cell cell = Dimensions.vector2cell(event.localPosition);
    final Member? member = parliament.members.firstWhereOrNull((p) => p.cell == cell);

    final manoeuvre = parliament.currentManoeuvre;
    if (member != null) {
      if (manoeuvre.stage == Stage.move1) {
        manoeuvre.deselect();
      }
      if (manoeuvre.stage == Stage.select) {
        manoeuvre.select(member);
      }
    }
    else {
      if (cell.isMaze) {
        parliament.nextTurn();
      }
      else if (manoeuvre.stage == Stage.move1) {
        manoeuvre.move(cell);
      }
    }
  }
}
