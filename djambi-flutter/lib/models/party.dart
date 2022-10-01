import 'common.dart';
import 'member.dart';
import 'parliament.dart';

// member roles
import 'assassin.dart';
import 'chief.dart';
import 'diplomat.dart';
import 'militant.dart';
import 'necromobile.dart';
import 'reporter.dart';

class Party {
  final Parliament parliament;
  final Member chief;

  Party(this.parliament, Ideology ideology) : chief = Chief(parliament, ideology);

  Ideology get ideology => chief.ideology;
  bool get isLost => chief.isDead;
  bool get isActive => chief.isAlive;

  Iterable<Member> get members => parliament.members.where((m) => m.ideology == ideology && m.isAlive);

  Member _recruit(Role role) {
    switch (role) {
      case Role.assassin:     return Assassin(parliament, ideology);
      case Role.reporter:     return Reporter(parliament, ideology);
      case Role.diplomat:     return Diplomat(parliament, ideology);
      case Role.necromobile:  return Necromobile(parliament, ideology);
      case Role.militant:     return Militant(parliament, ideology);
      default: // not allowed to create another chief
        throw ArgumentError.value(role);
    }
  }

  Iterable<Member> recruitAll() sync* {
    // create members and place them around (0,0) point, so it is easier to rotate or flip
    final members = [
      [ chief,                   _recruit(Role.assassin), _recruit(Role.militant) ],
      [ _recruit(Role.reporter), _recruit(Role.diplomat), _recruit(Role.militant) ],
      [ _recruit(Role.militant), _recruit(Role.militant), _recruit(Role.necromobile) ],
    ];

    for (int r = 0; r < 3; r++) {
      for (int c = 0; c < 3; c++) {
        yield members[r][c]..cell = Cell(c - 1, r - 1);
      }
    }
  }
}
