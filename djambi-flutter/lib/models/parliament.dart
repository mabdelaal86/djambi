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

  late Ideology _currentIdeology;
  late Party _currentParty;
  Party get currentParty => _currentParty;

  Party getParty(Ideology ideology) => parties[ideology.index];

  Iterable<Member> allMembers() sync* {
    for (final party in parties) {
      for (final member in party.members) {
        yield member;
      }
    }
  }

  Member? memberAt(Cell cell) => allMembers().firstWhereOrNull((m) => m.cell == cell);
  Party? getPartyInPower() => parties.firstWhereOrNull((p) => p.chief.cell == mazeCell && !p.lost);
  int countActiveParties() => parties.where((p) => !p.lost).length;

  Parliament() {
    _setInitialPositions();
    _currentIdeology = Ideology.first;
    _currentParty = getParty(_currentIdeology);
  }

  Party _nextParty() {
    final partyInPower = getPartyInPower();
    Party? party;
    // check if there is a party in power
    if (partyInPower == null) {
      // no party is in power, so just
      // find next ideology in turn but skip lost/dead parties
      do {
        _currentIdeology = _currentIdeology.next;
        party = getParty(_currentIdeology);
      } while(party.lost);
      return party;
    }
    // else: there is a party in power
    // check if current is not the party in power
    if (_currentParty != partyInPower) {
      return partyInPower;
    }
    // else: current ideology is in power, so
    // find next ideology in turn but skip lost/dead parties and
    // skip the party in power if there is more then 2 active parties
    do {
      _currentIdeology = _currentIdeology.next;
      party = getParty(_currentIdeology);
    } while(party.lost || (countActiveParties() > 2 && _currentIdeology == partyInPower.ideology));
    return party;
  }

  void nextTurn() {
    _currentParty = _nextParty();
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
    return _currentParty.members.map((p) => p.cell);
  }
}
