import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:flame/widgets.dart';

import 'components/board.dart';
import 'components/grid.dart';
import 'components/pieces.dart';
import 'models/parliament.dart';

class DjambiGame extends FlameGame with HasTappableComponents {
  @override
  Future<void> onLoad() async {
    final parliament = Parliament();
    final board = Board();

    final pieces = Pieces(parliament);
    pieces.addToParent(board);

    final grid = Grid(parliament);
    grid.addToParent(pieces);

    final world = World();
    world.add(board);
    add(world);

    final camera = CameraComponent(world: world)
      ..viewfinder.visibleGameSize = board.size
      ..viewfinder.anchor = Anchor.topLeft;
    add(camera);
  }
}
