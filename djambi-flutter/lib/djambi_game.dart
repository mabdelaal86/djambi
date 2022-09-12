import 'package:flame/experimental.dart';
import 'package:flame/extensions.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/widgets.dart';

import 'components/board.dart';
import 'components/piece.dart';
import 'configs/common.dart';
import 'configs/theme.dart';

class DjambiGame extends FlameGame with HasTappableComponents {
  @override
  Future<void> onLoad() async {
    await Flame.images.load('test.png');
    final theme = GameTheme();

    final board = Board(theme)
      ..position = Vector2(500, 300);
    final pieces = List.generate(4, (index) => Piece(Player.yellow, theme)
        ..position = Vector2(1000, 300 + 500 + index * 2000)
        ..isDead = index % 2 == 0
    );

    final world = World()
      ..add(board)
      ..addAll(pieces);
    add(world);

    final camera = CameraComponent(world: world)
      ..viewfinder.visibleGameSize = Board.allSize.toVector2() + Vector2.all(500)
      ..viewfinder.anchor = Anchor.topLeft;
    add(camera);
  }
}
