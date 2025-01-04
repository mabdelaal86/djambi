import 'cell.dart';
import 'parliament.dart';

class State {
  final Parliament parliament;
  final List<Cell> lastMovedCells;

  State(this.parliament, [Parliament? lastParliament])
      : lastMovedCells = _getDifferentCells(parliament, lastParliament).toList();
}

Iterable<Cell> _getDifferentCells(
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
