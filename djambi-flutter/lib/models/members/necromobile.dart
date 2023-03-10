import '../cell.dart';
import '../common.dart';
import '../member.dart';

class Necromobile extends Member {
  Necromobile(super.parliament, super.ideology, super.id);

  @override
  Role get role => Role.necromobile;

  @override
  Iterable<Cell> cellsToMove(bool canKill) => super.cellsToMove(canKill).where((cell) {
        final member = parliament.getMemberAt(cell);
        // empty non maze cell or dead member
        return (member == null && !cell.isMaze) ||
               (member != null && member.isDead);
      });

  @override
  void postMove() {
    if (body == null) {
      manoeuvre = Manoeuvre.none;
      return;
    }

    manoeuvre = body!.location.isMaze ? Manoeuvre.kill : Manoeuvre.exit;
  }
}
