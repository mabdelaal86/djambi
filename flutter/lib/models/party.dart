import 'package:collection/collection.dart';

import 'cell.dart';
import 'enums.dart';
import 'member.dart';
import 'members/leader.dart';
import 'parliament.dart';

class Party {
  final Leader leader;
  new(this.leader);

  Parliament get parliament => leader.parliament;
  Ideology get ideology => leader.ideology;

  @override
  String toString() => '${ideology.name} party';

  Iterable<Member> get activeMembers => parliament.members.where((m) => m.ideology == ideology && m.isActive);

  Iterable<Member> get movableMembers => activeMembers.where((m) => m.cellsToAct().isNotEmpty);

  Iterable<Member> getMembersOfRole(Role role) => activeMembers.where((m) => m.role == role);

  Member? getMemberAt(Cell cell) => activeMembers.firstWhereOrNull((m) => m.location == cell);

  bool isLeaderSurrounded() {
    if (leader.location.isMaze) return false;
    if (getMembersOfRole(.necromobile).isNotEmpty) return false;

    final inQueue = leader.location.surroundingCells().toList();
    final registered = {leader.location, ...inQueue};

    while (inQueue.isNotEmpty) {
      final cell = inQueue.removeLast();
      final member = parliament.getMemberAt(cell);

      if (member == null) return false;
      if (member.isDead) continue;
      if (member.ideology != ideology) return false;

      final surroundings = cell.surroundingCells().where((c) => !registered.contains(c)).toList();
      registered.addAll(surroundings);
      inQueue.addAll(surroundings);
    }

    return true;
  }
}
