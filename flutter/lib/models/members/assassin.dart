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
        final enemy = parliament.getMemberAt(cell);
        // if not empty, it should an alive enemy
        if (enemy != null) return enemy.isAlive;
        // empty cell: not the maze and not the cell coming from if exiting maze
        return !cell.isMaze && (canKill || cell != _cellFrom);
      });

  @override
  void copy(Member other) {
    super.copy(other);
    _cellFrom = (other as Assassin)._cellFrom;
  }

  @override
  bool canBuryOn(Cell cell) => false;

  @override
  void onMove(Cell cell) {
    _cellFrom = location;
    super.onMove(cell);
  }

  @override
  void postMove() {
    if (body == null) {
      manoeuvre = Manoeuvre.end;
      return;
    }

    kill(body!);

    if (body!.location.isMaze) {
      manoeuvre = Manoeuvre.kill;
    } else {
      body!.location = _cellFrom!;
      manoeuvre = Manoeuvre.end;
    }
  }

  @override
  void onExit(Cell cell) {
    super.onExit(cell);
    body!.location = _cellFrom!;
    manoeuvre = Manoeuvre.end;
  }

  @override
  void onBury(Cell cell) => throw UnsupportedError("Unhandled state!");
}
