import 'common.dart';
import 'member.dart';

class Diplomat extends Member {
  Diplomat(super.parliament, super.ideology);

  @override
  Role get role => Role.diplomat;

  @override
  Iterable<Cell> canMoveTo() => super.canMoveTo().where((cell) {
        final member = parliament.getMemberAt(cell);
        // empty non maze cell or alive enemy member
        return (member == null && !cell.isMaze) || (member != null && member.isAlive);
      });
}
