import '../cell.dart';
import '../common.dart';
import '../member.dart';

class Chief extends Member {
  Chief(super.parliament, super.ideology, super.id);

  @override
  Role get role => Role.chief;

  @override
  Iterable<Cell> cellsToMove() => super.cellsToMove().where((cell) {
        final member = parliament.getMemberAt(cell);
        // empty cell or alive enemy member
        return member == null || member.isAlive;
      });

  @override
  void proceed(Cell cell) {
    if (manoeuvre == Manoeuvre.kill) {
      _actOnKill();
    } else if (manoeuvre == Manoeuvre.bury) {
      _actOnBury(cell);
    } else {
      throw StateError("Unhandled state!");
    }
  }

  void _actOnKill() {
    if (body == null) {
      endManoeuvre();
    } else {
      kill(body!);
      manoeuvre = Manoeuvre.bury;
    }
  }

  void _actOnBury(Cell cell) {
    if (canBuryOn(cell)) {
      body!.location = cell;
      endManoeuvre();
    }
  }
}
