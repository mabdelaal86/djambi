import 'package:flame/components.dart';

import '../../common/utils.dart';
import '../buttons/rounded.dart';
import '../configs.dart' as configs;
import '../header.dart';
import '../layout.dart';
import 'base.dart';

class HomePage extends BasePage {
  // @override
  // bool get debugMode => true;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    await addAll([
      Header(),
      MultiAlignComponent(
        anchor: Anchor.center,
        position: Anchor.center.ofSize(size),
        size: Vector2(
          configs.largeBtnSize.x,
          configs.largeBtnSize.y * 3 + configs.largeMargin * 2,
        ),
        alignedChildren: {
          Anchor.topCenter: RoundedButton(
            text: "New Game",
            size: configs.largeBtnSize,
            onReleased: () => game.router.pushNamed("options"),
          ),
          Anchor.center: RoundedButton(
            text: "About & Rules",
            size: configs.largeBtnSize,
            onReleased: () {},
          ),
          Anchor.bottomCenter: RoundedButton(
            text: "Settings",
            size: configs.largeBtnSize,
            onReleased: () => game.router.pushNamed("settings"),
          ),
        },
      ),
    ]);
  }
}
