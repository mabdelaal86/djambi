import 'package:collection/collection.dart';

import 'cell.dart';
import 'common.dart';
import 'member.dart';
import 'party.dart';

class Parliament {
  late final List<Party> parties = [
    Party(this, Ideology.red),
    Party(this, Ideology.blue),
    Party(this, Ideology.yellow),
    Party(this, Ideology.green),
  ];

  Party getParty(Ideology ideology) => parties[ideology.index];
  Party? getPartyInPower() => parties.firstWhereOrNull((p) => p.chief.location.isMaze && p.chief.isAlive);
  Iterable<Party> get activeParties => parties.where((p) => p.isActive);

  late final List<Member> members = [];
  Member? getMemberAt(Cell cell) => members.firstWhereOrNull((m) => m.location == cell);
  bool isEmpty(Cell cell) => !members.any((m) => m.location == cell);
  Iterable<Member> getPartyMembers(Ideology ideology) => members.where((m) => m.ideology == ideology);

  late Ideology _currentIdeology = Ideology.first;
  late Party _currentParty = getParty(_currentIdeology);
  Party get currentParty => _currentParty;

  Parliament() {
    _createMembers();
    _setInitialPositions();
  }

  void _createMembers() {
    for (final party in parties) { members.addAll(party.recruitAll()); }
  }

  void _setInitialPositions() {
    getPartyMembers(Ideology.red)   .forEach((m) { m.location = m.location * const Cell( 1, -1) + const Cell(1, 7); });
    getPartyMembers(Ideology.blue)  .forEach((m) { m.location = m.location * const Cell(-1, -1) + const Cell(7, 7); });
    getPartyMembers(Ideology.yellow).forEach((m) { m.location = m.location * const Cell(-1,  1) + const Cell(7, 1); });
    getPartyMembers(Ideology.green) .forEach((m) { m.location = m.location                      + const Cell(1, 1); });
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
      } while(party.isLost);
      return party;
    }
    // else: there is a party in power
    // check if current is not the party in power
    if (currentParty != partyInPower) {
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

  void _nextTurn() {
    _currentParty = _nextParty();
  }

  void act(Cell cell) {
    for (final member in currentParty.members) {
      member.act(cell);
    }
    final member = currentParty.actor;
    if (member != null && member.manoeuvre.finished) {
      member.manoeuvre = Manoeuvre.select;
      _nextTurn();
    }
  }
}
