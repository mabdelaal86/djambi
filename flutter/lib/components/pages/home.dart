import 'package:flame/components.dart';

import '../buttons.dart';
import '../configs.dart' as configs;
import '../game.dart';
import '../header.dart';

class HomePage extends PositionComponent with HasGameReference<DjambiGame> {
  // @override
  // bool get debugMode => true;

  @override
  Future<void> onLoad() async {
    const vrSep = 50.0;
    final vrStep = configs.largeBtnSize.y + vrSep;
    size = game.size;
    await addAll([
      Header(),
      PositionComponent(
        anchor: Anchor.center,
        position: size * 0.5,
        size: configs.largeBtnSize + Vector2(0, 2 * vrStep),
        children: [
          RoundedButton(
            text: "New Game",
            size: configs.largeBtnSize,
            position: Vector2(0, 0 * vrStep),
            onReleased: () => game.router.pushNamed("options"),
          ),
          RoundedButton(
            text: "About & Rules",
            size: configs.largeBtnSize,
            position: Vector2(0, 1 * vrStep),
            onReleased: () {},
          ),
          RoundedButton(
            text: "Settings",
            size: configs.largeBtnSize,
            position: Vector2(0, 2 * vrStep),
            onReleased: () {},
          ),
        ],
      ),
    ]);
  }
}
