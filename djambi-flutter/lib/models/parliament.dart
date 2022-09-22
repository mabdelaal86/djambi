import 'package:collection/collection.dart';

import 'chief.dart';
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
  Chief? chiefInPower() => memberAt(mazeCell) as Chief?;

  Parliament() {
    _setInitialPositions();
  }

  void nextTurn() {
    _currentPartyIdeology = _currentPartyIdeology.next;
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
