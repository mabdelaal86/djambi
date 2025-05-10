import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class GameSummarySpanish extends StatelessWidget {
  final List<Map<String, String>> pieces = [
    {
      'title': 'Djambi es un juego de mesa de estrategia política para 4 jugadores en una cuadrícula de 9×9. El objetivo es ser el último Jefe con vida. La casilla central (el Laberinto) otorga un poder especial a cualquier Jefe que se detenga allí: turnos extra e inmunidad contra ataques militares normales.',
      'image': '',
      'description': ''
    },
    {
      'title': 'Jefe (C) – Líder (símbolo: corona de laurel).',
      'image': 'assets/classic/chief.svg',
      'description':
        'Los Militantes y los Jefes capturan moviéndose a la casilla enemiga y luego colocando el cadáver en cualquier casilla vacía que no sea el Laberinto; cuando un Jefe muere, el asesino inmediatamente toma el control de todas las piezas vivas y muertas de ese Jefe—y cualquier Jefe en E5 es inmune a la captura y hereda todas las piezas eliminadas.'
    },
    {
      'title': 'Asesino (A) – Asesino sigiloso (símbolo: objetivo).',
      'image': 'assets/classic/assassin.svg',
      'description':
        'El Asesino captura igual que un Militante—al moverse a la casilla de una pieza enemiga—pero siempre devuelve el cadáver a la casilla que acaba de abandonar (es decir, “dejar un cuerpo en casa”), impidiendo que ese cadáver se reutilice hasta que se mueva.'
    },
    {
      'title': 'Reportero (R) – Asesino de investigación (símbolo: ojo).',
      'image': 'assets/classic/reporter.svg',
      'description':
        'El Reportero puede matar moviéndose a una de las cuatro casillas ortogonalmente adyacentes al objetivo (no puede matar en diagonal); si acaba de ser reubicado por un Diplomático, debe moverse de nuevo antes de matar; el cadáver permanece en la casilla de aterrizaje del Reportero.'
    },
    {
      'title': 'Militante (M) – Soldado (símbolo: puño) ×4 por jugador.',
      'image': 'assets/classic/militant.svg',
      'description':
        'El Militante es una pieza ofensiva que se mueve una o dos casillas en cualquier dirección (ortogonal o diagonal), captura por reemplazo y coloca el cadáver en cualquier casilla vacía a elección del jugador—excepto el Laberinto central (E5); no puede capturar a un Jefe que esté en el Laberinto.'
    },
    {
      'title': 'Diplomático (Di) – Manipulador político (símbolo: cabeza de dos caras).',
      'image': 'assets/classic/diplomat.svg',
      'description':
        'El Diplomático (también llamado Alborotador o Provocador) es una pieza no letal que manipula la posición de piezas enemigas vivas sin capturarlas.'
    },
    {
      'title': 'Necromóvil (N) – Transportador de cadáveres (símbolo: calavera).',
      'image': 'assets/classic/necromobile.svg',
      'description':
        'Dirige el equipo. Puede matar como un Militante y—si se detiene en el Laberinto (centro)—gana turnos extra e inmunidad contra ataques ordinarios.'
    },
    {
      'title': 'Nota: en partidas de 3 jugadores, las piezas de la cuarta esquina actúan como “rehénes” que cualquier jugador puede mover o matar; su Jefe no otorga poder del Laberinto.',
      'image': '',
      'description': ''
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Resumen del Juego')),
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

class PieceCardSpanish extends StatelessWidget {
  final Map<String, String> piece;
  const PieceCardSpanish(this.piece);

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
