
import 'package:flame/components.dart';
import 'package:flame_svg/flame_svg.dart';
import 'package:flutter/widgets.dart';

import '../../configs.dart';
import '../base.dart';

// This is the main thesis page that summarizes the entire game.
// The core game logic code related to the rules is written here.
// If any modifications are needed, they should be made in this section first.
// Afterward, you can use any GenAI tool to translate or adapt this code into another language.
// This comment is just a note to explain that the code starts from here.


class GameSummaryEnglishGame extends BasePage {
  GameSummaryEnglishGame() : super(title: "Game Summary");
  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final frameSize = Vector2(
      bodySize.x - Configs.smallMargin * 2,
      bodySize.y - Configs.smallMargin * 2,
    );

    final sections = <Section>[
      Section(
        title: '🎯 Objective',
        content:
            "Be the last player with your Chief alive. Eliminating other players' Chiefs allows you to take control of their remaining pieces.",
        imagePath: null,

      ),
      Section(
        title: '🧩 Game Components',
        content:
            "Players: 4 (Red, Blue, Yellow, Green).\n"
            "Board: 9×9 grid with the central tile (E5) designated as the Labyrinth, symbolizing the seat of power.\n"
            "Pieces per player:\n"
            "- 1 Chief\n"
            "- 1 Assassin\n"
            "- 1 Reporter\n"
            "- 1 Diplomat\n"
            "- 1 Necromobile\n"
            "- 4 Militiamen",
        imagePath: null,
      ),
      Section(
        title: '🕹️ Game Mechanics',
        content:
            "Turn Order: Players take turns in a fixed sequence.",
        imagePath: null,
      ),
      Section(
        title: 'Movement:',
        content:
            "- Chief, Assassin, Reporter, Diplomat, Necromobile: Move any number of tiles in straight lines (like the Queen in chess), without jumping over other pieces.\n"
            "- Militiamen: Move 1 or 2 tiles in any direction.",
        imagePath: null,
      ),
      Section(
        title: '⚔️ Actions and Abilities',
        content: "",
        imagePath: null,
      ),
      Section(
        title: "Chief:",
        content:
            "- Can kill by moving onto an opponent's piece.\n"
            "- Places the corpse on any unoccupied tile, including the Labyrinth.\n"
            "- When occupying the Labyrinth, gains an extra turn after each opponent's move.\n"
            "- Cannot be killed by Militiamen when inside the Labyrinth.",
              imagePath: null,

      ),
      Section(
        title: "Assassin:",
        content:
            "- Kills by moving onto an opponent's piece.\n"
            "- Places the corpse on the Assassin's original tile.",
            imagePath: null,
      ),
      Section(
        title: "Reporter:",
        content:
            "- Kills an adjacent piece (orthogonally) without moving onto it.\n"
            "- The corpse remains in its original position.\n"
            "- Can choose not to kill.",
            imagePath: null,
      ),
      Section(
        title: "Diplomat:",
        content:
            "- Moves a living opponent’s piece by swapping positions.\n"
            "- The moved piece is placed on any unoccupied tile, except the Labyrinth (unless it is a Chief).",
            imagePath: null,
      ),
      Section(
        title: "Necromobile:",
        content:
            "- Moves a corpse by swapping positions.\n"
            "- The corpse is placed on any unoccupied tile, except the Labyrinth.",
            imagePath: null,
      ),
      Section(
        title: "Militiamen:",
        content:
            "- Kill by moving onto an opponent’s piece.\n"
            "- Place the corpse on any unoccupied tile, except the Labyrinth.\n"
            "- Cannot kill a Chief occupying the Labyrinth.",
            imagePath: null,
      ),
      Section(
        title: '🏛️ The Labyrinth (E5)',
        content:
            "Only the Chief can occupy this central tile. A Chief in the Labyrinth is considered 'in power' and gains an extra turn after each opponent's move. While in the Labyrinth, the Chief is immune to attacks from Militiamen. Other pieces may pass through the Labyrinth but cannot stop on it.",
            imagePath: null,
      ),
      Section(
        title: '🧟 Corpses',
        content:
            "When a piece is killed, it becomes a corpse and remains on the board, acting as an obstacle. Corpses can be moved by the Necromobile to strategic positions.",
            imagePath: null,
      ),
      Section(
        title: '🤝 Alliances and Betrayals',
        content:
            "Players may form informal alliances, but betrayal is allowed and often strategic. There are no official rules governing alliances; they are based on negotiation between players.",
            imagePath: null,
      ),
      Section(
        title: '🏁 End of Game',
        content:
            "The game ends when only one Chief remains alive. When a Chief is killed, the player who eliminated them takes control of the deceased player's remaining pieces. If a Chief is surrounded by corpses and lacks a Necromobile, they are considered eliminated.",
            imagePath: null,
      ),
    ];

    final fullText = sections
        .map((section) => '${section.title}\n${section.content}')
        .join('\n\n');

    final textPaint = TextPaint(
      style: TextStyle(
        fontSize: 18.0,
        color: const Color(0xFFFFFFFF),
      ),
    );

    final scrollBox = ScrollTextBoxComponent(
      text: fullText,
      textRenderer: textPaint,
      size: frameSize,
      position: Vector2(Configs.smallMargin, Configs.smallMargin),
      boxConfig: TextBoxConfig(
        margins: const EdgeInsets.all(10),
      ),
    );

    await add(scrollBox);
  }
}


// Section model
class Section {
  final String title;
  final String content;
  final Svg? imagePath;

  Section({
    required this.title,
    required this.content,
    this.imagePath,
  });
}
