import 'common.dart';
import 'member.dart';

class Necromobile extends Member {
  Necromobile(super.parliament, super.ideology);

  @override
  Role get role => Role.necromobile;

  @override
  Iterable<Cell> movements() => super.movements().where((cell) {
        final member = parliament.getMemberAt(cell);
        // empty cell & not maze or dead enemy member
        return (member == null && !cell.isMaze) || (member != null && member.isDead);
      });
}
