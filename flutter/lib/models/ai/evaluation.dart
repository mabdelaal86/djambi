import 'package:collection/collection.dart';

import '../enums.dart';
import '../party.dart';

typedef PartyEvaluation = int Function(Party party);

int defaultPartyEvaluation(Party party) =>
    party.activeMembers.map((m) => _roleValues[m.role]!).sum;

const _roleValues = {
  Role.militant: 5,
  Role.necromobile: 10,
  Role.diplomat: 10,
  Role.assassin: 15,
  Role.reporter: 18,
  Role.chief: 300,
};
