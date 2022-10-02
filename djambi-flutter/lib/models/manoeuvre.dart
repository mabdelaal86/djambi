import 'dart:math';

import 'common.dart';
import 'member.dart';
import 'party.dart';

enum Stage {
  select,
  move1,
  kill,
  move2,
  bury,
  end,
  ;

  Stage get next => Stage.values[max(index + 1, bury.index)];
  Stage get previous => Stage.values[min(index - 1, select.index)];
}

class Manoeuvre {
  final Party party;

  Manoeuvre(this.party);

  Stage _stage = Stage.select;
  Stage get stage => _stage;
  bool get canDeselect => stage == Stage.select || stage == Stage.move1;

  Member? _selectedMember;
  Member? get selectedMember => _selectedMember;
  void select(Member member) {
    if (member.isDead || member.ideology != party.ideology) return;
    if (stage != Stage.select) {
      throw StateError("Unexpected to call move in this stage `$stage`.");
    }

    _selectedMember = member;
    _stage = Stage.move1;
  }
  void deselect() {
    if (!canDeselect) {
      throw StateError("Unexpected to call move in this stage `$stage`.");
    }

    _selectedMember = null;
    _stage = Stage.select;
  }

  void move(Cell cell) {
    switch (stage) {
      case Stage.move1:  _move1(cell); break;
      case Stage.kill:   _kill(cell);  break;
      case Stage.move2:  _move2(cell); break;
      case Stage.bury:   _bury(cell);  break;
      default:
        throw StateError("Unexpected to call move in this stage `$stage`.");
    }
  }

  void _move1(Cell cell) {
    if (!_selectedMember!.movements().contains(cell)) return;

    _selectedMember!.cell = cell;
    _stage = _stage.next;
  }

  void _kill(Cell cell) {}

  void _move2(Cell cell) {}

  void _bury(Cell cell) {}
}
