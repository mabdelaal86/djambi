import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/game.dart';

import 'configs.dart';
import 'pages/about.dart';
import 'pages/home.dart';
import 'pages/options.dart';
import 'pages/play.dart';
import 'pages/settings.dart';
import 'preferences.dart';
import 'pages/language_player_explanation/english.dart';
import 'pages/language_player_explanation/arab.dart';
import 'pages/language_player_explanation/french.dart';
import 'pages/language_player_explanation/spanish.dart';
import 'pages/language_player_explanation/swedish.dart';
import 'pages/language_player_explanation/chinese.dart';

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
        "english": Route(GameSummaryEnglishGame.new, maintainState: false),
        "arabic": Route(GameSummaryArabicGame.new, maintainState: false),
        "spanish": Route(GameSummarySpanishGame.new, maintainState: false),
        "french": Route(GameSummaryFrenchGame.new, maintainState: false),
        "swedish": Route(GameSummarySwedishGame.new, maintainState: false),
        "chinese": Route(GameSummaryChineseGame.new, maintainState: false),        
      },  
      initialRoute: "home",
    ));
  }
}
