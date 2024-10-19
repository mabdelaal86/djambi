import '../cell.dart';
import '../enums.dart';
import '../member.dart';

class Diplomat extends Member {
  Diplomat(super.parliament, super.ideology, super.id);

  @override
  Role get role => Role.diplomat;

  @override
  Iterable<Cell> cellsToMove({required bool canKill}) => super
      .cellsToMove(canKill: canKill)
      // empty non maze cell or active enemy member
      .where((cell) => parliament.getMemberAt(cell)?.isActive ?? !cell.isMaze);

  @override
  bool canBuryOn(Cell cell) =>
      // only chief can be moved into maze
      (!cell.isMaze || body!.isChief) && parliament.isEmpty(cell);

  @override
  void postMove() {
    manoeuvre = switch (body?.location.isMaze) {
      null => Manoeuvre.end,
      true => Manoeuvre.kill,
      false => Manoeuvre.exit,
    };
  }
}
