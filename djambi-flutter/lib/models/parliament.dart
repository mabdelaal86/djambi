import 'package:collection/collection.dart';

import 'common.dart';
import 'member.dart';
import 'party.dart';

class Parliament {
  static const int size = 9;
  static const int maze = size ~/ 2;
  static final Cell mazeCell = Cell.all(maze);

  final List<Party> parties = [
    Party(Ideology.red),
    Party(Ideology.blue),
    Party(Ideology.yellow),
    Party(Ideology.green),
  ];

  Ideology _currentPartyIdeology = Ideology.red;
  Ideology get currentPartyIdeology => _currentPartyIdeology;

  Party getParty(Ideology ideology) => parties[ideology.index];
  Party get currentParty => getParty(_currentPartyIdeology);

  Iterable<Member> allMembers() sync* {
    for (final party in parties) {
      for (final member in party.members) {
        yield member;
      }
    }
  }

  Member? memberAt(Cell cell) => allMembers().firstWhereOrNull((m) => m.cell == cell);
  Party? partyInPower() => parties.firstWhereOrNull(
          (p) => p.chief.cell == mazeCell && !p.chief.isDead);

  Parliament() {
    _setInitialPositions();
  }

  Ideology nextPlayer() {
    final inPower = partyInPower();
    var ideology = _currentPartyIdeology;
    if (inPower == null) {
      // no party is in power, so just return the next player in turn
      do {
        ideology = ideology.next;
      } while(parties[ideology.index].lost); // skip lost/dead parties
      return ideology;
    }
    else {
      // check if current is not the in power party
      if (ideology != inPower.ideology) {
        return inPower.ideology;
      }
      // current is the in power party, so return the next player in turn
      do {
        ideology = ideology.next;
      } while(parties[ideology.index].lost || ideology == inPower.ideology);
      return ideology;
    }
  }

  void nextTurn() {
    _currentPartyIdeology = nextPlayer();
  }

  void _setInitialPositions() {
    getParty(Ideology.red).members
      .forEach((member) { member.cell = member.cell.scaled( 1, -1).movedBy(1, 7); });
    getParty(Ideology.blue).members
      .forEach((member) { member.cell = member.cell.scaled(-1, -1).movedBy(7, 7); });
    getParty(Ideology.yellow).members
      .forEach((member) { member.cell = member.cell.scaled(-1,  1).movedBy(7, 1); });
    getParty(Ideology.green).members
      .forEach((member) { member.cell = member.cell.movedBy(1, 1); });
  }

  Iterable<Cell> selectableCells() {
    return currentParty.members.map((p) => p.cell);
  }
}
