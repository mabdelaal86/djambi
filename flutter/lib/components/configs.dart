import 'dart:ui';

import 'package:flame/components.dart';

import 'utils/ui.dart';

const actionDuration = Duration(seconds: 1);

/// used for developing and testing
const saveLoadState = false;
const statePath = "parliament.json";

const gameWidth = 820.0;
const gameHeight = 1600.0;

final smallBtnSize = Vector2.all(80);
final mediumBtnSize = Vector2(200, 80);
final largeBtnSize = Vector2(320, 100);
final headerSize = Vector2(gameWidth, 140);
const largeMargin = 50.0;
const smallMargin = 25.0;
const defaultFontSize = 32.0;
const headerFontSize = 40.0;
const iconFontSize = 40.0;

const textColor = Color(0xFFFFFFFF);
const emphaticTextColor = Color(0xFFFFFF00);
final pageBackground = Paint()
  ..color = const Color(0x88888888);

const primaryBtnColors = ButtonColorSchema(
  Color(0xFF00C800),
  Color(0xFF00B400),
  Color(0xFF006400),
  Color(0xFF646464),
  Color(0xFFFFFFFF),
);

const secondaryBtnColors = ButtonColorSchema(
  Color(0x4400C800),
  Color(0x4400B400),
  Color(0x44006400),
  Color(0xFF646464),
  Color(0xFFFFFFFF),
);
