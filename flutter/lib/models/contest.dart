import 'dart:ui';

import 'package:stack/stack.dart';

import 'ai/difficulty.dart';
import 'ai/tree.dart';
import 'cell.dart';
import 'enums.dart';
import 'events.dart';
import 'member.dart';
import 'parliament.dart';
import 'state.dart';

class Contest {
  State _curState;
  final _undoStack = Stack<State>();
  final _redoStack = Stack<State>();
  final VoidCallback? onStateChanged;

  Parliament get parliament => _curState.parliament;
  List<Cell> get lastMovedCells => _curState.lastMovedCells;
  List<GameEvent> get lastEvents => _curState.events;
  bool get canUndo => _undoStack.isNotEmpty;
  bool get canRedo => _redoStack.isNotEmpty;

  final List<PlayerType> playerTypes;

  Contest(Ideology startIdeology, TurnDirection turnDirection, this.playerTypes, {this.onStateChanged})
    : _curState = State(Parliament(startIdeology, turnDirection));

  /// json deserialization
  Contest.fromJson(Map<String, dynamic> json, {this.onStateChanged})
    : _curState = State(Parliament.fromJson(json["parliament"])),
      playerTypes = [for (final p in json["player-types"]) .values[p]];

  /// json serialization
  Map<String, dynamic> toJson() => {
    "parliament": parliament.toJson(),
    "player-types": playerTypes.map((e) => e.index).toList(),
  };

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

  bool get noHumans => parliament.activeParties.every((p) => playerTypes[p.ideology.index] != .human);

  bool get isCurHuman => playerTypes[parliament.currentParty.ideology.index].isHuman;

  void doAction(Member member, Cell cell) {
    final newParliament = _curState.parliament.makeCopy();
    newParliament.act(member.id, cell);
    _redoStack.clear();
    _undoStack.push(_curState);
    _handleNewState(newParliament);
  }

  void aiAct() {
    assert(!_curState.parliament.isGameFinished, "game is already finished!");
    assert(_curState.parliament.isManoeuvreCompleted, "can't call AI in middle of a manoeuvre");
    final playerType = playerTypes[parliament.currentParty.ideology.index];
    final settings = AiSettings.forPlayerType(playerType);
    assert(settings != null, "aiAct should only be called for an AI-controlled party");
    final tree = Tree(
      _curState.parliament,
      settings!.maxDepth,
      evaluateParty: settings.evaluateParty,
      sampleActions: settings.sampleActions,
    );
    tree.build();
    _handleNewState(tree.decision.parliament);
  }

  void _handleNewState(Parliament newParliament) {
    _curState = State(newParliament, _curState.parliament);
    onStateChanged?.call();
  }
}
