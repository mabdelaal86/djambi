import 'common.dart';
import 'member.dart';

class Assassin extends Member {
  Assassin(super.parliament, super.ideology);

  @override
  Role get role => Role.assassin;

  @override
  Iterable<Cell> canMoveTo() => super.canMoveTo().where((cell) {
        final member = parliament.getMemberAt(cell);
        // empty non maze cell or alive enemy member
        return (member == null && !cell.isMaze) || (member != null && member.isAlive);
      });
}
