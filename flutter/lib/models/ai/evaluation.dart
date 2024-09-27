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
    Role.militant: 5,
    Role.necromobile: 15,
    Role.diplomat: 10,
    Role.assassin: 10,
    Role.reporter: 12,
    Role.chief: 30, // 48 if in power.
  };
}
