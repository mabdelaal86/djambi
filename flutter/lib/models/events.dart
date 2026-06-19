import 'cell.dart';
import 'member.dart';
import 'parliament.dart';

/// What kind of thing just happened on the board, derived by diffing the
/// parliament before and after a single action. Used by the UI layer to
/// decide what sound (if any) to play - the models layer itself stays free
/// of any audio/IO concerns.
enum GameEventType {
  /// A member moved to an empty cell without touching anyone.
  move,

  /// A member was killed (moved on top of, or otherwise eliminated).
  kill,

  /// A chief specifically was killed.
  captureChief,

  /// A chief got boxed in by its own surrounded members and died as a
  /// result, paralysing its party.
  chiefSurrounded,

  /// A body was carried out of the maze and buried on the board.
  bury,

  /// The game just finished (only one active party remains).
  win,
}

class GameEvent {
  const GameEvent(this.type, {this.cell});

  final GameEventType type;

  /// Where the event happened, when relevant (most events have one).
  final Cell? cell;

  @override
  String toString() => "GameEvent(${type.name}${cell != null ? ' @ $cell' : ''})";
}

/// Computes the list of notable things that changed between [before] and
/// [after], which are expected to be two snapshots of the same parliament
/// taken right before and right after a single [Parliament.act] call.
List<GameEvent> diffGameEvents(Parliament before, Parliament after) {
  final events = <GameEvent>[];

  // cells that some member actually moved into this action; used to tell a
  // direct chief capture (the actor landed on the chief's cell) apart from
  // a chief dying because its own party boxed it in (a siege), since in the
  // latter case nobody's destination is the chief's cell.
  final destinationCells = {
    for (final member in after.members)
      if (before.members[member.id].location != member.location) member.location,
  };

  for (final member in after.members) {
    final wasMember = before.members[member.id];
    _diffMember(wasMember, member, destinationCells, events);
  }

  if (!before.isGameFinished && after.isGameFinished) {
    events.add(const GameEvent(GameEventType.win));
  }

  return events;
}

void _diffMember(Member before, Member after, Set<Cell> destinationCells, List<GameEvent> events) {
  // a member freshly killed this action
  if (before.isAlive && after.isDead) {
    final wasDirectlyCaptured = destinationCells.contains(before.location);
    if (after.isChief && !wasDirectlyCaptured) {
      events.add(GameEvent(GameEventType.chiefSurrounded, cell: after.location));
    } else {
      events.add(GameEvent(after.isChief ? GameEventType.captureChief : GameEventType.kill, cell: after.location));
    }
    return;
  }

  // a teammate paralysed (even if briefly) as a side effect of its chief
  // getting sieged; the chief's own death already carries the
  // `chiefSurrounded` event above, so there's nothing extra to report here.
  if (before.isActive && !after.isActive) return;

  // a dead body being carried to its final resting place
  if (after.isDead && before.location != after.location) {
    events.add(GameEvent(GameEventType.bury, cell: after.location));
    return;
  }

  // a plain, uneventful move
  if (after.isActive && before.location != after.location) {
    events.add(GameEvent(GameEventType.move, cell: after.location));
  }
}
