import 'package:collection/collection.dart';

import '../cell.dart';
import '../constants.dart';
import '../enums.dart';
import '../member.dart';
import '../parliament.dart';
import '../party.dart';

typedef PartyEvaluation = int Function(Party party);

// ------------------------------------
// base (material) values
// ------------------------------------

const _maxCellDistance = Constants.sideCellsCount - 1;

int _baseMemberValue(Member member) => switch (member.role) {
  .militant => 5,
  .necromobile => 10,
  .diplomat => 10,
  .assassin => 15,
  .reporter => 18,
  .chief => member.location.isMaze ? 500 : 300,
};

/// Distance (Chebyshev) from a cell to the maze, used to reward members -
/// and especially the chief - for advancing toward the centre of the board.
int _distanceToMaze(Cell cell) => (cell - Cell.maze).abs().max;

/// A rough centrality bonus: cells closer to the maze are more valuable
/// because they grant access to more directions and to the maze itself.
int _centralityBonus(Member member) {
  if (member.location.isMaze) return 0;
  final distance = _distanceToMaze(member.location);
  return (_maxCellDistance - distance);
}

int _chiefAdvancementBonus(Party party) {
  final chief = party.chief;
  if (!chief.isActive || chief.location.isMaze) return 0;
  return (_maxCellDistance - _distanceToMaze(chief.location)) * 2;
}

/// All cells that at least one active member of [ideology] could capture
/// into right now. Computed once per board position (not per candidate
/// victim) so checking "is this member hanging?" for every piece on the
/// board is a cheap set lookup instead of a fresh move-generation scan.
///
/// Most roles expose their kill targets through `cellsToMove(canKill: true)`,
/// but the reporter is a special case: it kills adjacent enemies via a
/// separate `canKillOn` check rather than by moving onto their cell, so that
/// is consulted too.
Map<Ideology, Set<Cell>> _threatenedCellsByIdeology(Parliament parliament) {
  final result = <Ideology, Set<Cell>>{};
  for (final member in parliament.members) {
    if (!member.isActive) continue;
    final cells = result.putIfAbsent(member.ideology, () => {});
    cells.addAll(member.cellsToMove(canKill: true));
    cells.addAll(member.location.surroundingCells().where(member.canKillOn));
  }
  return result;
}

bool _isThreatenedBy(Member member, Map<Ideology, Set<Cell>> threatenedCells) => Ideology.values
    .where((ideology) => ideology != member.ideology)
    .any((ideology) => threatenedCells[ideology]?.contains(member.location) ?? false);

// ------------------------------------
// the "Easy" evaluation
// ------------------------------------

/// Material only - same shallow heuristic the original AI used. It still
/// shuffles candidate moves (see [Node.availableActions]) so combined with a
/// shallow search depth it plays plausible but clearly beatable moves.
int easyPartyEvaluation(Party party) => party.activeMembers.map(_baseMemberValue).sum;

// ------------------------------------
// the "Medium" evaluation
// ------------------------------------

/// Material plus basic chief safety: heavily penalises a party whose chief
/// is currently boxed in (about to be captured), and rewards the chief for
/// being inside or close to the maze.
int mediumPartyEvaluation(Party party) {
  var score = party.activeMembers.map(_baseMemberValue).sum;
  score += _chiefAdvancementBonus(party);
  if (party.isChiefSurrounded()) score -= 1000;
  return score;
}

// ------------------------------------
// the "Hard" evaluation
// ------------------------------------

/// Material, chief safety/advancement, centrality and hanging-piece
/// awareness, so the AI prefers safe, active positions over simply
/// hoarding material.
///
/// Note: the per-board threat map is recomputed on the first call for a
/// given parliament and cached for the lifetime of that object, since the
/// tree search evaluates all 4 parties of the very same (leaf) parliament
/// back-to-back.
int hardPartyEvaluation(Party party) {
  final threatenedCells = _threatCache[party.parliament] ??= _threatenedCellsByIdeology(party.parliament);
  var score = 0;
  for (final member in party.activeMembers) {
    var value = _baseMemberValue(member);
    if (!member.isChief) {
      value += _centralityBonus(member);
      if (_isThreatenedBy(member, threatenedCells)) value -= (value * 2) ~/ 3;
    }
    score += value;
  }
  score += _chiefAdvancementBonus(party);
  if (party.isChiefSurrounded()) score -= 1000;
  return score;
}

/// Tiny per-parliament memo so [hardPartyEvaluation] doesn't recompute the
/// board-wide threat map once per party (it's identical for all 4). Cleared
/// implicitly since each leaf node has its own freshly-copied [Parliament]
/// that is evaluated once and then discarded.
final _threatCache = Expando<Map<Ideology, Set<Cell>>>();

/// kept for backward compatibility / default usage outside difficulty tiers
int defaultPartyEvaluation(Party party) => mediumPartyEvaluation(party);
