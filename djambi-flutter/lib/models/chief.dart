import 'common.dart';
import 'member.dart';

class Chief extends Member {
  Chief(super.parliament, super.ideology);

  @override
  Role get role => Role.chief;

  @override
  Iterable<Cell> movements() => super.movements().where((cell) {
        final member = parliament.getMemberAt(cell);
        // empty cell or alive enemy member
        return member == null || member.isAlive;
      });
}
