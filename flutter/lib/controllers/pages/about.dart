import 'package:flame/components.dart';
import 'package:flutter/painting.dart';

import '../../common/utils.dart';
import '../components.dart';
import '../components/hyperlink.dart';
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

    final panelSize = Vector2(
      bodySize.x - _bodyPadding.horizontal,
      (bodySize.y - _bodyPadding.vertical) / 2,
    );

    await addAll([
      MultiAlignComponent(
        position: bodyPosition,
        size: bodySize,
        padding: _bodyPadding,
        alignedChildren: {
          Anchor.topCenter: TextBoxComponent(
            size: panelSize,
            textRenderer: getTextRenderer(),
            text:
                "Djambi is a chess variant for four players designed by Jean Anesto in 1975. "
                "As in chess, pieces represent real-life political roles, but in contrast, "
                "they are inspired by modern societies instead of medieval ones. "
                "The game pieces symbolize common sins in modern politics.",
          ),
          Anchor.bottomCenter: PositionComponent(
            size: panelSize,
            children: [
              MultiAlignComponent(
                anchor: Anchor.topCenter,
                position: Anchor.topCenter.ofSize(panelSize),
                size: Vector2(panelSize.x, _textHeight * 3),
                alignedChildren: {
                  Anchor.topLeft: _wikipediaLink(),
                  Anchor.centerLeft: _credits(),
                  Anchor.bottomLeft: _privacyPolicy(),
                },
              ),
            ],
          ),
        },
      ),
    ]);
  }

  PositionComponent _wikipediaLink() => FlexComponent(
    axis: Axis.horizontal,
    children: [
      _bullet(),
      TextBoxComponent(
        text: "For more details check game page on",
        textRenderer: getTextRenderer(),
        size: Vector2(550, _textHeight),
      ),
      Hyperlink(
        text: "Wikipedia",
        url: "https://en.wikipedia.org/wiki/Djambi",
        size: Vector2(170, _textHeight),
      ),
    ],
  );

  PositionComponent _privacyPolicy() => FlexComponent(
    axis: Axis.horizontal,
    children: [
      _bullet(),
      Hyperlink(
        text: "Privacy Policy",
        url: "https://datonomi.github.io/djambi/privacy-policy",
        size: Vector2(230, _textHeight),
      ),
    ],
  );

  PositionComponent _credits() => FlexComponent(
    axis: Axis.horizontal,
    children: [
      _bullet(),
      TextBoxComponent(
        text: "Piece images are originally created by",
        textRenderer: getTextRenderer(),
        size: Vector2(560, _textHeight),
      ),
      Hyperlink(
        text: "Rsalen",
        url: "https://commons.wikimedia.org/wiki/User:Rsalen",
        size: Vector2(130, _textHeight),
      ),
    ],
  );
  
  PositionComponent _bullet() => TextBoxComponent(
    text: "•",
    textRenderer: getTextRenderer(),
    size: Vector2(30, _textHeight),
  );
}
