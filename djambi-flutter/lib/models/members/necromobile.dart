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
  void proceed(Cell cell) {
    if (manoeuvre == Manoeuvre.kill) {
      _actOnKill();
    } else if (manoeuvre == Manoeuvre.exit) {
      _actOnExit(cell);
    } else if (manoeuvre == Manoeuvre.bury) {
      _actOnBury(cell);
    } else {
      throw StateError("Unhandled state!");
    }
  }

  void _actOnKill() {
    if (body == null) {
      endManoeuvre();
      return;
    }

    manoeuvre = body!.location.isMaze ? Manoeuvre.exit : Manoeuvre.bury;
  }

  void _actOnExit(Cell cell) {
    if (cellsToMove(false).contains(cell)) {
      location = cell;
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
