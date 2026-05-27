import 'package:collection/collection.dart';

import '../enums.dart';
import '../party.dart';
import '../parliament.dart';

typedef PartyEvaluation = int Function(Party party);

/// Basic evaluation: sum of role values for alive members only.
int defaultPartyEvaluation(Party party) =>
    party.activeMembers.map((m) => _roleValues[m.role]!).sum;

/// Advanced evaluation with positional and strategic heuristics.
int advancedPartyEvaluation(Party party) {
  int score = 0;
  final parliament = party.parliament;

  // 1. Base piece values
  score += party.activeMembers.map((m) => _roleValues[m.role]!).sum;

  // 2. Chief positional bonus
  if (party.chief.isActive) {
    if (party.chief.location.isMaze) {
      score += 200; // in power
    } else {
      // Prefer chiefs closer to the center
      final cx = party.chief.location.x;
      final cy = party.chief.location.y;
      final distToCenter = (cx - 4).abs() + (cy - 4).abs();
      score -= distToCenter * 2;
    }
  }

  // 3. Mobility: reward having more movable pieces
  score += party.movableMembers.length * 3;

  // 4. Chief surrounded = catastrophic
  if (party.isChiefSurrounded()) {
    score -= 500;
  }

  // 5. Reward threatening enemy chiefs
  for (final enemy in parliament.activeParties) {
    if (enemy.ideology == party.ideology) continue;
    if (enemy.isChiefSurrounded()) {
      score += 100;
    }
  }

  // 6. Assassin proximity to enemy chief
  for (final assassin in party.activeMembers.where((m) => m.role == Role.assassin)) {
    for (final enemy in parliament.activeParties) {
      if (enemy.ideology == party.ideology) continue;
      final dist = (assassin.location.x - enemy.chief.location.x).abs() +
          (assassin.location.y - enemy.chief.location.y).abs();
      if (dist <= 4) score += (5 - dist) * 4;
    }
  }

  // 7. Reporter near enemies = area pressure
  for (final reporter in party.activeMembers.where((m) => m.role == Role.reporter)) {
    final nearbyEnemies = parliament.members
        .where((m) =>
            m.ideology != party.ideology &&
            m.isActive &&
            (m.location.x - reporter.location.x).abs() +
                    (m.location.y - reporter.location.y).abs() <=
                2)
        .length;
    score += nearbyEnemies * 5;
  }

  // 8. Necromobile: controlling corpse placement
  score += party.activeMembers.where((m) => m.role == Role.necromobile).length * 8;

  return score;
}

const _roleValues = <Role, int>{
  Role.militant: 5,
  Role.necromobile: 10,
  Role.diplomat: 10,
  Role.assassin: 15,
  Role.reporter: 18,
  Role.chief: 300,
};
