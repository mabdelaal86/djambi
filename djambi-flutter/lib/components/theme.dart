import 'package:flutter/material.dart';

import '../models/common.dart';

class GameTheme {
  Color get marginColor   => Colors.grey.shade300;
  Color get cellColor     => Colors.white;
  Color get mazeColor     => Colors.black;
  Color get deadColor     => Colors.grey.shade600;
  Color get lineColor     => Colors.black;

  Map<PlayerId, Color> get playerColors => {
    PlayerId.green:   Colors.green,
    PlayerId.yellow:  Colors.yellow,
    PlayerId.blue:    Colors.blue,
    PlayerId.red:     Colors.red,
  };
}
