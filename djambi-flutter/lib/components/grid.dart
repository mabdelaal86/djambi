import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame/extensions.dart';

import '../configs/common.dart';

class Grid extends PositionComponent with TapCallbacks {
  @override
  bool get debugMode => true;

  Grid({super.position}) : super(size: Constants.gridSize);

  @override
  void render(Canvas canvas) {
    //
  }

  @override
  void onTapUp(TapUpEvent event) {
    print("Grid clicked");
  }
}
