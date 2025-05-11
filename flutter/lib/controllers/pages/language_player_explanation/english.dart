import 'package:flame/components.dart';
import 'package:flutter/widgets.dart';

import '../../components.dart';
import '../../configs.dart';
import '../base.dart';

class GameSummaryEnglishGame extends BasePage {
  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Define the size of the scrollable area
    final frameSize = Vector2(
      bodySize.x - Configs.smallMargin * 2,
      bodySize.y - Configs.smallMargin * 2,
    );

    // Define the sections of the instructions
    final sections = <Section>[
      Section(
        title: '🎯 Objective',
        content:
            "Be the last player with your Chief alive. Eliminating other players' Chiefs allows you to gain control over their remaining pieces.",
      ),
      Section(
        title: '🧩 Game Components',
        content:
            "Players: 4 (Red, Blue, Yellow, Green).\n"
            "Board: 9×9 grid with the central square (E5) designated as the Maze, symbolizing the seat of power.\n"
            "Pieces per player:\n"
            "- 1 Chief\n"
            "- 1 Assassin\n"
            "- 1 Reporter\n"
            "- 1 Diplomat\n"
            "- 1 Necromobile\n"
            "- 4 Militants",
      ),
      Section(
        title: '🕹️ Gameplay Mechanics',
        content:
            "Turn Order: Players take turns in a fixed sequence.",
      ),
      Section(
        title: 'Movement:',
        content:
            "- Chief, Assassin, Reporter, Diplomat, Necromobile: Move any number of squares in straight lines (like a queen in chess), without jumping over other pieces.\n"
            "- Militants: Move 1 or 2 squares in any direction.",
      ),
      Section(
        title: '⚔️ Actions and Abilities',
        content: "",
      ),
      Section(
        title: "Chief:",
        content:
            "- Can kill by moving onto an opponent's piece.\n"
            "- Places the corpse on any unoccupied square, including the Maze.\n"
            "- When occupying the Maze, gains an extra turn after each opponent's move.\n"
            "- Cannot be killed by Militants while in the Maze.",
      ),
      Section(
        title: "Assassin:",
        content:
            "- Kills by moving onto an opponent's piece.\n"
            "- Places the corpse on the Assassin's original square.",
      ),
      Section(
        title: "Reporter:",
        content:
            "- Kills an adjacent piece (orthogonally) without moving onto it.\n"
            "- The corpse remains in its original position.\n"
            "- Can choose not to kill.",
      ),
      Section(
        title: "Diplomat:",
        content:
            "- Moves an opponent's living piece by swapping places.\n"
            "- The moved piece is placed on any unoccupied square, except the Maze (unless it's a Chief).",
      ),
      Section(
        title: "Necromobile:",
        content:
            "- Moves a corpse by swapping places.\n"
            "- The corpse is placed on any unoccupied square, except the Maze.",
      ),
      Section(
        title: "Militants:",
        content:
            "- Kill by moving onto an opponent's piece.\n"
            "- Place the corpse on any unoccupied square, except the Maze.\n"
            "- Cannot kill a Chief occupying the Maze.",
      ),
      Section(
        title: '🏛️ The Maze (E5)',
        content:
            "Only the Chief can occupy this central square. A Chief in the Maze is considered 'in power' and gains an extra turn after each opponent's move. While in the Maze, the Chief is immune to attacks from Militants. Other pieces can pass through the Maze but cannot stop there.",
      ),
      Section(
        title: '🧟 Corpses',
        content:
            "When a piece is killed, it becomes a corpse and remains on the board, acting as an obstacle. Corpses can be moved by the Necromobile to strategic positions.",
      ),
      Section(
        title: '🤝 Alliances and Betrayals',
        content:
            "Players may form informal alliances, but betrayal is allowed and often strategic. There are no official rules governing alliances; they are based on player negotiation.",
      ),
      Section(
        title: '🏁 Endgame',
        content:
            "The game ends when only one Chief remains alive. When a Chief is killed, the player who eliminated them gains control over the deceased player's remaining pieces. If a Chief is surrounded by corpses and has no Necromobile, they are considered eliminated.",
      ),
    ];

    // Combine all sections into a single string
    final fullText = sections
        .map((section) => '${section.title}\n${section.content}')
        .join('\n\n');

    // Define text style
    final textPaint = TextPaint(
      style: TextStyle(
        fontSize: 18.0,
        color: const Color(0xFFFFFFFF),
      ),
    );

    // Create a scrollable text box component
    final scrollBox = ScrollTextBoxComponent(
      text: fullText,
      textRenderer: textPaint,
      size: frameSize,
      position: Vector2(Configs.smallMargin, Configs.smallMargin),
      boxConfig: TextBoxConfig(
        margins: const EdgeInsets.all(10),
      ),
    );

    // Add the scrollable text box to the game
    await add(scrollBox);
  }
}

// Section model
class Section {
  final String title;
  final String content;
  Section({required this.title, required this.content});
}
