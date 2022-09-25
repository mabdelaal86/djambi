import 'package:stack/stack.dart';

import 'common.dart';

abstract class Member {
  final Role role;
  Ideology ideology;

  Member(this.role, this.ideology) {
    origins.push(ideology);
  }

  Cell cell = Cell.zero();

  bool _isDead = false;
  bool get isDead => _isDead;
  void die() => _isDead = true;

  final Stack<Ideology> origins = Stack();
}
