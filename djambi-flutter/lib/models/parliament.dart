import 'package:collection/collection.dart';

import 'common.dart';
import 'member.dart';
import 'party.dart';

class Parliament {
  static const int size = 9;
  static const int maze = size ~/ 2;
  static final Cell mazeCell = Cell.all(maze);

  late final List<Party> _parties = [
    Party(this, Ideology.red),
    Party(this, Ideology.blue),
    Party(this, Ideology.yellow),
    Party(this, Ideology.green),
  ];

  Party getParty(Ideology ideology) => _parties[ideology.index];

  late final List<Member> members = [];
  Member? memberAt(Cell cell) => members.firstWhereOrNull((m) => m.cell == cell);
  Iterable<Member> getPartyMembers(Ideology ideology) => members.where((m) => m.ideology == ideology);

  late Ideology _currentIdeology = Ideology.first;
  late Party _currentParty = getParty(_currentIdeology);
  Party get currentParty => _currentParty;

  Parliament() {
    _createMembers();
    _setInitialPositions();
  }

  void _createMembers() {
    for (final party in _parties) { members.addAll(party.createMembers()); }
  }

  void _setInitialPositions() {
    getPartyMembers(Ideology.red)     .forEach((m) { m.cell = m.cell.scaled( 1, -1).movedBy(1, 7); });
    getPartyMembers(Ideology.blue)    .forEach((m) { m.cell = m.cell.scaled(-1, -1).movedBy(7, 7); });
    getPartyMembers(Ideology.yellow)  .forEach((m) { m.cell = m.cell.scaled(-1,  1).movedBy(7, 1); });
    getPartyMembers(Ideology.green)   .forEach((m) { m.cell = m.cell.movedBy(1, 1); });
  }

  Party? getPartyInPower() => _parties.firstWhereOrNull((p) => p.chief.cell == mazeCell && !p.lost);
  int countActiveParties() => _parties.where((p) => !p.lost).length;

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

  Iterable<Cell> selectableCells() {
    return _currentParty.getMembers().map((p) => p.cell);
  }
}
