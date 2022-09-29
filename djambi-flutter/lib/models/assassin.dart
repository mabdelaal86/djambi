import 'common.dart';
import 'member.dart';

class Assassin extends Member {
  Assassin(super.parliament, super.ideology);

  @override
  Role get role => Role.assassin;
}
