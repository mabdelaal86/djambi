import 'package:flame/components.dart';
import 'package:meta/meta.dart';

import '../game.dart';

abstract class BasePage extends PositionComponent with HasGameReference<DjambiGame> {
  // @override
  // bool get debugMode => true;

  @override
  @mustCallSuper
  void onLoad() {
    size = game.size;
  }
}
