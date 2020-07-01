import 'package:flutter/material.dart';
import 'game.dart';


//main methode um die App zu starten
void main() => runApp(MyApp());

//MyApp Klasse: Grundgerüst der ganzen App
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Snake',
      home: Home(),
      debugShowCheckedModeBanner: false,
    );
  }
}

//Home Klasse: Widget mit der AppBar und der Homescreen
class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Snake', style: TextStyle(
            color: Colors.white
        )),
        backgroundColor: Colors.deepPurpleAccent,
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      body: Game(),
    );
  }
}