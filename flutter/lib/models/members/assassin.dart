import '../cell.dart';
import '../common.dart';
import '../member.dart';

class Assassin extends Member {
  Assassin(super.parliament, super.ideology, super.id);

  @override
  Role get role => Role.assassin;

  Cell? _cellFrom;

  @override
  Iterable<Cell> cellsToMove(bool canKill) => super
      .cellsToMove(canKill)
      .where((cell) => switch (parliament.getMemberAt(cell)) {
            // not empty cell: it should be occupied by an active enemy
            var enemy? => enemy.isActive,
            // empty cell: not the maze and not the cell coming from if exiting maze
            null => !cell.isMaze && (canKill || cell != _cellFrom),
          });

  @override
  void copyFrom(Member other) {
    super.copyFrom(other);
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
    switch (body?.location.isMaze) {
      case null:
        manoeuvre = Manoeuvre.end;
      case true:
        kill(body!);
        manoeuvre = Manoeuvre.kill;
      case false:
        kill(body!);
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
