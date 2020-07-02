import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'children_at_different_states.dart';


// 2 Enums mit Richtungen und Game States
enum Direction { LEFT, RIGHT, UP, DOWN }
enum GameState { START, RUNNING, FAILURE }

// Die Game Klasse mit dem Stateful Widget
class Game extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _GameState();
}
/*Die Game State Klasse: Hier werden verschiedene Variablen initialisiert, die wir später brauchen.
  Die Startdirection wird gesetzt und der GameState auf Start gesetzt.
*/
class _GameState extends State<Game> {
  var snakePosition;
  var gameState = GameState.START;
  Direction _direction = Direction.UP;
  Timer timer;
  Point newPointPosition;
  int score = 0;

//Dieses Widget ist das Widget, indem sich die Schalnge fortbewegen wird.
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Container(
          height: 320,
          width: 320,
          padding: EdgeInsets.all(29),
          decoration: BoxDecoration(
            border: Border(
              //Borders werden weiss gemacht
              top: BorderSide(width: 4.0, color: Colors.white),
              bottom: BorderSide(width: 4.0, color: Colors.white),
              left: BorderSide(width: 4.0, color: Colors.white),
              right: BorderSide(width: 4.0, color: Colors.white),
            ),
          ),
          //Der GestureDetector schuaut ob ein klick ausgeführt wurde.
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTapUp: (tapUpDetails) {
              _handleTap(tapUpDetails);
            },
            child: _getChildBasedOnGameState(),
          ),
        ),
        Padding(
          // Hier wird die Punkte anzeige gemacht.
          padding: EdgeInsets.only(left: 60.0, right: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                width: 100,
                height: 100,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(width: 1.0, color: Colors.white),
                  //Mit BorderRadius kann die anzeige gerundet werden
                  borderRadius: BorderRadius.circular(50.0),
                ),
                //Nach dem Spiel wir der score angezeigt
                child: Text(
                  "Punkte\n$score",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              // Hier werden die 4 Buttons  gemacht, die für den Richtungswechsel gebraucht werden
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(right: 50),
                    child: RaisedButton(
                      onPressed: () {
                        setState(() {
                          _direction = Direction.UP;
                        });
                      },
                      color: Colors.deepPurpleAccent,
                      child: Icon(Icons.keyboard_arrow_up),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      RaisedButton(
                        onPressed: () {
                          setState(() {
                            _direction = Direction.LEFT;
                          });
                        },
                        color: Colors.deepPurpleAccent,
                        child: Icon(Icons.keyboard_arrow_left),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: RaisedButton(
                          onPressed: () {
                            setState(() {
                              _direction = Direction.RIGHT;
                            });
                          },
                          color: Colors.deepPurpleAccent,
                          child: Icon(Icons.keyboard_arrow_right),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 50),
                    child: RaisedButton(
                      onPressed: () {
                        setState(() {
                          _direction = Direction.DOWN;
                        });
                      },
                      color: Colors.deepPurpleAccent,
                      child: Icon(Icons.keyboard_arrow_down),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
//handleTap methode um das Game zu starten wenn man tapped
  void _handleTap(TapUpDetails tapUpDetails) {
    switch (gameState) {
      case GameState.START:
        startToRunState();
        break;
      case GameState.RUNNING:
        break;
      case GameState.FAILURE:
        setGameState(GameState.START);
        break;
    }
  }
// startToRun Methode um die Schlange zu starten mit der Startrichtung nach oben
  void startToRunState() {
    setGameState(GameState.RUNNING);
    startingSnake();
    timer = new Timer.periodic(new Duration(milliseconds: 400), onTimeTick);
    generatenewPoint();
    _direction = Direction.UP;

  }
// startingSnake Methode findet den Mittelpunkt und setzt die Schlange
  void startingSnake() {
    setState(() {
      final midPoint = (320 / 20 / 2);
        snakePosition = [
          Point(midPoint, midPoint - 1),
          Point(midPoint, midPoint),
          Point(midPoint, midPoint + 1),
      ];
    });
  }
//generatenewPoint Methode kreiert den Punkt auf dem Brett
  void generatenewPoint() {
    setState(() {
      Random rng = Random();
      var min = 0;
      var max = 320 ~/ 20;
      var nextY = min + rng.nextInt(max - min);
      var nextX = min + rng.nextInt(max - min);

      var newRedPoint = Point(nextX.toDouble(), nextY.toDouble());
//Wenn die Schlange den Punkt gefressen hat wird ein neuer generiert
      if (snakePosition.contains(newRedPoint)) {
        generatenewPoint();
      }else{
        newPointPosition = newRedPoint;
      }
    });
  }
// setGameState Methode um die game State zu setzen
  void setGameState(GameState _gameState) {
    setState(() {
      gameState = _gameState;
    });
  }
//Widget das verschiedene Childs je nach Status des Games hat
  Widget _getChildBasedOnGameState() {
    var child;
    switch (gameState) {
      case GameState.START:
        setState(() {
          score = 0;
        });
        child = gameStartChild;
        break;

      case GameState.RUNNING:
        List<Positioned> snakePiecesWithNewPoints = List();
        snakePosition.forEach(
              (i) {
            snakePiecesWithNewPoints.add(
              Positioned(
                child: gameRunningChild,
                left: i.x * 15.5,
                top: i.y * 15.5,
              ),
            );
          },
        );
        final latestPoint = Positioned(
          child: newSnakePointInGame,
          left: newPointPosition.x * 15.5,
          top: newPointPosition.y * 15.5,
        );
        snakePiecesWithNewPoints.add(latestPoint);
        child = Stack(children: snakePiecesWithNewPoints);
        break;

      case GameState.FAILURE:
        timer.cancel();
        child = Container(
          width: 320,
          height: 320,
          padding: const EdgeInsets.all(32),
          child: Center(
            child: Text(
              "Du hast $score Punkte erreicht!",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
        break;
    }
    return child;
  }

  void onTimeTick(Timer timer) {
    setState(() {
      snakePosition.insert(0, getLatestSnake());
      snakePosition.removeLast();
    });

    var currentHeadPos = snakePosition.first;
    if (currentHeadPos.x < 0 ||
        currentHeadPos.y < 0 ||
        currentHeadPos.x > 320 / 20 ||
        currentHeadPos.y > 320 / 20) {
      setGameState(GameState.FAILURE);
      return;
    }

    if (snakePosition.first.x == newPointPosition.x &&
        snakePosition.first.y == newPointPosition.y) {
      generatenewPoint();
      setState(() {
        if (score <= 10)
          score = score + 1;
        else if (score > 10 && score <= 25)
          score = score + 2;
        else
          score = score + 3;
        snakePosition.insert(0, getLatestSnake());
      });
    }
  }

  Point getLatestSnake() {
    var newHeadPos;

    switch (_direction) {
      case Direction.LEFT:
        var currentHeadPos = snakePosition.first;
        newHeadPos = Point(currentHeadPos.x - 1, currentHeadPos.y);
        break;

      case Direction.RIGHT:
        var currentHeadPos = snakePosition.first;
        newHeadPos = Point(currentHeadPos.x + 1, currentHeadPos.y);
        break;

      case Direction.UP:
        var currentHeadPos = snakePosition.first;
        newHeadPos = Point(currentHeadPos.x, currentHeadPos.y - 1);
        break;

      case Direction.DOWN:
        var currentHeadPos = snakePosition.first;
        newHeadPos = Point(currentHeadPos.x, currentHeadPos.y + 1);
        break;
    }
    return newHeadPos;
  }
}