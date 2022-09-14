import 'package:flame/experimental.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/widgets.dart';

import 'components/board.dart';
import 'components/assassin.dart';
import 'components/chief.dart';
import 'components/diplomat.dart';
import 'components/militant.dart';
import 'components/necromobile.dart';
import 'components/reporter.dart';
import 'configs/common.dart';
import 'configs/theme.dart';

class DjambiGame extends FlameGame
    with HasTappableComponents, HasDraggableComponents {
  @override
  Future<void> onLoad() async {
    await Flame.images.load('test.png');
    final theme = GameTheme();

    final board = Board(theme, position: Vector2(500, 300));
    final pieces = [
      Chief(Player.yellow, theme, position: Vector2(0, 0)),
      Assassin(Player.red, theme, position: Vector2(0, 1000)),
      Reporter(Player.green, theme, position: Vector2(1000, 0)),
      Diplomat(Player.blue, theme, position: Vector2(1000, 1000)),
      Necromobile(Player.red, theme, position: Vector2(2000, 0)),
      Militant(Player.red, theme, position: Vector2(2000, 1000)),
      Militant(Player.blue, theme, position: Vector2(0, 2000)),
      Militant(Player.green, theme, position: Vector2(1000, 2000)),
      Militant(Player.red, theme, position: Vector2(2000, 2000)),
    ];
    pieces.last.die();

    board.grid.addAll(pieces);

    final world = World();
    world.add(board);
    add(world);

    final camera = CameraComponent(world: world)
      ..viewfinder.visibleGameSize = board.size + Vector2.all(500)
      ..viewfinder.anchor = Anchor.topLeft;
    add(camera);
  }
}
