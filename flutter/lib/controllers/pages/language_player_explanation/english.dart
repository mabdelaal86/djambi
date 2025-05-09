import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';


class GameSummaryEnglish extends StatelessWidget {
  final List<Map<String, String>> pieces = [
        {
      'title': 'Djambi is a 4‑player political‑strategy board game on a 9×9 grid. The objective is to be the last Chief alive. The center square (the Maze) grants special power to any Chief who stops there: extra turns and immunity from normal militant attacks.',
      'image': '',
      'description':
        ''
    },
    {
      'title': 'Chief (C) – Leader (symbol: laurel wreath).',
      'image': 'assets/classic/chief.svg',
      'description':
        'Militants and Chiefs both capture by moving onto an enemy’s square and then placing the corpse on any empty non‑maze square; when a Chief dies, the killer immediately gains control of all that Chief’s living and dead pieces—and any Chief on E5 is immune to capture and inherits all eliminated players’ pieces'
    },
        {
      'title': 'Assassin (A) – Stealth killer (symbol: target).',
      'image': 'assets/classic/assassin.svg',
      'description':
        'Assassin: Captures exactly like a Militant—by moving onto an enemy piece’s square—but always returns the victim’s corpse to the square the Assassin just vacated (i.e. “leaving a body at home”), preventing that corpse from being used again until moved.'
    },
      {
      'title': 'Reporter (R) – Investigative killer (symbol: eye).',
      'image': 'assets/classic/reporter.svg',
      'description':
        'Reporter: May kill by moving onto one of the four orthogonally adjacent squares to a target (cannot kill diagonally); if it was just relocated by a Diplomat, it must move again before killing; the corpse remains on the Reporter’s landing square'
    },
      {
      'title': 'Militant (M) – Soldier (symbol: fist) ×4 per player.',
      'image': 'assets/classic/Militant.svg',
      'description':
        'Militant is an offensive piece that moves one or two squares in any direction (orthogonally or diagonally), captures by replacement, and places the corpse on any empty square of the players choice—except the central maze (E5), however, it cannot capture a Chief who is in power (occupying the maze).'
    },
          {
      'title': 'Diplomat (Di) – Political mover (symbol: two-faced head).',
      'image': 'assets/classic/diplomat.svg',
      'description':
        'he Diplomat (also known as the Troublemaker or Provocateur) is a non-lethal piece that manipulates the positions of living enemy pieces without capturing them.'
    },
    {
      'title': 'Necromobile (N) – Corpse mover (symbol: skull).',
      'image': 'assets/classic/necromobile.svg',
      'description':
        'Leads the team. Can kill like a militant and—if he stops on the Maze (center)—gains extra turns and immunity from ordinary militant attacks.'
    },
    {
      'title': 'Note: In 3-player games, the 4th corners pieces act as "hostages" that any player may move or kill; their Chief yields no Maze-power.',
      'image': '',
      'description':
        ''
    },
   
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Game Summary')),
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
                SvgPicture.asset(
                  piece['image']!,
                  width: 48,
                  height: 48,
                  semanticsLabel: piece['title'],
                ),
                SizedBox(width: 12),  // مسافة بين الصورة والنص
                // عمود للنص: عنوان ووصف
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
                      SizedBox(height: 4),
                      Text(
                        piece['description']!,
                        style: TextStyle(fontSize: 14),
                      ),
                      
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


class PieceCard extends StatelessWidget {
  final Map<String, String> piece;
  const PieceCard(this.piece);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      elevation: 4,
      child: ListTile(
        leading: Image.network(piece['image']!, width: 50, height: 50),
        title: Text(piece['title']!, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(piece['description']!),
      ),
    );
  }
}
