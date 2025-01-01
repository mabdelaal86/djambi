import 'dart:convert';
import 'dart:io';

import '../../models/contest.dart';
import '../../models/parliament.dart';

Future<void> save(State state, String filePath) async {
  final contents = jsonEncode(state.parliament.toJson());
  await File(filePath).writeAsString(contents);
}

Future<State?> load(String filePath) async {
  final file = File(filePath);
  if (!await file.exists()) return null;
  final contents = await file.readAsString();
  final parliament = Parliament.fromJson(jsonDecode(contents));
  return State(parliament);
}
