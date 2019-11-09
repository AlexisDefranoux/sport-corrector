import 'package:flutter/material.dart';
import 'package:sport_corrector/exercice_menu.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sport Corrector',
      theme: new ThemeData(primarySwatch: Colors.teal),
      home: new ExerciseMenu(),
    );
  }
}