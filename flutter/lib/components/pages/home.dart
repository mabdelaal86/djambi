import 'package:flame/components.dart';

import '../../common/utils.dart';
import '../buttons.dart';
import '../configs.dart' as configs;
import '../header.dart';
import '../layouts/flex.dart';
import 'base.dart';

class HomePage extends BasePage {
  // @override
  // bool get debugMode => true;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    await addAll([
      Header(),
      FlexComponent(
        anchor: Anchor.center,
        position: Anchor.center.ofSize(size),
        spacing: configs.largeMargin,
        children: [
          RoundedButton(
            text: "New Game",
            size: configs.largeBtnSize,
            onReleased: () => game.router.pushNamed("options"),
          ),
          RoundedButton(
            text: "About & Rules",
            size: configs.largeBtnSize,
            onReleased: () {},
          ),
          RoundedButton(
            text: "Settings",
            size: configs.largeBtnSize,
            onReleased: () => game.router.pushNamed("settings"),
          ),
        ],
      ),
    ]);
  }
}
