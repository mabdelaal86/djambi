import '../cell.dart';
import '../enums.dart';
import '../member.dart';

class Necromobile extends Member {
  new(super.parliament, super.ideology, super.id);

  @override
  Role get role => .necromobile;

  @override
  Iterable<Cell> cellsToMove({required bool canKill}) => super
      .cellsToMove(canKill: canKill)
      // empty non labyrinth cell or dead member
      .where((cell) => parliament.getMemberAt(cell)?.isDead ?? !cell.isLabyrinth);

  @override
  void postMove() {
    manoeuvre = switch (body?.location.isLabyrinth) {
      null => .end,
      true => .kill,
      false => .exit,
    };
  }
}
