import 'package:flame/experimental.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/widgets.dart';

import 'components/piece.dart';

class DjambiGame extends FlameGame {
  @override
  Future<void> onLoad() async {
    await Flame.images.load('test.png');

    final pieces = List.generate(3, (index) => Piece()
        ..size = Vector2(500.0, 500.0)
        ..position = Vector2(200.0, 500 + index * 550.0)
    );

    final world = World()
      ..addAll(pieces);
    add(world);

    final camera = CameraComponent(world: world)
      ..viewfinder.visibleGameSize = Vector2(2000, 5000)
      ..viewfinder.anchor = Anchor.topCenter;
    add(camera);
  }
}
