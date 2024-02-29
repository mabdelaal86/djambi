import '../cell.dart';
import '../common.dart';
import '../member.dart';

class Chief extends Member {
  Chief(super.parliament, super.ideology, super.id);

  @override
  Role get role => Role.chief;

  @override
  Iterable<Cell> cellsToMove(bool canKill) => super
      .cellsToMove(canKill)
      // empty cell or alive enemy member
      .where((cell) => parliament.getMemberAt(cell)?.isAlive ?? true);

  @override
  void postMove() {
    if (body == null) {
      manoeuvre = Manoeuvre.end;
    } else {
      kill(body!);
      manoeuvre = Manoeuvre.exit;
    }
  }

  @override
  void onMove(Cell cell) {
    super.onMove(cell);
    if (cell.isMaze) {
      for (final party in parliament.parties) {
        if (party.chief.isSurrounded()) {
          party.movableMembers.forEach((m) => m.ideology = ideology);
        }
      }
    }
  }

  @override
  void onExit(Cell cell) => throw UnsupportedError("Unhandled state!");
}
