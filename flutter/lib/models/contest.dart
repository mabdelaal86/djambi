import 'dart:ui';

import 'package:stack/stack.dart';

import 'ai/tree.dart';
import 'cell.dart';
import 'enums.dart';
import 'member.dart';
import 'parliament.dart';

class State {
  final Parliament parliament;
  final List<Cell> lastMovedCells;

  State(this.parliament, [Parliament? lastParliament])
      : lastMovedCells = _getDifferentCells(parliament, lastParliament).toList();

  static Iterable<Cell> _getDifferentCells(
      Parliament newParliament, Parliament? lastParliament) sync* {
    if (lastParliament == null) return;
    for (final member in newParliament.members) {
      final lastMember = lastParliament.members[member.id];
      if (member.location != lastMember.location) {
        yield member.location;
        yield lastMember.location;
      } else if (member.state != lastMember.state) {
        yield member.location;
      }
    }
  }
}

class Contest {
  State _curState;
  final _undoStack = Stack<State>();
  final _redoStack = Stack<State>();
  final VoidCallback? onStateChanged;
  final VoidCallback? onManoeuvreCompleted;

  Parliament get parliament => _curState.parliament;
  List<Cell> get lastMovedCells => _curState.lastMovedCells;
  bool get canUndo => _undoStack.isNotEmpty;
  bool get canRedo => _redoStack.isNotEmpty;

  Contest(
      Ideology startIdeology,
      TurnDirection turnDirection,
      [this.onStateChanged, this.onManoeuvreCompleted])
    : _curState = State(Parliament(startIdeology, turnDirection));

  void undo() {
    if (canUndo) {
      _redoStack.push(_curState);
      _curState = _undoStack.pop();
      onStateChanged?.call();
    }
  }

  void redo() {
    if (canRedo) {
      _undoStack.push(_curState);
      _curState = _redoStack.pop();
      onStateChanged?.call();
    }
  }

  void doAction(Member member, Cell cell) {
    final newParliament = parliament.makeCopy();
    newParliament.act(member.id, cell);
    _redoStack.clear();
    _undoStack.push(_curState);
    _handleNewState(newParliament);
  }

  void aiAct(int maxDepth) {
    if (!parliament.isManoeuvreCompleted) return;
    if (parliament.isGameFinished) return;
    final tree = Tree(parliament, maxDepth);
    tree.build();
    _handleNewState(tree.decision.parliament);
  }

  void _handleNewState(Parliament newParliament) {
    _curState = State(newParliament, parliament);
    onStateChanged?.call();
    if (newParliament.isManoeuvreCompleted) {
      onManoeuvreCompleted?.call();
    }
  }
}
