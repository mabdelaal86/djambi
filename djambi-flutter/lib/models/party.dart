import 'package:collection/collection.dart';

import 'common.dart';
import 'member.dart';
import 'parliament.dart';

class Party {
  final Member chief;
  Party(this.chief);

  Parliament get parliament => chief.parliament;
  Ideology get ideology => chief.ideology;
  bool get isLost => chief.isDead;
  bool get isActive => chief.isAlive;

  Iterable<Member> get members =>
      parliament.members.where((m) => m.ideology == ideology && m.isAlive);

  Member? get actor => members.firstWhereOrNull((m) => m.manoeuvre != Manoeuvre.select);
}
