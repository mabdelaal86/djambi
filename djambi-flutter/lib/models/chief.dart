import 'common.dart';
import 'member.dart';

class Chief extends Member {
  Chief(super.parliament, super.ideology);

  @override
  Role get role => Role.chief;

  @override
  Iterable<Cell> canMoveTo() => super.canMoveTo().where((cell) {
        final member = parliament.getMemberAt(cell);
        // empty cell or alive enemy member
        return member == null || member.isAlive;
      });

  @override
  void act(Cell cell) {
    final enemy = parliament.getMemberAt(cell);

    super.act(cell);
    if (!isActing) return;

    if (manoeuvre == Manoeuvre.kill) {
      _actOnKill(enemy);
    } else if (manoeuvre == Manoeuvre.bury) {
      _actOnBury(cell);
    } else {
      throw StateError("Unhandled state!");
    }
  }

  void _actOnKill(Member? enemy) {
    if (enemy == null) {
      endManoeuvre();
    }
    else {
      enemy.die();
      body = enemy;
      manoeuvre = Manoeuvre.bury;
    }
  }

  void _actOnBury(Cell cell) {
    if (parliament.isEmpty(cell) && !cell.isMaze) {
      body!.cell = cell;
      endManoeuvre();
    }
  }
}
