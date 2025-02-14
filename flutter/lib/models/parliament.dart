import 'dart:collection';

import 'package:collection/collection.dart';

import '../common/utils.dart';
import 'cell.dart';
import 'enums.dart';
import 'member.dart';
import 'members/chief.dart';
import 'party.dart';

class Parliament {
  late final List<Member> members;
  Member? getMemberAt(Cell cell) => members.firstWhereOrNull((m) => m.location == cell);
  bool isEmpty(Cell cell) => !members.any((m) => m.location == cell);

  late final List<Party> parties;
  Party getParty(Ideology ideology) => parties.firstWhere((p) => p.ideology == ideology);
  Party? getPartyInPower() => parties.firstWhereOrNull((p) => p.chief.location.isMaze && p.chief.isActive);
  Iterable<Party> get activeParties => parties.where((p) => p.chief.isActive);

  Ideology _currentIdeology;
  late Party _currentParty;
  Party get currentParty => _currentParty;
  final TurnDirection turnDirection;

  Member? _actor;
  Member? get actor => _actor;

  bool get isManoeuvreCompleted => _actor == null;
  bool get isGameFinished => activeParties.length == 1 && isManoeuvreCompleted;
  String getSign() {
    assert(isManoeuvreCompleted, "the maneuver should be completed");
    String key(Member m) => "${m.location.y}${m.location.x}";
    String value(Member m) => m.isDead ? "d**" : "${m.state.name[0]}${m.ideology.name[0]}${m.role.name[0]}";
    final stm = SplayTreeMap<String, String>.fromIterable(members, key: (m) => key(m), value: (m) => value(m));
    final memberSigns = stm.entries.map((e) => "${e.key}${e.value}").join();
    return "${_currentIdeology.name[0]}${_currentParty.ideology.name[0]}$memberSigns#";
  }

  Parliament(this._currentIdeology, this.turnDirection) {
    // create members
    members = Ideology.values.map(_recruitMembers).flattened.toList();
    assert(members.length == 9 * 4, "number of members should be 36 (9 * 4 parties)");
    _setInitialPositions();
    // create parties
    parties = [ for (final m in members) if (m.isChief) Party(m as Chief) ];
    assert(parties.length == 4, "number of parties should be 4");
    // other properties
    _currentParty = getParty(_currentIdeology);
  }

  Parliament.copy(Parliament other)
      : _currentIdeology = other._currentIdeology,
        turnDirection = other.turnDirection {
    // copy members
    members = [ for (final m in other.members) Member.copy(this, m) ];
    assert(members.length == 9 * 4, "number of members should be 36 (9 * 4 parties)");
    // copy parties
    parties = [ for (final m in members) if (m.isChief) Party(m as Chief) ];
    assert(parties.length == 4, "number of parties should be 4");
    // other properties
    _currentParty = getParty(other._currentParty.ideology);
    _actor = other._actor?.id.convert((id) => members[id]);
  }

  Parliament makeCopy() => Parliament.copy(this);

  /// json deserialization
  Parliament.fromJson(Map<String, dynamic> json)
      : _currentIdeology = Ideology.values[json["current_ideology"]],
        turnDirection = TurnDirection.values[json["turn_direction"]] {
    members = [ for (final m in json["members"]) Member.fromJson(this, m) ];
    assert(members.length == 9 * 4, "number of members should be 36 (9 * 4 parties)");
    parties = [ for (final m in members) if (m.isChief) Party(m as Chief) ];
    assert(parties.length == 4, "number of parties should be 4");
    _currentParty = getParty(Ideology.values[json["current_party"]]);
  }

  /// json serialization
  Map<String, dynamic> toJson() {
    assert(isManoeuvreCompleted, "serialization is not allowed during a manoeuvre");
    return {
      "current_ideology": _currentIdeology.index,
      "turn_direction": turnDirection.index,
      "current_party": _currentParty.ideology.index,
      "members": members.map((m) => m.toJson()).toList(),
    };
  }

  Iterable<Member> _recruitMembers(Ideology ideology) sync* {
    final roles = [
      [ Role.chief,    Role.assassin, Role.militant    ],
      [ Role.reporter, Role.diplomat, Role.militant    ],
      [ Role.militant, Role.militant, Role.necromobile ],
    ];

    // create members and place them around (0,0) point, so it is easier to rotate or flip
    for (var r = 0; r < 3; r++) {
      for (var c = 0; c < 3; c++) {
        final id = (ideology.index * 9) + (r * 3) + c;
        yield Member.create(this, roles[r][c], ideology, id)
          ..location = Cell(c - 1, r - 1);
      }
    }
  }

  void _setInitialPositions() {
    void setInitPosition(Ideology ideology, Cell scale, Cell translation) {
      final partyMembers = members.where((m) => m.ideology == ideology);
      for (final member in partyMembers) {
        member.location = member.location * scale + translation;
      }
    }

    setInitPosition(Ideology.red,    const Cell( 1, -1), const Cell(1, 7));
    setInitPosition(Ideology.blue,   const Cell(-1, -1), const Cell(7, 7));
    setInitPosition(Ideology.yellow, const Cell(-1,  1), const Cell(7, 1));
    setInitPosition(Ideology.green,  const Cell( 1,  1), const Cell(1, 1));
  }

  void act(int memberId, Cell cell) {
    assert(!isGameFinished, "the game should be still ongoing");
    if (_actor == null) {
      assert(members[memberId].ideology == _currentParty.ideology, "selected member is not from current turn party");
      assert(members[memberId].isActive, "selected member is not active");
      _actor = members[memberId];
    }
    assert(_actor!.id == memberId, "current actor is not the selected member");
    assert(_actor!.manoeuvre != Manoeuvre.end, "current actor should be in middle of a manoeuvre");
    // do an action
    _actor!.act(cell);
    // if current manoeuvre is finished, move to next turn/player
    if (_actor!.manoeuvre == Manoeuvre.end) {
      _actor!.manoeuvre = Manoeuvre.none;
      _actor = null;
      _checkSurroundings();
      _takeOverParalysed();
      do {
        _nextTurn();
        // checking isGameFinished may be unnecessary, but it might handle a corner case
      } while (!isGameFinished && _currentParty.movableMembers.isEmpty);
    }
  }

  void _nextTurn() {
    assert(isManoeuvreCompleted, "can't turn to next before ending the manoeuvre");
    final parties = activeParties.toList();
    assert(parties.isNotEmpty, "no active parties!");
    if (parties.length == 1) {
      _currentParty = parties[0];
      _currentIdeology = _currentParty.ideology;
    } else {
      final (nextIdeology, nextParty) = getNextTurnState();
      _currentIdeology = nextIdeology;
      _currentParty = nextParty;
    }
  }

  (Ideology, Party) getNextTurnState() {
    assert(!isGameFinished, "the game should be still ongoing");

    Iterable<(Ideology, Party)> nextActiveParties() sync* {
      var ideology = _currentIdeology;
      for (var i = 0; i < Ideology.values.length; i++) {
        ideology = turnDirection.next(ideology);
        final party = getParty(ideology);
        if (party.chief.isActive) yield (ideology, party);
      }
      throw AssertionError("shouldn't reach this point!");
    }

    final partyInPower = getPartyInPower();
    if (partyInPower == null) return nextActiveParties().first;
    if (partyInPower != _currentParty) return (_currentIdeology, partyInPower);

    // currentParty is the partyInPower:
    return switch (activeParties.length) {
      1 => (partyInPower.ideology, partyInPower),
      2 => nextActiveParties().first,
      _ => nextActiveParties().firstWhere((e) => e.$2 != partyInPower),
    };
  }

  void _checkSurroundings() {
    for (final party in activeParties) {
      if (party.isChiefSurrounded()) {
        party.chief.state = MemberState.dead;
        for (final member in party.activeMembers) {
          member.state = MemberState.paralysed;
        }
      }
    }
  }

  void _takeOverParalysed() {
    final partyInPower = getPartyInPower();
    if (partyInPower == null) return;
    for (final member in members) {
      if (member.isParalysed) {
        member.ideology = partyInPower.ideology;
        member.state = MemberState.active;
      }
    }
  }
}
