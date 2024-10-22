import 'package:flame/game.dart';

import 'options.dart';
import 'pages/home.dart';
import 'pages/options.dart';
import 'pages/play.dart';
import 'settings.dart';

class DjambiGame extends FlameGame {
  late final RouterComponent router;
  final Options options = Options();
  final Settings settings = Settings();

  @override
  Future<void> onLoad() async {
    await add(router = RouterComponent(
      routes: {
        "home": Route(HomePage.new),
        "options": Route(OptionsPage.new, maintainState: false),
        "play": Route(PlayPage.new, maintainState: false),
      },
      initialRoute: "home",
    ));
  }
}
