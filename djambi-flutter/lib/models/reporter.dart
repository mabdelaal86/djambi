import 'common.dart';
import 'member.dart';

class Reporter extends Member {
  Reporter(super.parliament, super.ideology);

  @override
  Role get role => Role.reporter;

  @override
  Iterable<Cell> movements() => super.movements().where((cell) {
        final member = parliament.getMemberAt(cell);
        // empty non maze cell
        return member == null && !cell.isMaze;
      });
}
