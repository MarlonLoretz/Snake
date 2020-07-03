import 'package:flutter/material.dart';

//Container für das Klicken zu Beginnen Widget anzuzeigen
final Widget gameStartChild = Container(
  width: 320,
  height: 320,
  padding: const EdgeInsets.all(32),
  child: Center(
    child: Text(
      "Klicken um zu beginnen",
      textAlign: TextAlign.center,
      style: TextStyle(color: Colors.white),
    ),
  ),
);
//Widget un ein neues Snake Rectangle anzuzeigen
final Widget gameRunningChild = Container(
  width: 15.5,
  height: 15.5,
  decoration: new BoxDecoration(
    color: const Color(0xFF009E3B),
    shape: BoxShape.rectangle,
  ),
);
//Widget um neuen Punkt anzuzeigen
final Widget newSnakePointInGame = Container(
  width: 15.5,
  height: 15.5,
  decoration: new BoxDecoration(
    color: const Color(0xFFFFFFFF),
    border: new Border.all(color: Colors.white),
    borderRadius: BorderRadius.zero,
  ),
);

//Klasse für den Kopf der Schlange
class Point {
  double x;
  double y;

  Point(double x, double y) {
    this.x = x;
    this.y = y;
  }
}