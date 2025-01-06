import 'package:collection/collection.dart';

import 'cell.dart';
import 'enums.dart';
import 'member.dart';
import 'members/chief.dart';
import 'parliament.dart';

class Party {
  final Chief chief;
  Party(this.chief);

  Parliament get parliament => chief.parliament;
  Ideology get ideology => chief.ideology;

  @override
  String toString() => "${ideology.name} party";

  Iterable<Member> get activeMembers =>
      parliament.members.where((m) => m.ideology == ideology && m.isActive);

  Iterable<Member> get movableMembers =>
      activeMembers.where((m) => m.cellsToAct().isNotEmpty);

  Iterable<Member> getMembersOfRole(Role role) =>
      activeMembers.where((m) => m.role == role);

  Member? getMemberAt(Cell cell) =>
      activeMembers.firstWhereOrNull((m) => m.location == cell);

  bool isChiefSurrounded() {
    if (chief.location.isMaze) return false;
    if (getMembersOfRole(Role.necromobile).isNotEmpty) return false;

    final inQueue = chief.location.surroundingCells().toList();
    final registered = { chief.location, ...inQueue };

    while (inQueue.isNotEmpty) {
      final cell = inQueue.removeLast();
      final member = parliament.getMemberAt(cell);

      if (member == null) return false;
      if (member.isDead) continue;
      if (member.ideology != ideology) return false;

      final surroundings = cell.surroundingCells()
          .where((c) => !registered.contains(c))
          .toList();
      registered.addAll(surroundings);
      inQueue.addAll(surroundings);
    }

    return true;
  }
}
