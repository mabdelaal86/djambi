import 'cell.dart';
import 'common.dart';
import 'member.dart';

class Assassin extends Member {
  Assassin(super.parliament, super.ideology);

  @override
  Role get role => Role.assassin;

  @override
  Iterable<Cell> canMoveTo() => super.canMoveTo().where((cell) {
        final member = parliament.getMemberAt(cell);
        // empty non maze cell or alive enemy member
        // also not the cell that assassin started to move from (in case of move2)
        return (member == null && !cell.isMaze && cell != cellFrom) || (member != null && member.isAlive);
      });

  @override
  void proceed(Cell cell) {
    if (manoeuvre == Manoeuvre.kill) {
      _actOnKill();
    } else if (manoeuvre == Manoeuvre.move2) {
      _actOnMove2(cell);
    } else {
      throw StateError("Unhandled state!");
    }
  }

  void _actOnKill() {
    if (body == null) {
      endManoeuvre();
      return;
    }

    body!.die();

    if (body!.location.isMaze) {
      manoeuvre = Manoeuvre.move2;
    } else {
      body!.location = cellFrom!;
      endManoeuvre();
    }
  }

  void _actOnMove2(Cell cell) {
    if (canMoveTo().contains(cell)) {
      location = cell;
      body!.location = cellFrom!;
      endManoeuvre();
    }
  }
}
