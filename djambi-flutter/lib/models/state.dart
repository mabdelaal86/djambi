import 'package:stack/stack.dart';

import 'cell.dart';
import 'member.dart';
import 'parliament.dart';

class GameState {
  final _undoStack = Stack<Parliament>();
  var _redoStack = Stack<Parliament>();
  var parliament = Parliament();

  bool get canUndo => _undoStack.isNotEmpty;
  bool get canRedo => _redoStack.isNotEmpty;

  void doAction(Member member, Cell cell) {
    // copy to undo stack
    final copy = parliament.makeCopy();
    _undoStack.push(copy);
    // do the action
    parliament.act(member, cell);
    // clean redo stack
    _redoStack = Stack<Parliament>();
  }

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
}
