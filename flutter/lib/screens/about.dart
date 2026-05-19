import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import 'utils.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(backgroundColor: Theme.of(context).colorScheme.inversePrimary, title: const Text("About")),
    body: Padding(
      padding: const .all(15),
      child: SingleChildScrollView(
        child: Html(
          data: """
            <b>Djambi</b> is a chess variant for four players designed by <i>Jean Anesto</i> in 1975.
            As in chess, pieces represent real-life political roles, but in contrast,
            they are inspired by modern societies instead of medieval ones.
            The game pieces symbolize common sins in modern politics.
            <br><br>
            For more details check the game page on <a href='https://en.wikipedia.org/wiki/Djambi'>Wikipedia</a>.
            <br>
            <h4>Disclaimer & Credits:</h4>
            <ul>
              <li>This game is a <b>fan-made</b>, <b>non-commercial</b> recreation of Djambi, a public-domain
                board game designed by <i>Jean Anesto</i> in 1975.</li>
              <li>This project is <b>not officially affiliated</b> with <i>Jean Anesto</i>, his heirs, or any
                company that may have published Djambi historically.</li>
              <li>All <b>original game rules</b> are used under the principle that game mechanics are not
                copyrightable. However, any <b>original artwork, branding, or terminology</b> from the 1975
                version remains the property of its respective rights holders.</li>
              <li>This adaptation is open-source and free to use/distribute for non-commercial purposes.</li>
              <li>Images of pieces are based on Djambi classic theme create by <i>Rsalen</i>.</li>
              <li>If you represent the rights to Djambi and have concerns, please
                <a href='mailto:hello@datonomi.com'>contact me</a> for respectful resolution.</li>
            </ul>
          """,
          onLinkTap: (url, attributes, element) => openUrl(url!),
        ),
      ),
    ),
  );
}
