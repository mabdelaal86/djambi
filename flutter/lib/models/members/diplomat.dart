import '../cell.dart';
import '../common.dart';
import '../member.dart';

class Diplomat extends Member {
  Diplomat(super.parliament, super.ideology, super.id);

  @override
  Role get role => Role.diplomat;

  @override
  Iterable<Cell> cellsToMove(bool canKill) => super.cellsToMove(canKill).where((cell) {
        final member = parliament.getMemberAt(cell);
        // empty non maze cell or alive enemy member
        return (member == null && !cell.isMaze) ||
               (member != null && member.isAlive);
      });

  @override
  bool canBuryOn(Cell cell) =>
      parliament.isEmpty(cell) && (!cell.isMaze || body!.isChief);  // only chief can be moved into maze

  @override
  void postMove() {
    manoeuvre = body == null ? Manoeuvre.end : body!.location.isMaze ? Manoeuvre.kill : Manoeuvre.exit;
  }
}
