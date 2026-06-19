import 'dart:math';

import '../cell.dart';
import '../enums.dart';
import '../member.dart';
import 'evaluation.dart';
import 'tree.dart';

/// Bundles together everything that makes one AI difficulty tier feel
/// different from another: how deep it looks ahead, how it scores a
/// position, and (for the weaker tiers) how many of the legal moves it
/// actually bothers to consider.
class AiSettings {
  const AiSettings({required this.maxDepth, required this.evaluateParty, this.maxActionsPerNode});

  /// How many half-moves (manoeuvres) ahead the search looks.
  final int maxDepth;

  /// How a single party's position is scored at the leaves of the search.
  final PartyEvaluation evaluateParty;

  /// If set, only this many candidate (member, cell) actions are explored
  /// per node - the rest are dropped after move-ordering. `null` means
  /// "consider everything", used by the stronger tiers.
  final int? maxActionsPerNode;

  List<(Member, Cell)> _sample(List<(Member, Cell)> actions, Random random) {
    final cap = maxActionsPerNode;
    if (cap == null || actions.length <= cap) {
      actions.shuffle(random);
      return actions;
    }
    // keep move-ordering (impactful actions are already sorted first by the
    // caller) but shuffle within the kept window so equally-ranked actions
    // (e.g. several available captures) aren't always picked in the same
    // order.
    final kept = actions.sublist(0, cap)..shuffle(random);
    return kept;
  }

  ActionSampler get sampleActions => _sample;

  static const easy = AiSettings(maxDepth: 1, evaluateParty: easyPartyEvaluation, maxActionsPerNode: 6);

  static const medium = AiSettings(maxDepth: 2, evaluateParty: mediumPartyEvaluation);

  static const hard = AiSettings(maxDepth: 3, evaluateParty: hardPartyEvaluation);

  static AiSettings? forPlayerType(PlayerType type) => switch (type) {
    .human => null,
    .aiEasy => easy,
    .aiMedium => medium,
    .aiHard => hard,
  };
}
