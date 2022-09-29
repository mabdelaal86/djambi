import 'package:djambi/models/member.dart';

import 'common.dart';
import 'party.dart';

class Manoeuvre {
  final Party party;

  Manoeuvre(this.party);
  Member? selectedMember;

  Iterable<Cell> selectableCells() {
    if (selectedMember != null) {
      return selectedMember!.canMoveTo();
    }
    return party.members.map((p) => p.cell);
  }
}
