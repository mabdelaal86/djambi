import 'package:flame/experimental.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/widgets.dart';

import 'components/board.dart';
import 'components/piece.dart';

class DjambiGame extends FlameGame with HasTappableComponents {
  @override
  Future<void> onLoad() async {
    await Flame.images.load('test.png');

    final board = Board()
      ..size = Vector2(Board.sideSize, Board.sideSize)
      ..position = Vector2(0, 0);
    final pieces = List.generate(3, (index) => Piece()
        ..size = Vector2(500.0, 500.0)
        ..position = Vector2(200.0, 500 + index * 550.0)
    );

    final world = World()
      ..add(board)
      ..addAll(pieces);
    add(world);

    final camera = CameraComponent(world: world)
      ..viewfinder.visibleGameSize = Vector2(Board.sideSize, Board.sideSize)
      ..viewfinder.anchor = Anchor.topLeft;
    add(camera);
  }
}
