import 'package:collection/collection.dart';

import '../member.dart';
import '../party.dart';

typedef PartyEvaluation = int Function(Party party);

int defaultPartyEvaluation(Party party) => party.activeMembers.map(_memberEvaluation).sum;

int _memberEvaluation(Member member) => switch (member.role) {
  .militant => 5,
  .necromobile => 10,
  .diplomat => 10,
  .assassin => 15,
  .reporter => 18,
  .leader => member.location.isLabyrinth ? 500 : 300,
};
