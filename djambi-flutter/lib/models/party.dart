import 'assassin.dart';
import 'chief.dart';
import 'common.dart';
import 'diplomat.dart';
import 'militant.dart';
import 'necromobile.dart';
import 'member.dart';
import 'reporter.dart';

class Party {
  late final Ideology ideology;
  late List<Member> members;

  Party(this.ideology) {
    // create members and place them around (0,0) point, so it is easier to rotate or flip
    members = [
      Chief(ideology)        ..cell = const Cell(-1, -1),
      Assassin(ideology)     ..cell = const Cell( 0, -1),
      Reporter(ideology)     ..cell = const Cell(-1,  0),
      Diplomat(ideology)     ..cell = const Cell( 0,  0),
      Necromobile(ideology)  ..cell = const Cell( 1,  1),
      Militant(ideology)     ..cell = const Cell(-1,  1),
      Militant(ideology)     ..cell = const Cell( 0,  1),
      Militant(ideology)     ..cell = const Cell( 1,  0),
      Militant(ideology)     ..cell = const Cell( 1, -1),
    ];
  }

  // chief will always be at index 0 and will never be moved to another party
  Member get chief => members[Role.chief.index];

  bool get lost => chief.isDead;
}
