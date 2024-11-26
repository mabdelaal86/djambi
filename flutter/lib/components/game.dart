import 'package:flame/components.dart';
import 'package:flame/game.dart';

import 'configs.dart' as configs;
import 'options.dart';
import 'pages/home.dart';
import 'pages/options.dart';
import 'pages/play.dart';
import 'pages/settings.dart';
import 'settings.dart';

class DjambiGame extends FlameGame {
  late final RouterComponent router;
  final Options options = Options();
  final Settings settings = Settings();

  DjambiGame() : super(
    camera: CameraComponent.withFixedResolution(
        width: configs.gameWidth,
        height: configs.gameHeight,
    ),
  );

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    camera.viewfinder.anchor = Anchor.topLeft;
    await settings.load();

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
