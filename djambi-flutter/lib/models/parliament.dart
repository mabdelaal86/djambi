import 'package:collection/collection.dart';

import 'common.dart';
import 'manoeuvre.dart';
import 'member.dart';
import 'party.dart';

class Parliament {
  late final List<Party> _parties = [
    Party(this, Ideology.red),
    Party(this, Ideology.blue),
    Party(this, Ideology.yellow),
    Party(this, Ideology.green),
  ];

  Party getParty(Ideology ideology) => _parties[ideology.index];

  late final List<Member> members = [];
  Member? getMemberAt(Cell cell) => members.firstWhereOrNull((m) => m.cell == cell);
  Iterable<Member> getPartyMembers(Ideology ideology) => members.where((m) => m.ideology == ideology);

  late Ideology _currentIdeology = Ideology.first;
  late Party _currentParty = getParty(_currentIdeology);
  Party get currentParty => _currentParty;

  late Manoeuvre _currentManoeuvre = Manoeuvre(_currentParty);
  Manoeuvre get currentManoeuvre => _currentManoeuvre;

  Parliament() {
    _createMembers();
    _setInitialPositions();
  }

  void _createMembers() {
    for (final party in _parties) { members.addAll(party.recruitAll()); }
  }

  void _setInitialPositions() {
    getPartyMembers(Ideology.red)     .forEach((m) { m.cell = m.cell * const Cell( 1, -1) + const Cell(1, 7); });
    getPartyMembers(Ideology.blue)    .forEach((m) { m.cell = m.cell * const Cell(-1, -1) + const Cell(7, 7); });
    getPartyMembers(Ideology.yellow)  .forEach((m) { m.cell = m.cell * const Cell(-1,  1) + const Cell(7, 1); });
    getPartyMembers(Ideology.green)   .forEach((m) { m.cell = m.cell                      + const Cell(1, 1); });
  }

  Party? getPartyInPower() => _parties.firstWhereOrNull((p) => p.chief.cell.isMaze && p.chief.isAlive);
  Iterable<Party> get activeParties => _parties.where((p) => p.isActive);

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
      } while(party.isLost);
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
    } while(party.isLost || (activeParties.length > 2 && _currentIdeology == partyInPower.ideology));
    return party;
  }

  void nextTurn() {
    _currentParty = _nextParty();
    _currentManoeuvre = Manoeuvre(_currentParty);
  }
}
