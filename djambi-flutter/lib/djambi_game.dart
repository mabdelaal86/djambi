import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:flame/widgets.dart';

import 'components/board.dart';
import 'components/grid.dart';
import 'models/parliament.dart';

class DjambiGame extends FlameGame with HasTappableComponents {
  @override
  Future<void> onLoad() async {
    final parliament = Parliament();
    final board = Board(parliament);

    final grid = Grid(parliament);
    grid.addToParent(board);

    final world = World();
    world.add(board);
    add(world);

    final camera = CameraComponent(world: world)
      ..viewfinder.visibleGameSize = board.size
      ..viewfinder.anchor = Anchor.topLeft;
    add(camera);
  }
}
