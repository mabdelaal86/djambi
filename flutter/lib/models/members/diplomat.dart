import '../cell.dart';
import '../enums.dart';
import '../member.dart';

class Diplomat extends Member {
  new(super.parliament, super.ideology, super.id);

  @override
  Role get role => .diplomat;

  @override
  Iterable<Cell> cellsToMove({required bool canKill}) => super
      .cellsToMove(canKill: canKill)
      // empty non labyrinth cell or active enemy member
      .where((cell) => parliament.getMemberAt(cell)?.isActive ?? !cell.isLabyrinth);

  @override
  bool canBuryOn(Cell cell) =>
      // only leader can be moved into labyrinth
      (!cell.isLabyrinth || body!.isLeader) && parliament.isEmpty(cell);

  @override
  void postMove() {
    manoeuvre = switch (body?.location.isLabyrinth) {
      null => .end,
      true => .kill,
      false => .exit,
    };
  }
}
