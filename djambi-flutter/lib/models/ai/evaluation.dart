import 'package:collection/collection.dart';

import '../common.dart';
import '../member.dart';
import '../party.dart';

abstract class StateEvaluator {
  const StateEvaluator();
  int evaluate(Party party);
}

class DefaultEvaluator extends StateEvaluator {
  const DefaultEvaluator();

  @override
  int evaluate(Party party) => party.aliveMembers.map(_getValue).sum;

  int _getValue(Member member) {
    switch (member.role) {
      case Role.militant:     return 5;
      case Role.necromobile:  return 10;
      case Role.diplomat:     return 10;
      case Role.assassin:     return 15;
      case Role.reporter:     return 18;
      case Role.chief:        return 300;
    }
  }
}
