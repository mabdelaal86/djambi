import '../cell.dart';
import '../common.dart';
import '../member.dart';

class Reporter extends Member {
  Reporter(super.parliament, super.ideology, super.id);

  @override
  Role get role => Role.reporter;

  @override
  Iterable<Cell> cellsToMove(bool canKill) => super
      .cellsToMove(canKill)
      // empty non maze cell
      .where((cell) => !cell.isMaze && parliament.isEmpty(cell));

  @override
  bool canKillOn(Cell cell) =>
      location.isAdjacentTo(cell) && occupiedByEnemy(cell);

  bool occupiedByEnemy(Cell cell) {
    final other = parliament.getMemberAt(cell);
    return other != null && other.isAlive && other.ideology != ideology;
  }

  @override
  void postMove() {
    if (!location.adjacentCells().any(occupiedByEnemy)) {
      manoeuvre = Manoeuvre.end;
    }
  }

  @override
  void onKill(Cell cell) {
    assert(canKillOn(cell), "Can't do an action on the selected cell");
    kill(parliament.getMemberAt(cell)!);
    manoeuvre = Manoeuvre.end;
  }

  @override
  void onExit(Cell cell) => throw UnsupportedError("Unhandled state!");

  @override
  void onBury(Cell cell) => throw UnsupportedError("Unhandled state!");
}
