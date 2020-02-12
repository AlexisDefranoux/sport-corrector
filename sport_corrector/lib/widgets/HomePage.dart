import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:sport_corrector/data/AppColors.dart';
import 'package:sport_corrector/widgets/GridExercises.dart';

class HomePage extends StatefulWidget {
  @override
  _ButtonMenuState createState() => new _ButtonMenuState();
}

class _ButtonMenuState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const <Widget>[
                Icon(
                  Icons.accessibility_new,
                  color: Colors.redAccent,
                  size: 40.0,
                  semanticLabel: 'Text to announce in accessibility modes',
                ),
                Icon(
                  Icons.rowing,
                  color: Colors.green,
                  size: 40.0,
                ),
                Icon(
                  Icons.directions_run,
                  color: Colors.white,
                  size: 40.0,
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 80.0),
              child: new Text(
                "Welcome on sport corrector \n\n The first application for correcting your motion",
                textAlign: TextAlign.center,
                style: new TextStyle(
                  color: Colors.white,
                  fontFamily: "Anton-Regular",
                  fontSize: 30.0,
                ),
              ),
            ),
            new Container(
                margin: EdgeInsets.only(top: 50.0),
                padding: EdgeInsets.only(bottom: 15.0),
                width: 200,
                height: 65,
                child: new RaisedButton(
                  elevation: 0,
                  child: new Text(
                    "START",
                    style:
                    new TextStyle(fontSize: 20.0, color: AppColors.white),
                  ),
                  color: AppColors.foreground,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => new GridExercises()),
                    );
                  },
                  shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                )
            ),
          ],
        ),
      ),
    );
  }
}
