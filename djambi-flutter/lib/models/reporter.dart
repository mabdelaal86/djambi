import 'common.dart';
import 'member.dart';

class Reporter extends Member {
  Reporter(super.parliament, super.ideology);

  @override
  Role get role => Role.reporter;
}
