import 'package:stack/stack.dart';

import '../models/cell.dart';
import '../models/member.dart';
import '../models/parliament.dart';
import '../models/ai/tree.dart';

class GameState {
  final _undoStack = Stack<Parliament>();
  var _redoStack = Stack<Parliament>();
  var parliament = Parliament();

  bool get canUndo => _undoStack.isNotEmpty;
  bool get canRedo => _redoStack.isNotEmpty;

  void undo() {
    if (_undoStack.isNotEmpty) {
      _redoStack.push(parliament);
      parliament = _undoStack.pop();
    }
  }

  void redo() {
    if (_redoStack.isNotEmpty) {
      _undoStack.push(parliament);
      parliament = _redoStack.pop();
    }
  }

  void doAction(Member member, Cell cell) {
    final newParliament = parliament.makeCopy();
    newParliament.act(member.id, cell);
    _handleNewState(newParliament);
  }

  void aiAct(int maxDepth) {
    final tree = Tree(parliament, maxDepth);
    tree.build();
    _handleNewState(tree.decision.parliament);
  }

  void _handleNewState(Parliament newParliament) {
    _redoStack = Stack<Parliament>();
    _undoStack.push(parliament);
    parliament = newParliament;
  }

  Iterable<Cell> lastMovementCells() sync* {
    if (_undoStack.isEmpty) return;
    final lastParliament = _undoStack.top();
    for (final member in parliament.members) {
      final lastMember = lastParliament.members[member.id];
      if (member.location != lastMember.location) {
        yield member.location;
        yield lastMember.location;
      } else if (member.isDead != lastMember.isDead) {
        yield member.location;
      }
    }
  }
}
