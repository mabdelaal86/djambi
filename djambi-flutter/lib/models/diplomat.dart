import 'common.dart';
import 'member.dart';

class Diplomat extends Member {
  Diplomat(super.parliament, super.ideology);

  @override
  Role get role => Role.diplomat;
}
