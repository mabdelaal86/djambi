import 'package:flame/components.dart';
import 'package:flame/text.dart';
import 'package:flame_markdown/flame_markdown.dart';
import 'package:flutter/painting.dart';

import '../components.dart';
import '../configs.dart';
import 'base.dart';

const _bodyPadding = EdgeInsets.all(Configs.smallMargin);
const _textHeight = 50.0;

class AboutPage extends BasePage {
  // @override
  // bool get debugMode => true;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    await addAll([
      MultiAlignComponent(
        position: bodyPosition,
        size: bodySize,
        padding: _bodyPadding,
        alignedChildren: {
          Anchor.topCenter: TextElementComponent.fromDocument(
            size: Vector2(
              bodySize.x - _bodyPadding.horizontal,
              (bodySize.y - _bodyPadding.vertical) / 4 * 3,
            ),
            style: DocumentStyle(
              text: InlineTextStyle(
                color: Configs.textColor,
                fontSize: Configs.defaultFontSize,
              ),
            ),
            document: FlameMarkdown.toDocument(
              "**Djambi** is a chess variant for four players designed by *Jean Anesto* in 1975. "
              "As in chess, pieces represent real-life political roles, but in contrast, "
              "they are inspired by modern societies instead of medieval ones. "
              "The game pieces symbolize common sins in modern politics.\n\n"
              "#### Disclaimer & Credits:\n\n"
              "• This game is a **fan-made**, **non-commercial** recreation of Djambi, "
              "a public-domain board game designed by *Jean Anesto* in 1975.\n\n"
              "• This project is **not officially affiliated** with *Jean Anesto*, his heirs, "
              "or any company that may have published Djambi historically.\n\n"
              "• All **original game rules** are used under the principle that game mechanics are not "
              "copyrightable. However, any **original artwork, branding, or terminology** from the 1975 "
              "version remains the property of its respective rights holders.\n\n"
              "• This adaptation is open-source and free to use/distribute for non-commercial purposes.\n\n"
              "• Images of pieces are based on Djambi classic theme create by *Rsalen*\n\n"
              "• If you represent the rights to Djambi and have concerns, "
              "please contact me *(hello@datonomi.com)* for respectful resolution.\n\n"
            ),
          ),
          Anchor.bottomCenter: PositionComponent(
            size: Vector2(
              bodySize.x - _bodyPadding.horizontal,
              (bodySize.y - _bodyPadding.vertical) / 4,
            ),
            children: [
              _wikipediaLink(),
            ],
          ),
        },
      ),
    ]);
  }

  PositionComponent _wikipediaLink() => FlexComponent(
    axis: Axis.horizontal,
    children: [
      TextBoxComponent(
        text: "For more details check the game page on",
        textRenderer: getTextRenderer(
          fontStyle: FontStyle.italic,
        ),
        size: Vector2(600, _textHeight),
      ),
      Hyperlink(
        text: "Wikipedia",
        url: "https://en.wikipedia.org/wiki/Djambi",
        size: Vector2(170, _textHeight),
        fontStyle: FontStyle.italic,
      ),
    ],
  );
}
