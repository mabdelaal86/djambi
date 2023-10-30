import 'package:flame/components.dart';
import 'package:flame/game.dart';

import '../views/board.dart';
import '../views/dimensions.dart';
import '../views/state.dart';
import 'play_page.dart';

class DjambiGame extends FlameGame {
  final state = GameState();

  DjambiGame(): super(
      camera: CameraComponent.withFixedResolution(
          width: Dimensions.boardSize.x,
          height: Dimensions.boardSize.y + Dimensions.cellSide,
      ));

  @override
  Future<void> onLoad() async {
    final board = Board(state);
    final playPage = PlayPage(state);
    await playPage.add(board);
    await world.add(playPage);
  }
}
