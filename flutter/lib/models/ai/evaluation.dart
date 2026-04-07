import 'package:collection/collection.dart';

import '../enums.dart';
import '../party.dart';

typedef PartyEvaluation = int Function(Party party);

int defaultPartyEvaluation(Party party) => party.activeMembers.map((m) => _roleValues[m.role]!).sum;

const _roleValues = <Role, int>{
  .militant: 5,
  .necromobile: 10,
  .diplomat: 10,
  .assassin: 15,
  .reporter: 18,
  .chief: 300,
};
