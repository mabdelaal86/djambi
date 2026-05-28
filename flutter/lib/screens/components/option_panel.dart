import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/utils.dart';
import '../../controllers/preferences.dart';

class OptionPanel extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? label;
  final Widget Function(BuildContext context, Preferences pref) builder;

  const OptionPanel({super.key, required this.title, this.subtitle, this.label, required this.builder});

  @override
  Widget build(BuildContext context) {
    final pref = context.read<Preferences>();
    return Card(
      child: Column(
        crossAxisAlignment: .end,
        children: [
          ListTile(title: Text(title), subtitle: subtitle?.convert(Text.new), trailing: label?.convert(Text.new)),
          ListenableBuilder(listenable: pref, builder: (context, child) => builder.call(context, pref)),
        ],
      ),
    );
  }
}
