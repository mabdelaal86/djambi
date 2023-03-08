import '../cell.dart';
import '../common.dart';
import '../member.dart';

class Reporter extends Member {
  Reporter(super.parliament, super.ideology, super.id);

  @override
  Role get role => Role.reporter;

  @override
  Iterable<Cell> cellsToMove(bool canKill) => super.cellsToMove(canKill).where((cell) {
        final member = parliament.getMemberAt(cell);
        // empty non maze cell
        return member == null && !cell.isMaze;
      });

  @override
  bool canReportOn(Cell cell) =>
      location.isAdjacentTo(cell) && occupiedByEnemy(cell);

  bool occupiedByEnemy(Cell cell) {
    final other = parliament.getMemberAt(cell);
    return other != null && other.isAlive && other.ideology != ideology;
  }

  @override
  void onKill() {
    if (!location.adjacentCells().any(occupiedByEnemy)) {
      endManoeuvre();
    }
  }

  @override
  void onReport(Cell cell) {
    if (!canReportOn(cell)) {
      throw StateError("Can't do an action on the selected cell");
    }
    final member = parliament.getMemberAt(cell);
    kill(member!);
    endManoeuvre();
  }

  @override
  void onBury(Cell cell) => throw StateError("Unhandled state!");
}
