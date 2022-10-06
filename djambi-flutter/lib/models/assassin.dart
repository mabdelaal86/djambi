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
  void act(Cell cell) {
    final enemy = parliament.getMemberAt(cell);

    super.act(cell);
    if (manoeuvre.isWaiting) return;

    if (manoeuvre == Manoeuvre.kill) {
      _actOnKill(enemy);
    } else if (manoeuvre == Manoeuvre.move2) {
      _actOnMove2(cell);
    } else {
      throw StateError("Unhandled state!");
    }
  }

  void _actOnKill(Member? enemy) {
    if (enemy == null) {
      endManoeuvre();
      return;
    }

    enemy.die();

    if (enemy.location.isMaze) {
      body = enemy;
      manoeuvre = Manoeuvre.move2;
    }
    else {
      enemy.location = cellFrom!;
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
