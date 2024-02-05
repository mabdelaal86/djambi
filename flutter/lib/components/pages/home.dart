import 'package:flame/components.dart';

import '../buttons.dart';
import '../game.dart';
import '../header.dart';

class HomePage extends PositionComponent with HasGameReference<DjambiGame> {
  // @override
  // bool get debugMode => true;

  late final RoundedButton _newButton, _settingsButton, _aboutButton;

  @override
  Future<void> onLoad() async {
    await addAll([
      Header(),
      _newButton = RoundedButton(
        text: "New Game",
        size: Vector2(300, 75),
        onReleased: () => game.router.pushNamed("options"),
      ),
      _aboutButton = RoundedButton(
        text: "About & Rules",
        size: Vector2(300, 75),
        onReleased: () {},
      ),
      _settingsButton = RoundedButton(
        text: "Settings",
        size: Vector2(300, 75),
        onReleased: () {},
      ),
    ]);
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);

    const vrStep = 100;
    final hrMid = size.x / 2;
    var vrStart = size.y / 3;

    _newButton.position = Vector2(hrMid, vrStart);
    _aboutButton.position = Vector2(hrMid, vrStart += vrStep);
    _settingsButton.position = Vector2(hrMid, vrStart += vrStep);
  }
}
