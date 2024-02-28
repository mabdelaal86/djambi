import 'package:collection/collection.dart';

import '../common.dart';
import '../party.dart';

abstract class StateEvaluator {
  const StateEvaluator();
  int evaluate(Party party);
}

class DefaultEvaluator extends StateEvaluator {
  const DefaultEvaluator();

  @override
  int evaluate(Party party) =>
      party.aliveMembers.map((m) => _roleValues[m.role]!).sum;

  static const _roleValues = {
    Role.militant: 6,
    Role.necromobile: 12,
    Role.diplomat: 12,
    Role.assassin: 18,
    Role.reporter: 18,
    Role.chief: 30, // 48 if in power.
  };
}
