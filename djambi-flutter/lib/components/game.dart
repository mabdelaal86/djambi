import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:flame/widgets.dart';

import 'board.dart';
import 'state.dart';

class DjambiGame extends FlameGame with HasTappableComponents {
  final state = GameState();

  @override
  Future<void> onLoad() async {
    final board = Board(state);

    final world = World();
    world.add(board);
    add(world);

    final camera = CameraComponent(world: world)
      ..viewfinder.visibleGameSize = board.size
      ..viewfinder.anchor = Anchor.topLeft;
    add(camera);
  }
}
