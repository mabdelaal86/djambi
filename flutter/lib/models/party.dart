import 'package:collection/collection.dart';

import 'cell.dart';
import 'common.dart';
import 'member.dart';
import 'parliament.dart';

class Party {
  // add everything that could impact heuristics.
  final Member chief;
  Party(this.chief);

  Parliament get parliament => chief.parliament;
  Ideology get ideology => chief.ideology;
  bool get isLost => chief.isDead || chief.isSurrounded();
  bool get isActive => !isLost && movableMembers.isNotEmpty;
  // has leader in power.

  Iterable<Member> get aliveMembers =>
      parliament.members.where((m) => m.ideology == ideology && m.isAlive);

  Iterable<Member> get movableMembers =>
      aliveMembers.where((m) => m.cellsToAct().isNotEmpty);

  Member? getMemberAt(Cell cell) =>
      aliveMembers.firstWhereOrNull((m) => m.location == cell);
}
