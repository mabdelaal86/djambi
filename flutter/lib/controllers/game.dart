import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/game.dart';

import 'configs.dart';
import 'pages/about.dart';
import 'pages/base.dart';
import 'pages/home.dart';
import 'pages/options.dart';
import 'pages/play.dart';
import 'pages/settings.dart';
import 'preferences.dart';

class DjambiGame extends FlameGame {
  late final RouterComponent router;
  late final PreferencesController prefs;

  DjambiGame() : super(
    camera: CameraComponent.withFixedResolution(
      width: Configs.gameWidth,
      height: Configs.gameHeight,
    ),
  );

  @override
  Color backgroundColor() => Configs.pageBackground;

  @override
  Future<void> onLoad() async {
    camera.viewfinder.anchor = Anchor.topLeft;
    prefs = await PreferencesController.create();

    await world.add(router = RouterComponent(
      routes: {
        "about": Route(AboutPage.new, maintainState: false),
        "home": Route(HomePage.new),
        "options": Route(OptionsPage.new, maintainState: false),
        "play": Route(PlayPage.new, maintainState: false),
        "settings": Route(SettingsPage.new, maintainState: false),
      },
      initialRoute: "home",
    ));
  }

  void popPage() {
    final curPage = router.currentRoute.children.first as BasePage;
    curPage.onBackTapUp();
  }
}
