import 'common.dart';
import 'member.dart';

class Diplomat extends Member {
  Diplomat(super.parliament, super.ideology);

  @override
  Role get role => Role.diplomat;

  @override
  Iterable<Cell> movements() => super.movements().where((cell) {
        final member = parliament.getMemberAt(cell);
        // empty cell & not maze or alive enemy member
        return (member == null && !cell.isMaze) || (member != null && member.isAlive);
      });
}
