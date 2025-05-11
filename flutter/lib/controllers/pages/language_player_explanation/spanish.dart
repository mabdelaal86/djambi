import 'package:flame/components.dart';
import 'package:flutter/widgets.dart';

import '../../components.dart';
import '../../configs.dart';
import '../base.dart';

class GameSummarySpanishGame extends BasePage {
  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Definir el tamaño del área desplazable
    final frameSize = Vector2(
      bodySize.x - Configs.smallMargin * 2,
      bodySize.y - Configs.smallMargin * 2,
    );

    // Definir las secciones de las instrucciones
    final sections = <Section>[
      Section(
        title: '🎯 Objetivo',
        content:
            "Ser el último jugador con tu Jefe vivo. Eliminar a los Jefes de otros jugadores te permite tomar el control de sus piezas restantes.",
      ),
      Section(
        title: '🧩 Componentes del juego',
        content:
            "Jugadores: 4 (Rojo, Azul, Amarillo, Verde).\n"
            "Tablero: cuadrícula de 9×9 con la casilla central (E5) designada como el Laberinto, simbolizando el asiento del poder.\n"
            "Piezas por jugador:\n"
            "- 1 Jefe\n"
            "- 1 Asesino\n"
            "- 1 Reportero\n"
            "- 1 Diplomático\n"
            "- 1 Necromóvil\n"
            "- 4 Milicianos",
      ),
      Section(
        title: '🕹️ Mecánicas de juego',
        content:
            "Orden de turnos: los jugadores toman turnos en una secuencia fija.",
      ),
      Section(
        title: 'Movimiento:',
        content:
            "- Jefe, Asesino, Reportero, Diplomático, Necromóvil: se mueven cualquier número de casillas en líneas rectas (como la reina en el ajedrez), sin saltar sobre otras piezas.\n"
            "- Milicianos: se mueven 1 o 2 casillas en cualquier dirección.",
      ),
      Section(
        title: '⚔️ Acciones y habilidades',
        content: "",
      ),
      Section(
        title: "Jefe:",
        content:
            "- Puede matar moviéndose sobre la pieza de un oponente.\n"
            "- Coloca el cadáver en cualquier casilla desocupada, incluyendo el Laberinto.\n"
            "- Al ocupar el Laberinto, gana un turno extra después de cada movimiento del oponente.\n"
            "- No puede ser asesinado por Milicianos mientras esté en el Laberinto.",
      ),
      Section(
        title: "Asesino:",
        content:
            "- Mata moviéndose sobre la pieza de un oponente.\n"
            "- Coloca el cadáver en la casilla original del Asesino.",
      ),
      Section(
        title: "Reportero:",
        content:
            "- Mata una pieza adyacente (ortogonalmente) sin moverse sobre ella.\n"
            "- El cadáver permanece en su posición original.\n"
            "- Puede optar por no matar.",
      ),
      Section(
        title: "Diplomático:",
        content:
            "- Mueve una pieza viva del oponente intercambiando lugares.\n"
            "- La pieza movida se coloca en cualquier casilla desocupada, excepto el Laberinto (a menos que sea un Jefe).",
      ),
      Section(
        title: "Necromóvil:",
        content:
            "- Mueve un cadáver intercambiando lugares.\n"
            "- El cadáver se coloca en cualquier casilla desocupada, excepto el Laberinto.",
      ),
      Section(
        title: "Milicianos:",
        content:
            "- Matan moviéndose sobre la pieza de un oponente.\n"
            "- Colocan el cadáver en cualquier casilla desocupada, excepto el Laberinto.\n"
            "- No pueden matar a un Jefe que ocupa el Laberinto.",
      ),
      Section(
        title: '🏛️ El Laberinto (E5)',
        content:
            "Solo el Jefe puede ocupar esta casilla central. Un Jefe en el Laberinto se considera 'en el poder' y gana un turno extra después de cada movimiento del oponente. Mientras esté en el Laberinto, el Jefe es inmune a los ataques de los Milicianos. Otras piezas pueden pasar por el Laberinto pero no pueden detenerse allí.",
      ),
      Section(
        title: '🧟 Cadáveres',
        content:
            "Cuando una pieza es asesinada, se convierte en un cadáver y permanece en el tablero, actuando como un obstáculo. Los cadáveres pueden ser movidos por el Necromóvil a posiciones estratégicas.",
      ),
      Section(
        title: '🤝 Alianzas y traiciones',
        content:
            "Los jugadores pueden formar alianzas informales, pero la traición está permitida y a menudo es estratégica. No hay reglas oficiales que rijan las alianzas; se basan en la negociación entre jugadores.",
      ),
      Section(
        title: '🏁 Fin del juego',
        content:
            "El juego termina cuando solo queda un Jefe vivo. Cuando un Jefe es asesinado, el jugador que lo eliminó toma el control de las piezas restantes del jugador fallecido. Si un Jefe está rodeado de cadáveres y no tiene un Necromóvil, se considera eliminado.",
      ),
    ];

    // Combinar todas las secciones en una sola cadena
    final fullText = sections
        .map((section) => '${section.title}\n${section.content}')
        .join('\n\n');

    // Definir el estilo del texto
    final textPaint = TextPaint(
      style: TextStyle(
        fontSize: 18.0,
        color: const Color(0xFFFFFFFF),
      ),
    );

    // Crear un componente de cuadro de texto desplazable
    final scrollBox = ScrollTextBoxComponent(
      text: fullText,
      textRenderer: textPaint,
      size: frameSize,
      position: Vector2(Configs.smallMargin, Configs.smallMargin),
      boxConfig: TextBoxConfig(
        margins: const EdgeInsets.all(10),
      ),
    );

    // Agregar el cuadro de texto desplazable al juego
    await add(scrollBox);
  }
}

// Modelo de sección
class Section {
  final String title;
  final String content;
  Section({required this.title, required this.content});
}
