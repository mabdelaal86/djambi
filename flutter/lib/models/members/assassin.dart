import '../cell.dart';
import '../enums.dart';
import '../member.dart';

class Assassin extends Member {
  new(super.parliament, super.ideology, super.id);

  @override
  Role get role => .assassin;

  Cell? _cellFrom;

  @override
  Iterable<Cell> cellsToMove({required bool canKill}) => super
      .cellsToMove(canKill: canKill)
      .where(
        (cell) => switch (parliament.getMemberAt(cell)) {
          // not empty cell: it should be occupied by an active enemy
          final enemy? => enemy.isActive,
          // empty cell: not the labyrinth and not the cell coming from if exiting labyrinth
          null => !cell.isLabyrinth && (canKill || cell != _cellFrom),
        },
      );

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
    switch (body?.location.isLabyrinth) {
      case null:
        manoeuvre = .end;
      case true:
        kill(body!);
        manoeuvre = .kill;
      case false:
        kill(body!);
        body!.location = _cellFrom!;
        manoeuvre = .end;
    }
  }

  @override
  void onExit(Cell cell) {
    super.onExit(cell);
    body!.location = _cellFrom!;
    manoeuvre = .end;
  }

  @override
  void onBury(Cell cell) => throw UnsupportedError('Unhandled state!');
}
