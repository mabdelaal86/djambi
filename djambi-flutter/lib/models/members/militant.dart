import '../cell.dart';
import '../common.dart';
import '../member.dart';

class Militant extends Member {
  Militant(super.parliament, super.ideology, super.id);

  @override
  Role get role => Role.militant;

  @override
  Iterable<Cell> cellsToMove(bool canKill) => super.cellsToMove(canKill).where((cell) {
        final member = parliament.getMemberAt(cell);
        return !cell.isMaze && // can't target maze even if a chief is there
            _stepsTo(cell) <= 2 && // move only 2 steps
            (member == null || member.isAlive); // empty cell or alive enemy member
      });

  int _stepsTo(Cell cell) => (location - cell).abs().max;

  @override
  void postMove() {
    if (body == null) {
      manoeuvre = Manoeuvre.none;
    } else {
      kill(body!);
      manoeuvre = Manoeuvre.exit;
    }
  }
}
