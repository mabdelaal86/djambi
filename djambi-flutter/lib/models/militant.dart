import 'common.dart';
import 'member.dart';

class Militant extends Member {
  Militant(super.parliament, super.ideology);

  @override
  Role get role => Role.militant;
}
