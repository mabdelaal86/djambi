import '../cell.dart';
import '../common.dart';
import '../member.dart';

class Chief extends Member {
  Chief(super.parliament, super.ideology, super.id);

  @override
  Role get role => Role.chief;

  @override
  Iterable<Cell> cellsToMove(bool canKill) => super.cellsToMove(canKill).where((cell) {
        final member = parliament.getMemberAt(cell);
        // empty cell or alive enemy member
        return member == null || member.isAlive;
      });

  @override
  void postMove() {
    if (body == null) {
      manoeuvre = Manoeuvre.none;
    } else {
      kill(body!);
      manoeuvre = Manoeuvre.exit;
    }
  }
}
