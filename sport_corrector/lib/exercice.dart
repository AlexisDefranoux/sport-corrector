import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sensors/sensors.dart';
import 'package:sklite/SVM/SVM.dart';
import 'package:sklite/utils/io.dart';
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
  List<Movement> movements = new List<Movement>();
  Timer timer;
  SVC svc;
  int result = 0;
  String dropdownValue = '0-bon';
  int mlClass = 0;
  List<String> items = <String>['0-bon', '1-low speed', '2-high speed', '3-low amplitude', '4-high amplitude', '5-on the side', '6-immobile', '7-horizontal', '8-shake', '9-garbage'];

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

  void predict(){
    loadModel("assets/MachineLearning/data.json").then((x) {
      this.svc = SVC.fromMap(json.decode(x));
      result = this.svc.predict(movements[movements.length - 1].getList());
    });
  }

  @override
  void dispose() {
    for (StreamSubscription<dynamic> sub in _streamSubscriptions) {
      sub.cancel();
    }
    timer?.cancel();
    super.dispose();
  }

  void oneMovement(accelerometer, gyroscope, userAccelerometer) {
    Movement movement = new Movement();
    movements.add(movement);
    timer = Timer.periodic(Duration(milliseconds: 100), (Timer t) {
      movement.addCaptor(new Captor(accelerometer, gyroscope, userAccelerometer), mlClass);
      print(t.tick);
      if(t.tick >= 20){
        timer?.cancel();
      }
    });
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
            child: DropdownButton<String>(
                  value: dropdownValue,
                  icon: Icon(Icons.arrow_downward),
                  iconSize: 24,
                  elevation: 16,
                  style: TextStyle(
                      color: Colors.blue
                  ),
                  underline: Container(
                    height: 2,
                    color: Colors.blue,
                  ),
                  onChanged: (String newValue) {
                    setState(() {
                      mlClass = int.parse(newValue.split("-")[0]);
                      dropdownValue = newValue;
                    });
                  },
                  items: items
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
            ),
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
                    oneMovement(accelerometer, gyroscope, userAccelerometer);
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
                  for(Movement movement in movements){
                    print(movement.toString() + "\n");
                  }
                  predict();
                },
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(30.0)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Résultat : ' + items[result]),
            ),
          ],
        ),
      ),
    );
  }
}