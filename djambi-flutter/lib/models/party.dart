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

  Party(this.parliament, Ideology ideology) : chief = Chief(ideology);

  Ideology get ideology => chief.ideology;
  bool get lost => chief.isDead;

  Iterable<Member> getMembers() => parliament.members.where((m) => m.ideology == ideology);

  Iterable<Member> createMembers() sync* {
    // create members and place them around (0,0) point, so it is easier to rotate or flip
    final members = [
      [ chief,              Assassin(ideology), Militant(ideology) ],
      [ Reporter(ideology), Diplomat(ideology), Militant(ideology) ],
      [ Militant(ideology), Militant(ideology), Necromobile(ideology) ],
    ];

    for (int r = 0; r < 3; r++) {
      for (int c = 0; c < 3; c++) {
        yield members[r][c]..cell = Cell(c - 1, r - 1);
      }
    }
  }
}
