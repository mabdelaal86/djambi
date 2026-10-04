import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import 'utils.dart';

class AboutPage extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(backgroundColor: Theme.of(context).colorScheme.inversePrimary, title: const Text('About')),
    body: Padding(
      padding: const .all(15),
      child: SingleChildScrollView(
        child: Html(
          data: """
            <h1>Djambi <i>[The Chessboard of Machiavelli]</i></h1>
            <p><i>Power is everything. Trust is optional. Betrayal is inevitable.</i></p>
            <p>Welcome to Djambi, a world where politics is war, alliances are temporary, and even the dead have a role
              to play.</p>
            <p>Inspired by the ruthless intrigues of political power, Djambi is a strategic board game where four rival
              parties compete for absolute control. Each player commands a team of political schemers, assassins,
              provocateurs, militants, and manipulators, all united by a single ambition: to eliminate their rivals and
              claim the throne.</p>
            <p>But brute force alone will not win the game. You must forge alliances, negotiate uneasy truces, exploit
              your opponents' weaknesses, and know precisely when to betray those who once stood beside you. Every move
              can change the balance of power, and today's ally may become tomorrow's greatest enemy.</p>
            <p>At the heart of the battlefield lies the Labyrinth, the coveted seat of power. Occupying it grants you
              extraordinary influence and additional turns, but power comes at a price. Your enemies will conspire
              against you, your allies may abandon you, and your reign can end as suddenly as it began.</p>
            <p>And death? In Djambi, death is far from the end. Fallen pieces remain on the board, becoming obstacles,
              weapons, and instruments of manipulation in the hands of any player clever enough to use them.</p>
            <p><i>There are no permanent friends, no guaranteed victories, and no honor among politicians.</i></p>
            <p>Will you rule through diplomacy, deception, or ruthless elimination? Will you build an empire of loyal
              followers or climb to power on the corpses of your enemies?</p>
            <p>The throne awaits. Your rivals are plotting. Choose your moves wisely. In Djambi, the ultimate question
              is not how to seize power, but how long you can keep it.</p>

            <h2>Disclaimer & Credits:</h2>
            <ul>
              <li>This game is a fan-made, non-commercial recreation of Djambi, a public-domain
                board game designed by <i>Jean Anesto</i> in 1975.</li>
              <li>This project is not officially affiliated with <i>Jean Anesto</i>, his heirs, or any
                company that may have published Djambi historically.</li>
              <li>All original game rules are used under the principle that game mechanics are not
                copyrightable. However, any original artwork, branding, or terminology from the 1975
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
