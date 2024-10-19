import '../cell.dart';
import '../enums.dart';
import '../member.dart';

class Chief extends Member {
  Chief(super.parliament, super.ideology, super.id);

  @override
  Role get role => Role.chief;

  @override
  Iterable<Cell> cellsToMove({required bool canKill}) => super
      .cellsToMove(canKill: canKill)
      // empty cell or active enemy member
      .where((cell) => parliament.getMemberAt(cell)?.isActive ?? true);

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
  void onExit(Cell cell) => throw UnsupportedError("Unhandled state!");
}
