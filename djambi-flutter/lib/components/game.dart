import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame/game.dart';

import '../views/board.dart';
import '../views/state.dart';
import 'play_page.dart';

class DjambiGame extends FlameGame {
  final state = GameState();

  @override
  Future<void> onLoad() async {
    final board = Board(state);
    final playPage = PlayPage(state);
    final world = World();

    playPage.add(board);
    world.add(playPage);
    add(world);

    final camera = CameraComponent(world: world)
      ..viewfinder.visibleGameSize = playPage.size
      ..viewfinder.anchor = Anchor.center;
    add(camera);
  }
}
