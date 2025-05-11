import 'package:flame/components.dart';
import 'package:flutter/widgets.dart';

import '../../components.dart';
import '../../configs.dart';
import '../base.dart';

class GameSummaryFrenchGame extends BasePage {
  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Définir la taille de la zone défilable
    final frameSize = Vector2(
      bodySize.x - Configs.smallMargin * 2,
      bodySize.y - Configs.smallMargin * 2,
    );

    // Définir les sections des instructions
    final sections = <Section>[
      Section(
        title: '🎯 Objectif',
        content:
            "Être le dernier joueur avec votre Chef en vie. Éliminer les Chefs des autres joueurs vous permet de prendre le contrôle de leurs pièces restantes.",
      ),
      Section(
        title: '🧩 Composants du jeu',
        content:
            "Joueurs : 4 (Rouge, Bleu, Jaune, Vert).\n"
            "Plateau : grille 9×9 avec la case centrale (E5) désignée comme le Labyrinthe, symbolisant le siège du pouvoir.\n"
            "Pièces par joueur :\n"
            "- 1 Chef\n"
            "- 1 Assassin\n"
            "- 1 Reporter\n"
            "- 1 Diplomate\n"
            "- 1 Nécromobile\n"
            "- 4 Miliciens",
      ),
      Section(
        title: '🕹️ Mécaniques de jeu',
        content:
            "Ordre de jeu : Les joueurs jouent à tour de rôle dans une séquence fixe.",
      ),
      Section(
        title: 'Déplacement :',
        content:
            "- Chef, Assassin, Reporter, Diplomate, Nécromobile : Se déplacent d'un nombre quelconque de cases en lignes droites (comme la reine aux échecs), sans sauter par-dessus d'autres pièces.\n"
            "- Miliciens : Se déplacent de 1 ou 2 cases dans n'importe quelle direction.",
      ),
      Section(
        title: '⚔️ Actions et capacités',
        content: "",
      ),
      Section(
        title: "Chef :",
        content:
            "- Peut tuer en se déplaçant sur la pièce d'un adversaire.\n"
            "- Place le cadavre sur n'importe quelle case inoccupée, y compris le Labyrinthe.\n"
            "- Lorsqu'il occupe le Labyrinthe, il gagne un tour supplémentaire après chaque mouvement d'un adversaire.\n"
            "- Ne peut pas être tué par les Miliciens lorsqu'il est dans le Labyrinthe.",
      ),
      Section(
        title: "Assassin :",
        content:
            "- Tue en se déplaçant sur la pièce d'un adversaire.\n"
            "- Place le cadavre sur la case d'origine de l'Assassin.",
      ),
      Section(
        title: "Reporter :",
        content:
            "- Tue une pièce adjacente (orthogonalement) sans se déplacer dessus.\n"
            "- Le cadavre reste à sa position d'origine.\n"
            "- Peut choisir de ne pas tuer.",
      ),
      Section(
        title: "Diplomate :",
        content:
            "- Déplace une pièce vivante d'un adversaire en échangeant les places.\n"
            "- La pièce déplacée est placée sur n'importe quelle case inoccupée, sauf le Labyrinthe (sauf si c'est un Chef).",
      ),
      Section(
        title: "Nécromobile :",
        content:
            "- Déplace un cadavre en échangeant les places.\n"
            "- Le cadavre est placé sur n'importe quelle case inoccupée, sauf le Labyrinthe.",
      ),
      Section(
        title: "Miliciens :",
        content:
            "- Tuent en se déplaçant sur la pièce d'un adversaire.\n"
            "- Placent le cadavre sur n'importe quelle case inoccupée, sauf le Labyrinthe.\n"
            "- Ne peuvent pas tuer un Chef occupant le Labyrinthe.",
      ),
      Section(
        title: '🏛️ Le Labyrinthe (E5)',
        content:
            "Seul le Chef peut occuper cette case centrale. Un Chef dans le Labyrinthe est considéré comme 'au pouvoir' et gagne un tour supplémentaire après chaque mouvement d'un adversaire. Lorsqu'il est dans le Labyrinthe, le Chef est immunisé contre les attaques des Miliciens. Les autres pièces peuvent traverser le Labyrinthe mais ne peuvent pas s'y arrêter.",
      ),
      Section(
        title: '🧟 Cadavres',
        content:
            "Lorsqu'une pièce est tuée, elle devient un cadavre et reste sur le plateau, agissant comme un obstacle. Les cadavres peuvent être déplacés par la Nécromobile vers des positions stratégiques.",
      ),
      Section(
        title: '🤝 Alliances et trahisons',
        content:
            "Les joueurs peuvent former des alliances informelles, mais la trahison est autorisée et souvent stratégique. Il n'y a pas de règles officielles régissant les alliances ; elles sont basées sur la négociation entre les joueurs.",
      ),
      Section(
        title: '🏁 Fin de partie',
        content:
            "La partie se termine lorsqu'un seul Chef reste en vie. Lorsqu'un Chef est tué, le joueur qui l'a éliminé prend le contrôle des pièces restantes du joueur décédé. Si un Chef est entouré de cadavres et n'a pas de Nécromobile, il est considéré comme éliminé.",
      ),
    ];

    // Combiner toutes les sections en une seule chaîne
    final fullText = sections
        .map((section) => '${section.title}\n${section.content}')
        .join('\n\n');

    // Définir le style du texte
    final textPaint = TextPaint(
      style: TextStyle(
        fontSize: 18.0,
        color: const Color(0xFFFFFFFF),
      ),
    );

    // Créer un composant de boîte de texte défilable
    final scrollBox = ScrollTextBoxComponent(
      text: fullText,
      textRenderer: textPaint,
      size: frameSize,
      position: Vector2(Configs.smallMargin, Configs.smallMargin),
      boxConfig: TextBoxConfig(
        margins: const EdgeInsets.all(10),
      ),
    );

    // Ajouter la boîte de texte défilable au jeu
    await add(scrollBox);
  }
}

// Modèle de section
class Section {
  final String title;
  final String content;
  Section({required this.title, required this.content});
}
