import 'package:flame/components.dart';

import '../button.dart';
import '../game.dart';
import '../header.dart';

class HomePage extends PositionComponent with HasGameReference<DjambiGame> {
  // @override
  // bool get debugMode => true;

  late final Button _startButton, _settingsButton, _aboutButton;

  @override
  Future<void> onLoad() async {
    await addAll([
      Header(),
      _startButton = Button(
        text: "Start",
        size: Vector2(300, 75),
        action: () => game.router.pushNamed("play"),
      ),
      _aboutButton = Button(
        text: "About & Rules",
        size: Vector2(300, 75),
        action: () {},
      ),
      _settingsButton = Button(
        text: "Settings",
        size: Vector2(300, 75),
        action: () {},
      ),
    ]);
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    _startButton.position = Vector2(size.x / 2, size.y / 3);
    _aboutButton.position = _startButton.position + Vector2(0, 100);
    _settingsButton.position = _aboutButton.position + Vector2(0, 100);
  }
}
