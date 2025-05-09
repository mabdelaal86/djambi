import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class GameSummarySwedish extends StatelessWidget {
  final List<Map<String, String>> pieces = [
    {
      'title': 'Djambi är ett politiskt strategibrädspel för 4 spelare på ett 9×9 rutnät. Målet är att vara den sista levande Hövdingen. Den mittersta rutan (Labyrinten) ger speciell kraft till en Hövding som stannar där: extra turer och immunitet mot vanliga militära attacker.',
      'image': '',
      'description': ''
    },
    {
      'title': 'Hövding (C) – Ledare (symbol: lagerkrans).',
      'image': 'assets/classic/chief.svg',
      'description':
        'Militanter och Hövdingar fångar genom att flytta till en fienderuta och sedan placera kroppen på en tom ruta som inte är labyrinten; när en Hövding dör tar mördaren omedelbart kontroll över alla den Hövdingens levande och döda pjäser—och en Hövding på E5 är immun mot fångst och ärver alla eliminerade spelares pjäser.'
    },
    {
      'title': 'Lönnmördare (A) – Smygande mördare (symbol: mål).',
      'image': 'assets/classic/assassin.svg',
      'description':
        'Lönnmördaren fångar precis som en militant—genom att flytta till fiendens ruta—men återlämnar alltid kropp på rutan den just lämnade (dvs. “lämna ett lik hemma”), vilket förhindrar att kroppen används igen tills den flyttas.'
    },
    {
      'title': 'Reporter (R) – Undersökande mördare (symbol: öga).',
      'image': 'assets/classic/reporter.svg',
      'description':
        'Reportern kan döda genom att flytta till en av de fyra ortogonalt intilliggande rutorna till målet (kan inte döda diagonalt); om den just flyttats av en Diplomat måste den röra sig igen innan den dödar; kroppen förblir på Reporterns landningsruta.'
    },
    {
      'title': 'Militant (M) – Soldat (symbol: knytnäve) ×4 per spelare.',
      'image': 'assets/classic/Militant.svg',
      'description':
        'Militanten är en offensiv pjäs som rör sig en eller två rutor i valfri riktning (ortogonalt eller diagonalt), fångar genom ersättning, och placerar kroppen på en valfri tom ruta—utom den centrala labyrinten (E5); den kan inte fånga en Hövding som har makten (befinner sig i labyrinten).'
    },
    {
      'title': 'Diplomat (Di) – Politisk flyttare (symbol: tvåansikte).',
      'image': 'assets/classic/diplomat.svg',
      'description':
        'Diplomaten (även kallad Bråkmakare eller Provokatör) är en icke-dödlig pjäs som manipulerar levande fiendepjäser utan att fånga dem.'
    },
    {
      'title': 'Nekromobil (N) – Kroppstransportör (symbol: skalle).',
      'image': 'assets/classic/necromobile.svg',
      'description':
        'Leder laget. Kan döda som en militant och—om den stannar i labyrinten (centrum)—får extra turer och immunitet mot vanliga attacker.'
    },
    {
      'title': 'Notera: i 3-spelarsmatcher fungerar den fjärde hörnens pjäser som “gisslan” som vilken spelare som helst kan flytta eller döda; deras Hövding ger ingen labyrintkraft.',
      'image': '',
      'description': ''
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Spelöversikt')),
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

class PieceCardSwedish extends StatelessWidget {
  final Map<String, String> piece;
  const PieceCardSwedish(this.piece);

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
