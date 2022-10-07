import 'common.dart';
import 'member.dart';

class Necromobile extends Member {
  Necromobile(super.parliament, super.ideology);

  @override
  Role get role => Role.necromobile;

  @override
  Iterable<Cell> canMoveTo() => super.canMoveTo().where((cell) {
        final member = parliament.getMemberAt(cell);
        // empty non maze cell or dead member
        return (member == null && !cell.isMaze) || (member != null && member.isDead);
      });

  @override
  void proceed(Cell cell) {
    if (manoeuvre == Manoeuvre.kill) {
      _actOnKill();
    } else if (manoeuvre == Manoeuvre.move2) {
      _actOnMove2(cell);
    } else if (manoeuvre == Manoeuvre.bury) {
      _actOnBury(cell);
    } else {
      throw StateError("Unhandled state!");
    }
  }

  void _actOnKill() {
    if (body == null) {
      endManoeuvre();
      return;
    }

    manoeuvre = body!.location.isMaze ? Manoeuvre.move2 : Manoeuvre.bury;
  }

  void _actOnMove2(Cell cell) {
    if (canMoveTo().contains(cell)) {
      location = cell;
      manoeuvre = Manoeuvre.bury;
    }
  }

  void _actOnBury(Cell cell) {
    if (parliament.isEmpty(cell) && !cell.isMaze) {
      body!.location = cell;
      endManoeuvre();
    }
  }
}
