import 'common.dart';
import 'member.dart';

class Chief extends Member {
  Chief(super.parliament, super.ideology);

  @override
  Role get role => Role.chief;
}
