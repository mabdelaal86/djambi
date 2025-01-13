import 'package:flame/components.dart';

class IndexedStackComponent extends PositionComponent {
  int _index = 0;
  final List<PositionComponent> _elements;

  IndexedStackComponent({
    super.position,
    super.anchor,
    super.scale,
    required List<PositionComponent> children,
  }) : _elements = children {
    assert(_elements.isNotEmpty, "children components are empty!");
  }

  int get index => _index;
  PositionComponent get child => _elements[_index];

  @override
  Future<void> onLoad() async {
    await add(child);
    size = child.size;
  }

  Future<void> setIndex(int value) async {
    if (value == _index) return;

    remove(child);
    await child.removed;
    _index = value;
    await add(child);

    size = child.size;
  }
}
