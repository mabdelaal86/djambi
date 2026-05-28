import 'dart:ui';

import 'package:stack/stack.dart';

import 'ai/tree.dart';
import 'cell.dart';
import 'enums.dart';
import 'member.dart';
import 'parliament.dart';
import 'state.dart';

class Contest {
  State _curState;
  final _undoStack = Stack<State>();
  final _redoStack = Stack<State>();

  /// Called after every state change (move, undo, redo).
  final VoidCallback? onStateChanged;

  /// Called just before onStateChanged, giving the renderer a chance to
  /// start move animations with the new parliament already applied.
  final VoidCallback? onBeforeStateChanged;

  Parliament get parliament => _curState.parliament;
  List<Cell> get lastMovedCells => _curState.lastMovedCells;
  bool get canUndo => _undoStack.isNotEmpty;
  bool get canRedo => _redoStack.isNotEmpty;

  final List<PlayerType> playerTypes;
  final AiDifficulty aiDifficulty;

  Contest(
    Ideology startIdeology,
    TurnDirection turnDirection,
    this.playerTypes, {
    this.onStateChanged,
    this.onBeforeStateChanged,
    this.aiDifficulty = AiDifficulty.medium,
  }) : _curState = State(Parliament(startIdeology, turnDirection));

  Contest.fromJson(
    Map<String, dynamic> json, {
    this.onStateChanged,
    this.onBeforeStateChanged,
    this.aiDifficulty = AiDifficulty.medium,
  })  : _curState = State(Parliament.fromJson(json['parliament'])),
        playerTypes = [
          for (final p in json['player-types']) PlayerType.values[p]
        ];

  Map<String, dynamic> toJson() => {
        'parliament': parliament.toJson(),
        'player-types': playerTypes.map((e) => e.index).toList(),
      };

  void undo() {
    if (canUndo) {
      _redoStack.push(_curState);
      _curState = _undoStack.pop();
      onBeforeStateChanged?.call();
      onStateChanged?.call();
    }
  }

  void redo() {
    if (canRedo) {
      _undoStack.push(_curState);
      _curState = _redoStack.pop();
      onBeforeStateChanged?.call();
      onStateChanged?.call();
    }
  }

  bool get noHumans => parliament.activeParties
      .every((p) => playerTypes[p.ideology.index] != PlayerType.human);

  bool get isCurHuman =>
      playerTypes[parliament.currentParty.ideology.index].isHuman;

  void doAction(Member member, Cell cell) {
    final newParliament = _curState.parliament.makeCopy();
    newParliament.act(member.id, cell);
    _redoStack.clear();
    _undoStack.push(_curState);
    _handleNewState(newParliament);
  }

  void aiAct() {
    assert(!_curState.parliament.isGameFinished, 'game is already finished!');
    assert(_curState.parliament.isManoeuvreCompleted,
        "can't call AI in middle of a manoeuvre");
    final tree =
        Tree(_curState.parliament, aiDifficulty.depth, difficulty: aiDifficulty);
    tree.build();
    _handleNewState(tree.decision.parliament);
  }

  void _handleNewState(Parliament newParliament) {
    _curState = State(newParliament, _curState.parliament);
    onBeforeStateChanged?.call();
    onStateChanged?.call();
  }
}
