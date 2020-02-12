import 'dart:ui';
import 'package:flutter/material.dart';

class GridExercises extends StatefulWidget {
  @override
  _GridExercisesState createState() => new _GridExercisesState();
}

class _GridExercisesState extends State<GridExercises> {

  @override
  Widget build(BuildContext context) {
    final List<String> entries = <String>['Choose your exercise :', 'Squat ', 'Burpees', 'Push up'];
    final List<int> colorCodes = <int>[0, 600, 500, 400];

    return ListView.separated(
      padding: const EdgeInsets.only(top: 5.0, bottom: 0, right: 0.0, left: 0.0),
      itemCount: entries.length,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          height: 100,
          child: new RaisedButton(
            color: Colors.red[colorCodes[index]],
            elevation: 0,
            child: new Text('${entries[index]}',
              style: new TextStyle(
                color: Colors.white,
                fontFamily: "Anton-Regular",
                fontSize: 30.0,
              ),
            ),
            onPressed: () {
              print("afficher");
            },
          )
        );
      },
      separatorBuilder: (BuildContext context, int index) => const Divider(),
    );
  }
}