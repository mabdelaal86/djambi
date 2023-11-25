import 'package:flame/components.dart';
import 'package:flame/game.dart';

import '../views/board.dart';
import '../views/dimensions.dart';
import '../views/state.dart';
import 'pages/play.dart';
import 'settings.dart';

class DjambiGame extends FlameGame {
  final state = GameState();
  final boardTheme = AppearanceSettings.instance.boardTheme;
  final pieceTheme = AppearanceSettings.instance.pieceTheme;
  final guiTheme = AppearanceSettings.instance.guiTheme;

  static CameraComponent _camera() => CameraComponent.withFixedResolution(
        width: Dimensions.boardSize.x,
        height: Dimensions.boardSize.y + Dimensions.cellSide);

  DjambiGame() : super(camera: _camera());

  @override
  Future<void> onLoad() async {
    final board = Board(state, boardTheme, pieceTheme);
    final playPage = PlayPage(state);
    await playPage.add(board);
    await world.add(playPage);
  }
}
