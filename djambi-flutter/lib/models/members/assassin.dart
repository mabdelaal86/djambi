import '../cell.dart';
import '../common.dart';
import '../member.dart';

class Assassin extends Member {
  Assassin(super.parliament, super.ideology, super.id);

  @override
  Role get role => Role.assassin;

  Cell? _cellFrom;

  @override
  Iterable<Cell> cellsToMove(bool canKill) => super.cellsToMove(canKill).where((cell) {
        final member = parliament.getMemberAt(cell);
        // empty non maze cell or alive enemy member
        // also not the cell that assassin started to move from (in case of exit)
        return (member == null && !cell.isMaze && cell != _cellFrom) ||
               (member != null && member.isAlive);
      });

  @override
  void copy(Member other) {
    super.copy(other);
    _cellFrom = (other as Assassin)._cellFrom;
  }

  @override
  void endManoeuvre() {
    super.endManoeuvre();
    _cellFrom = null;
  }

  @override
  bool canBuryOn(Cell cell) => false;

  @override
  void onMove(Cell cell) {
    _cellFrom = location;
    super.onMove(cell);
  }

  @override
  void onKill() {
    if (body == null) {
      endManoeuvre();
      return;
    }

    kill(body!);

    if (body!.location.isMaze) {
      manoeuvre = Manoeuvre.exit;
    } else {
      body!.location = _cellFrom!;
      endManoeuvre();
    }
  }

  @override
  void onExit(Cell cell) {
    if (!cellsToMove(false).contains(cell)) {
      throw StateError("Can't do an action on the selected cell");
    }
    location = cell;
    body!.location = _cellFrom!;
    endManoeuvre();
  }

  @override
  void onBury(Cell cell) => throw StateError("Unhandled state!");
}
