import 'common.dart';
import 'member.dart';

class Militant extends Member {
  Militant(super.parliament, super.ideology);

  @override
  Role get role => Role.militant;

  @override
  Iterable<Cell> canMoveTo() => super.canMoveTo().where((cell) {
        final member = parliament.getMemberAt(cell);
        return !cell.isMaze && // can't target maze even if a chief is there
            _stepsTo(cell) <= 2 && // move only 2 steps
            (member == null || member.isAlive); // empty cell or alive enemy member
      });

  int _stepsTo(Cell cell) => (location - cell).abs().max();

  @override
  void proceed(Cell cell) {
    if (manoeuvre == Manoeuvre.kill) {
      _actOnKill();
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

    body!.die();
    manoeuvre = Manoeuvre.bury;
  }

  void _actOnBury(Cell cell) {
    if (parliament.isEmpty(cell) && !cell.isMaze) {
      body!.location = cell;
      endManoeuvre();
    }
  }
}
