import 'package:flame/components.dart';
import 'package:flame/game.dart';

import 'configs.dart';
import 'pages/home.dart';
import 'pages/options.dart';
import 'pages/play.dart';
import 'pages/settings.dart';

class DjambiGame extends FlameGame {
  late final RouterComponent router;

  DjambiGame() : super(
    camera: CameraComponent.withFixedResolution(
        width: Configs.gameWidth,
        height: Configs.gameHeight,
    ),
  );

  @override
  Future<void> onLoad() async {
    camera.viewfinder.anchor = Anchor.topLeft;

    await world.add(router = RouterComponent(
      routes: {
        "home": Route(HomePage.new),
        "options": Route(OptionsPage.new, maintainState: false),
        "play": Route(PlayPage.new, maintainState: false),
        "settings": Route(SettingsPage.new, maintainState: false),
      },
      initialRoute: "home",
    ));
  }
}
