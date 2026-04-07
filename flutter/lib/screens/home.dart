import 'package:flutter/material.dart';

import '../common/utils.dart';
import 'about.dart';
import 'options.dart';
import 'settings.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(backgroundColor: Theme.of(context).colorScheme.inversePrimary, title: const Text("Djambi")),
    body: Padding(
      padding: const .all(15),
      child: Column(
        children: [
          Expanded(
            child: SizedBox(
              width: 300,
              child: Column(
                mainAxisAlignment: .center,
                crossAxisAlignment: .stretch,
                spacing: 50,
                children: [
                  FilledButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const OptionsPage()));
                    },
                    child: const Text("Play"),
                  ),
                  FilledButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const AboutPage()));
                    },
                    child: const Text("About"),
                  ),
                  FilledButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsPage()));
                    },
                    child: const Text("Settings"),
                  ),
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: .end,
            children: [
              TextButton(
                onPressed: () => openUrl("https://datonomi.github.io/djambi/privacy-policy"),
                child: const Text("Privacy Policy"),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
