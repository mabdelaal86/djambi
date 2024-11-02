import 'package:flame/components.dart';

import '../buttons.dart';
import '../configs.dart' as configs;
import '../header.dart';
import 'base.dart';

class HomePage extends BasePage {
  // @override
  // bool get debugMode => true;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    await addAll([
      Header(),
      PositionComponent(
        anchor: Anchor.center,
        position: size * 0.5,
        size: Vector2(
          configs.largeBtnSize.x,
          configs.largeBtnSize.y * 3 + configs.largeMargin * 2,
        ),
        children: [
          RoundedButton(
            text: "New Game",
            size: configs.largeBtnSize,
            position: Vector2(0, 0),
            onReleased: () => game.router.pushNamed("options"),
          ),
          RoundedButton(
            text: "About & Rules",
            size: configs.largeBtnSize,
            position: Vector2(0, configs.largeBtnSize.y + configs.largeMargin),
            onReleased: () {},
          ),
          RoundedButton(
            text: "Settings",
            size: configs.largeBtnSize,
            position: Vector2(0, 2 * (configs.largeBtnSize.y + configs.largeMargin)),
            onReleased: () {},
          ),
        ],
      ),
    ]);
  }
}
