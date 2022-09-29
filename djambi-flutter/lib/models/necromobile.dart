import 'common.dart';
import 'member.dart';

class Necromobile extends Member {
  Necromobile(super.parliament, super.ideology);

  @override
  Role get role => Role.necromobile;
}
