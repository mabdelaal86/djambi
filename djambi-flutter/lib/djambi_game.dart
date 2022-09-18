import 'package:flame/experimental.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/widgets.dart';

import 'components/board.dart';
import 'components/grid.dart';
import 'components/theme.dart';
import 'models/tourney.dart';

class DjambiGame extends FlameGame with HasTappableComponents {
  @override
  Future<void> onLoad() async {
    await Flame.images.load('test.png');
    final theme = GameTheme();

    final tourney = Tourney();
    final grid = Grid(tourney);
    final board = Board(tourney, theme, position: Vector2(500, 300));
    board.add(grid);

    final world = World();
    world.add(board);
    add(world);

    final camera = CameraComponent(world: world)
      ..viewfinder.visibleGameSize = board.size + Vector2.all(500)
      ..viewfinder.anchor = Anchor.topLeft;
    add(camera);
  }
}
