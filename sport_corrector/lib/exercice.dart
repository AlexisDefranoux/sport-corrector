import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sensors/sensors.dart';
import 'package:sport_corrector/model/captor_class.dart';
import 'package:sport_corrector/model/movement_class.dart';

import 'color.dart';

class Exercise extends StatefulWidget {
  @override
  _ExerciseState createState() => _ExerciseState();
}

class _ExerciseState extends State<Exercise> {
  List<double> _accelerometerValues;
  List<double> _userAccelerometerValues;
  List<double> _gyroscopeValues;
  List<StreamSubscription<dynamic>> _streamSubscriptions =
      <StreamSubscription<dynamic>>[];
  Movement movement = new Movement();

  @override
  void initState() {
    super.initState();

    //Accelerometer events
    _streamSubscriptions
        .add(accelerometerEvents.listen((AccelerometerEvent event) {
      setState(() {
        _accelerometerValues = <double>[event.x, event.y, event.z];
      });
    }));

    //UserAccelerometer events
    _streamSubscriptions
        .add(userAccelerometerEvents.listen((UserAccelerometerEvent event) {
      setState(() {
        _userAccelerometerValues = <double>[event.x, event.y, event.z];
      });
    }));

    //UserAccelerometer events
    _streamSubscriptions.add(gyroscopeEvents.listen((GyroscopeEvent event) {
      setState(() {
        _gyroscopeValues = <double>[event.x, event.y, event.z];
      });
    }));
  }

  @override
  void dispose() {
    for (StreamSubscription<dynamic> sub in _streamSubscriptions) {
      sub.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<String> accelerometer =
    _accelerometerValues?.map((double v) => v.toStringAsFixed(1))?.toList();
    final List<String> gyroscope =
    _gyroscopeValues?.map((double v) => v.toStringAsFixed(1))?.toList();
    final List<String> userAccelerometer = _userAccelerometerValues
        ?.map((double v) => v.toStringAsFixed(1))
        ?.toList();

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Container(
                padding: EdgeInsets.only(bottom: 15.0),
                width: 200,
                height: 65,
                child: new RaisedButton(
                  elevation: 0,
                  child: new Text(
                    "Lancer",
                    style: new TextStyle(
                        fontSize: 20.0,
                        color: Color(AppColors.buttonTextColor)),
                  ),
                  color: Color(AppColors.buttonColor),
                  onPressed: () {
                    print("lancer");
                    movement.addCaptor(0, new Captor(accelerometer, gyroscope, userAccelerometer));
                  },
                  shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(30.0)),
                )),
            new Container(
              padding: EdgeInsets.only(bottom: 15.0),
              width: 200,
              height: 65,
              child: new RaisedButton(
                elevation: 0,
                child: new Text(
                  "Afficher",
                  style: new TextStyle(
                    fontSize: 20.0,
                    color: Color(AppColors.buttonTextColor),
                  ),
                ),
                color: Color(AppColors.buttonColor),
                onPressed: () {
                  print("afficher");
                  movement.printMovement();
                },
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(30.0)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
