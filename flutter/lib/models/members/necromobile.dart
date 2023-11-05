import '../cell.dart';
import '../common.dart';
import '../member.dart';

class Necromobile extends Member {
  Necromobile(super.parliament, super.ideology, super.id);

  @override
  Role get role => Role.necromobile;

  @override
  Iterable<Cell> cellsToMove(bool canKill) => super
      .cellsToMove(canKill)
      // empty non maze cell or dead member
      .where((cell) => parliament.getMemberAt(cell)?.isDead ?? !cell.isMaze);

  @override
  void postMove() {
    manoeuvre = switch (body?.location.isMaze) {
      null => Manoeuvre.end,
      true => Manoeuvre.kill,
      false => Manoeuvre.exit,
    };
  }
}
