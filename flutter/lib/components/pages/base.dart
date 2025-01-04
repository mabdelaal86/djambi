import 'dart:ui';

import 'package:flame/components.dart';
import 'package:meta/meta.dart';

import '../../common/utils.dart';
import '../configs.dart';
import '../game.dart';

abstract class BasePage extends PositionComponent with HasGameReference<DjambiGame> {
  // @override
  // bool get debugMode => true;

  @override
  @mustCallSuper
  Future<void> onLoad() async {
    size = game.size;
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRect(size.toRect(), Configs.pageBackground.toPaint());
  }
}
