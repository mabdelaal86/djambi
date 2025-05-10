import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';


class GameSummaryFrench extends StatelessWidget {
  final List<Map<String, String>> pieces = [
    {
      'title': 'Djambi est un jeu de société stratégique politique pour 4 joueurs sur une grille de 9×9. L’objectif est d’être le dernier Chef en vie. La case centrale (le Labyrinthe) confère un pouvoir spécial à tout Chef qui s’y arrête : tours supplémentaires et immunité contre les attaques militaires normales.',
      'image': '',
      'description': ''
    },
    {
      'title': 'Chef (C) – Leader (symbole : couronne de laurier).',
      'image': 'assets/classic/chief.svg',
      'description':
        'Les Militants et les Chefs capturent en se déplaçant sur la case ennemie puis en plaçant le cadavre sur n’importe quelle case vide non-Labyrinthe ; quand un Chef meurt, le tueur prend immédiatement le contrôle de toutes les pièces vivantes et mortes de ce Chef — et tout Chef sur E5 est immunisé contre la capture et hérite de toutes les pièces éliminées.'
    },
    {
      'title': 'Assassin (A) – Tueur furtif (symbole : cible).',
      'image': 'assets/classic/assassin.svg',
      'description':
        'L’Assassin capture comme un Militant — en se déplaçant sur la case d’une pièce ennemie — mais replace toujours le cadavre sur la case qu’il vient de quitter (c.-à-d. “laisser un corps à la maison”), empêchant ainsi l’utilisation de ce cadavre tant qu’il n’a pas été déplacé.'
    },
    {
      'title': 'Reporter (R) – Tueur d’investigation (symbole : œil).',
      'image': 'assets/classic/reporter.svg',
      'description':
        'Le Reporter peut tuer en se déplaçant sur l’une des quatre cases orthogonalement adjacentes à la cible (ne peut pas tuer en diagonale) ; s’il vient d’être déplacé par un Diplomate, il doit se déplacer de nouveau avant de tuer ; le cadavre reste sur la case d’atterrissage du Reporter.'
    },
    {
      'title': 'Militant (M) – Soldat (symbole : poing) ×4 par joueur.',
      'image': 'assets/classic/militant.svg',
      'description':
        'Le Militant est une pièce offensive qui se déplace d’une ou deux cases dans n’importe quelle direction (orthogonalement ou en diagonale), capture par remplacement, et place le cadavre sur n’importe quelle case vide de son choix — sauf le Labyrinthe central (E5) ; il ne peut pas capturer un Chef en position de pouvoir (occupant le Labyrinthe).'
    },
    {
      'title': 'Diplomate (Di) – Manipulateur politique (symbole : tête à deux faces).',
      'image': 'assets/classic/diplomat.svg',
      'description':
        'Le Diplomate (aussi appelé Fauteur de troubles ou Provocateur) est une pièce non létale qui manipule la position des pièces ennemies vivantes sans les capturer.'
    },
    {
      'title': 'Nécromobile (N) – Déplaceur de cadavres (symbole : crâne).',
      'image': 'assets/classic/necromobile.svg',
      'description':
        'Dirige l’équipe. Peut tuer comme un Militant et — s’il s’arrête sur le Labyrinthe (centre) — gagne des tours supplémentaires et une immunité contre les attaques ordinaires.'
    },
    {
      'title': 'Note : dans les parties à 3 joueurs, les pièces du 4ᵉ coin agissent comme “otages” que n’importe quel joueur peut déplacer ou tuer ; leur Chef n’accorde aucun pouvoir du Labyrinthe.',
      'image': '',
      'description': ''
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Résumé du jeu')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: pieces.length,
        itemBuilder: (context, index) {
          final piece = pieces[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (piece['image']!.isNotEmpty)
                  SvgPicture.asset(
                    piece['image']!,
                    width: 48,
                    height: 48,
                    semanticsLabel: piece['title'],
                  ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        piece['title']!,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (piece['description']!.isNotEmpty) ...[
                        SizedBox(height: 4),
                        Text(
                          piece['description']!,
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class PieceCardFrench extends StatelessWidget {
  final Map<String, String> piece;
  const PieceCardFrench(this.piece);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      elevation: 4,
      child: ListTile(
        leading: piece['image']!.isNotEmpty
            ? Image.network(piece['image']!, width: 50, height: 50)
            : null,
        title: Text(piece['title']!, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: piece['description']!.isNotEmpty
            ? Text(piece['description']!)
            : null,
      ),
    );
  }
}
