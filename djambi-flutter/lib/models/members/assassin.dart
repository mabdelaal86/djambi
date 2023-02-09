import '../cell.dart';
import '../common.dart';
import '../member.dart';

class Assassin extends Member {
  Assassin(super.parliament, super.ideology, super.id);

  @override
  Role get role => Role.assassin;

  @override
  Iterable<Cell> cellsToMove(bool canKill) => super.cellsToMove(canKill).where((cell) {
        final member = parliament.getMemberAt(cell);
        // empty non maze cell or alive enemy member
        // also not the cell that assassin started to move from (in case of move2)
        return (member == null && !cell.isMaze && cell != cellFrom) ||
               (member != null && member.isAlive);
      });

  @override
  bool canBuryOn(Cell cell) => cell == cellFrom;

  @override
  void proceed(Cell cell) {
    if (manoeuvre == Manoeuvre.kill) {
      _actOnKill();
    } else if (manoeuvre == Manoeuvre.exit) {
      _actOnExit(cell);
    } else {
      throw StateError("Unhandled state!");
    }
  }

  void _actOnKill() {
    if (body == null) {
      endManoeuvre();
      return;
    }

    kill(body!);

    if (body!.location.isMaze) {
      manoeuvre = Manoeuvre.exit;
    } else {
      body!.location = cellFrom!;
      endManoeuvre();
    }
  }

  void _actOnExit(Cell cell) {
    if (cellsToMove(false).contains(cell)) {
      location = cell;
      body!.location = cellFrom!;
      endManoeuvre();
    }
  }
}
