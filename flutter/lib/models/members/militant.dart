import '../cell.dart';
import '../common.dart';
import '../member.dart';

class Militant extends Member {
  Militant(super.parliament, super.ideology, super.id);

  @override
  Role get role => Role.militant;

  @override
  Iterable<Cell> cellsToMove(bool canKill) =>
      super.cellsToMove(canKill).where((cell) =>
          // can't target maze even if a chief is there
          !cell.isMaze &&
          // move only 2 steps
          _stepsTo(cell) <= 2 &&
          // empty cell or active enemy member
          (parliament.getMemberAt(cell)?.isActive ?? true));

  int _stepsTo(Cell cell) => (location - cell).abs().max;

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
