import 'dart:convert';
import 'dart:io';

Future<void> save(Object json, String filePath) async {
  final contents = jsonEncode(json);
  await File(filePath).writeAsString(contents);
}

Future<dynamic> load(String filePath) async {
  final file = File(filePath);
  if (!await file.exists()) return null;
  final contents = await file.readAsString();
  return jsonDecode(contents);
}
