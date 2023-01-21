import '../cell.dart';
import '../common.dart';
import '../member.dart';

class Assassin extends Member {
  Assassin(super.parliament, super.ideology, super.id);

  @override
  Role get role => Role.assassin;

  @override
  Iterable<Cell> cellsToMove() => super.cellsToMove().where((cell) {
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
    } else if (manoeuvre == Manoeuvre.move2) {
      _actOnMove2(cell);
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
      manoeuvre = Manoeuvre.move2;
    } else {
      body!.location = cellFrom!;
      endManoeuvre();
    }
  }

  void _actOnMove2(Cell cell) {
    if (cellsToMove().contains(cell)) {
      location = cell;
      body!.location = cellFrom!;
      endManoeuvre();
    }
  }
}
