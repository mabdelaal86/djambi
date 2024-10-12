import 'package:flame/game.dart';

import 'pages/home.dart';
import 'pages/options.dart';
import 'pages/play.dart';

class DjambiGame extends FlameGame {
  late final RouterComponent router;

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
