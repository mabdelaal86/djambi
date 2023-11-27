import 'package:flame/components.dart';
import 'package:flame/game.dart';

import '../views/dimensions.dart';
import '../views/state.dart';
import 'pages/play.dart';
import 'settings.dart';

class DjambiGame extends FlameGame {
  final state = GameState();
  final guiTheme = AppearanceSettings.instance.guiTheme;

  static CameraComponent _camera() => CameraComponent.withFixedResolution(
        width: Dimensions.boardSize.x,
        height: Dimensions.boardSize.y + Dimensions.cellSide);

  DjambiGame() : super(camera: _camera());

  @override
  Future<void> onLoad() async {
    final playPage = PlayPage(state);
    await world.add(playPage);
  }
}
