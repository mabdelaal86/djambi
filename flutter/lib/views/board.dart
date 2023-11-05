import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/extensions.dart';

import 'dimensions.dart';
import 'renderers/background.dart';
import 'renderers/movements.dart';
import 'renderers/pieces.dart';
import 'state.dart';

class Board extends PositionComponent with TapCallbacks {
  // @override
  // bool get debugMode => true;

  final BackgroundRenderer _background;
  final MovementsRenderer _movements;
  final PiecesRenderer _pieces;

  Board(GameState gameState, {super.position})
      : _background = BackgroundRenderer(),
        _movements = MovementsRenderer(gameState),
        _pieces = PiecesRenderer(gameState),
        super(size: Dimensions.boardSize);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    await _background.onLoad();
    await _pieces.onLoad();
  }

  @override
  void render(Canvas canvas) {
    _background.render(canvas);
    _movements.render(canvas);
    _pieces.render(canvas);
  }

  @override
  void onTapUp(TapUpEvent event) {
    _movements.onTapUp(event.localPosition);
  }
}
