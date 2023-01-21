import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame/extensions.dart';

import '../models/parliament.dart';
import 'dimensions.dart';

class Grid extends PositionComponent with TapCallbacks {
  // @override
  // bool get debugMode => true;

  late final Parliament parliament;

  Grid(this.parliament)
      : super(position: Dimensions.gridOffset, size: Dimensions.gridSize);

  @override
  void render(Canvas canvas) {
    //
  }

  @override
  void onTapUp(TapUpEvent event) {
    final cell = Dimensions.vector2cell(event.localPosition);
    parliament.uiAct(cell);
  }
}
