import 'package:collection/collection.dart';

import 'cell.dart';
import 'common.dart';
import 'member.dart';
import 'parliament.dart';

class Party {
  final Member chief;
  Party(this.chief);

  Parliament get parliament => chief.parliament;
  Ideology get ideology => chief.ideology;
  bool get isLost => chief.isDead || chief.isSurrounded();

  Iterable<Member> get aliveMembers =>
      parliament.members.where((m) => m.ideology == ideology && m.isAlive);

  Iterable<Member> get movableMembers =>
      aliveMembers.where((m) => m.cellsToAct().isNotEmpty);

  Iterable<Member> get traitors =>
      parliament.members.where((m) => m.ideology == ideology && m.isAlive && m.isTraitor);

  Member? getMemberAt(Cell cell) =>
      aliveMembers.firstWhereOrNull((m) => m.location == cell);

  bool get isActive => chief.isAlive && !chief.isSurrounded() && movableMembers.isNotEmpty;
}
