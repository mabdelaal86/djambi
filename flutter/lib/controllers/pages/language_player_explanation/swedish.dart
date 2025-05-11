import 'package:flame/components.dart';
import 'package:flutter/widgets.dart';

import '../../components.dart';
import '../../configs.dart';
import '../base.dart';

class GameSummarySwedishGame extends BasePage {
  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Definiera storleken på det rullbara området
    final frameSize = Vector2(
      bodySize.x - Configs.smallMargin * 2,
      bodySize.y - Configs.smallMargin * 2,
    );

    // Definiera sektionerna i instruktionerna
    final sections = <Section>[
      Section(
        title: '🎯 Mål',
        content:
            "Var den sista spelaren med din Chef vid liv. Att eliminera andra spelares Chefer låter dig ta kontroll över deras återstående pjäser.",
      ),
      Section(
        title: '🧩 Spelkomponenter',
        content:
            "Spelare: 4 (Röd, Blå, Gul, Grön).\n"
            "Bräde: 9×9 rutnät med den centrala rutan (E5) som är utpekad som Labyrinten, som symboliserar maktens säte.\n"
            "Pjäser per spelare:\n"
            "- 1 Chef\n"
            "- 1 Mördare\n"
            "- 1 Reporter\n"
            "- 1 Diplomat\n"
            "- 1 Nekromobil\n"
            "- 4 Militärer",
      ),
      Section(
        title: '🕹️ Spelmekanik',
        content:
            "Turordning: Spelarna turas om i en fast sekvens.",
      ),
      Section(
        title: 'Rörelse:',
        content:
            "- Chef, Mördare, Reporter, Diplomat, Nekromobil: Rör sig ett valfritt antal rutor i raka linjer (som en dam i schack), utan att hoppa över andra pjäser.\n"
            "- Militärer: Rör sig 1 eller 2 rutor i valfri riktning.",
      ),
      Section(
        title: '⚔️ Handlingar och förmågor',
        content: "",
      ),
      Section(
        title: "Chef:",
        content:
            "- Kan döda genom att flytta till en motståndares pjäs.\n"
            "- Lägger kroppen på en ledig ruta, inklusive Labyrinten.\n"
            "- När den befinner sig i Labyrinten får den en extra tur efter varje motståndares drag.\n"
            "- Kan inte dödas av Militärer medan den är i Labyrinten.",
      ),
      Section(
        title: "Mördare:",
        content:
            "- Dödar genom att flytta till en motståndares pjäs.\n"
            "- Lägger kroppen på Mördarens ursprungliga ruta.",
      ),
      Section(
        title: "Reporter:",
        content:
            "- Dödar en angränsande pjäs (ortogonalt) utan att flytta till den.\n"
            "- Kroppen förblir på sin ursprungliga position.\n"
            "- Kan välja att inte döda.",
      ),
      Section(
        title: "Diplomat:",
        content:
            "- Flyttar en motståndares levande pjäs genom att byta plats.\n"
            "- Den flyttade pjäsen placeras på en ledig ruta, utom Labyrinten (om det inte är en Chef).",
      ),
      Section(
        title: "Nekromobil:",
        content:
            "- Flyttar en kropp genom att byta plats.\n"
            "- Kroppen placeras på en ledig ruta, utom Labyrinten.",
      ),
      Section(
        title: "Militärer:",
        content:
            "- Dödar genom att flytta till en motståndares pjäs.\n"
            "- Lägger kroppen på en ledig ruta, utom Labyrinten.\n"
            "- Kan inte döda en Chef som befinner sig i Labyrinten.",
      ),
      Section(
        title: '🏛️ Labyrinten (E5)',
        content:
            "Endast Chefen kan befinna sig på denna centrala ruta. En Chef i Labyrinten anses vara 'vid makten' och får en extra tur efter varje motståndares drag. När den är i Labyrinten är Chefen immun mot attacker från Militärer. Andra pjäser kan passera genom Labyrinten men kan inte stanna där.",
      ),
      Section(
        title: '🧟 Kroppar',
        content:
            "När en pjäs dödas blir den en kropp och förblir på brädet, vilket fungerar som ett hinder. Kroppar kan flyttas av Nekromobilen till strategiska positioner.",
      ),
      Section(
        title: '🤝 Allianser och förräderi',
        content:
            "Spelare kan bilda informella allianser, men förräderi är tillåtet och ofta strategiskt. Det finns inga officiella regler som styr allianser; de baseras på spelarförhandlingar.",
      ),
      Section(
        title: '🏁 Slutspel',
        content:
            "Spelet slutar när endast en Chef förblir vid liv. När en Chef dödas, tar den spelare som eliminerade den kontroll över den avlidne spelarens återstående pjäser. Om en Chef är omgiven av kroppar och inte har en Nekromobil, anses den vara eliminerad.",
      ),
    ];

    // Kombinera alla sektioner till en enda sträng
    final fullText = sections
        .map((section) => '${section.title}\n${section.content}')
        .join('\n\n');

    // Definiera textstil
    final textPaint = TextPaint(
      style: TextStyle(
        fontSize: 18.0,
        color: const Color(0xFFFFFFFF),
      ),
    );

    // Skapa en rullbar textruta-komponent
    final scrollBox = ScrollTextBoxComponent(
      text: fullText,
      textRenderer: textPaint,
      size: frameSize,
      position: Vector2(Configs.smallMargin, Configs.smallMargin),
      boxConfig: TextBoxConfig(
        margins: const EdgeInsets.all(10),
      ),
    );

    // Lägg till den rullbara textrutan i spelet
    await add(scrollBox);
  }
}

// Sektionmodell
class Section {
  final String title;
  final String content;
  Section({required this.title, required this.content});
}
