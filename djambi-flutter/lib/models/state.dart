import 'package:stack/stack.dart';

import 'cell.dart';
import 'member.dart';
import 'parliament.dart';
import 'ai/tree.dart';

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
    // clean redo stack
    _redoStack = Stack<Parliament>();
    // do the action
    parliament.act(member, cell);
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

  void aiAct(int maxDepth) {
    // copy to undo stack
    _undoStack.push(parliament);
    // clean redo stack
    _redoStack = Stack<Parliament>();
    // decide the best action
    Tree engine = Tree(parliament, maxDepth);
    engine.build();
    parliament = engine.getBest().parliament;
  }
}
