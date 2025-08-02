import 'package:flame/components.dart';

import '../../common/utils.dart';
import '../components.dart';
import '../configs.dart';
import 'base.dart';

class HomePage extends BasePage {
  // @override
  // bool get debugMode => true;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    await addAll([
      FlexComponent(
        anchor: Anchor.center,
        position: Anchor.center.ofSize(size),
        spacing: Configs.largeMargin,
        children: [
          RoundedButton(
            text: "New Game",
            size: Configs.largeBtnSize,
            onReleased: () => game.router.pushNamed("options"),
          ),
          RoundedButton(
            text: "About", // & Rules
            size: Configs.largeBtnSize,
            onReleased: () => game.router.pushNamed("about"),
          ),
          RoundedButton(
            text: "Settings",
            size: Configs.largeBtnSize,
            onReleased: () => game.router.pushNamed("settings"),
          ),
          TextComponent(
          text: 'From Minds and Hands \n Made in Egypt',
          ),
        ],
      ),
    ]);
  }
}
