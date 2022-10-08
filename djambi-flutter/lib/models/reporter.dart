import 'cell.dart';
import 'common.dart';
import 'member.dart';

class Reporter extends Member {
  Reporter(super.parliament, super.ideology);

  @override
  Role get role => Role.reporter;

  @override
  Iterable<Cell> canMoveTo() => super.canMoveTo().where((cell) {
        final member = parliament.getMemberAt(cell);
        // empty non maze cell
        return member == null && !cell.isMaze;
      });

  @override
  Iterable<Cell> canKill() {
    const List<Cell> directions = [
                   Cell(0, -1),
      Cell(-1, 0), /*location*/ Cell(1, 0),
                   Cell(0,  1),
    ];

    bool occupiedByEnemy(Cell cell) {
      final member = parliament.getMemberAt(cell);
      return member != null && member.isAlive && member.ideology != ideology;
    }

    return directions.map((d) => location + d).where(occupiedByEnemy);
  }

  @override
  void proceed(Cell cell) {
    if (manoeuvre == Manoeuvre.kill) {
      _actOnKill(cell);
    } else {
      throw StateError("Unhandled state!");
    }
  }

  void _actOnKill(Cell cell) {
    final cells = canKill().toList();
    if (cells.isEmpty) {
      endManoeuvre();
    } else if (cells.contains(cell)) {
      final member = parliament.getMemberAt(cell);
      member!.die();
      endManoeuvre();
    }
  }
}
