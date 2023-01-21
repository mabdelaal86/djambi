import '../cell.dart';
import '../common.dart';
import '../member.dart';

class Reporter extends Member {
  Reporter(super.parliament, super.ideology, super.id);

  @override
  Role get role => Role.reporter;

  @override
  Iterable<Cell> cellsToMove() => super.cellsToMove().where((cell) {
        final member = parliament.getMemberAt(cell);
        // empty non maze cell
        return member == null && !cell.isMaze;
      });

  @override
  bool canKillOn(Cell cell) =>
      location.isAdjacentTo(cell) && occupiedByEnemy(cell);

  @override
  void proceed(Cell cell) {
    if (manoeuvre == Manoeuvre.kill) {
      _actOnKill(cell);
    } else {
      throw StateError("Unhandled state!");
    }
  }

  void _actOnKill(Cell cell) {
    final cells = location.adjacentCells().where(occupiedByEnemy).toList();
    if (cells.isEmpty) {
      endManoeuvre();
    } else if (cells.contains(cell)) {
      final member = parliament.getMemberAt(cell);
      kill(member!);
      endManoeuvre();
    }
  }
}
