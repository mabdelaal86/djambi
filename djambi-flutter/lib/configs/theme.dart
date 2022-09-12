import 'package:flutter/material.dart';

import 'common.dart';

class GameTheme {
  Color get marginColor   => Colors.white;
  Color get cellColor     => Colors.grey;
  Color get mazeColor     => Colors.black;
  Color get deadColor     => Colors.black;
  Color get lineColor     => Colors.black;

  Map<Player, Color> get playerColors => {
    Player.green:   Colors.green,
    Player.yellow:  Colors.yellow,
    Player.blue:    Colors.blue,
    Player.red:     Colors.red,
  };
}
