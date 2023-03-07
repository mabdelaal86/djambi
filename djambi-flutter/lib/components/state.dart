import 'package:stack/stack.dart';

import '../models/cell.dart';
import '../models/member.dart';
import '../models/parliament.dart';


class GameState {
  final _stack = Stack<Parliament>();
  var parliament = Parliament();

  void doAction(Member member, Cell cell) {
    final copy = Parliament.copy(parliament);
    _stack.push(copy);
    parliament.act(member, cell);
  }

  void undo() {
    if (_stack.isNotEmpty) {
      parliament = _stack.pop();
    }
  }
}
