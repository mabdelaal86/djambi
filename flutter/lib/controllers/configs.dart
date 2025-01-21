import 'dart:ui';

import 'package:flame/components.dart';

import 'components/utils.dart';

// ignore: avoid_classes_with_only_static_members
abstract class Configs {
  static const actionDuration = Duration(seconds: 1);
  static const aiMaxDepth = 2;

  /// used for developing and testing
  static const saveLoadState = false;
  static const statePath = "game.json";

  static const gameWidth = 820.0;
  static const gameHeight = 1600.0;

  static final smallBtnSize = Vector2.all(80);
  static final mediumBtnSize = Vector2(200, 80);
  static final largeBtnSize = Vector2(320, 100);
  static final headerSize = Vector2(gameWidth, 140);
  static const largeMargin = 50.0;
  static const smallMargin = 25.0;
  static const defaultFontSize = 32.0;
  static const headerFontSize = 40.0;
  static const iconFontSize = 40.0;

  static const textColor = Color(0xFFFFFFFF);
  static const emphaticTextColor = Color(0xFFFFFF00);
  static const pageBackground = Color(0xFF444444);
  static const dialogBackground = Color(0xFF601010);

  static const primaryBtnColors = ButtonColorSchema(
    Color(0xFF00C800),
    Color(0xFF00B400),
    Color(0xFF006400),
    Color(0xFF646464),
    Color(0xFFFFFFFF),
  );

  static const secondaryBtnColors = ButtonColorSchema(
    Color(0x4400C800),
    Color(0x4400B400),
    Color(0x44006400),
    Color(0xFF646464),
    Color(0xFFFFFFFF),
  );
}
