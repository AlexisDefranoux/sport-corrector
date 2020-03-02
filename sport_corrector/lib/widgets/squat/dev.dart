import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sensors/sensors.dart';
import 'package:sklite/SVM/SVM.dart';
import 'package:sklite/ensemble/forest.dart';
import 'package:sklite/utils/io.dart';
import 'package:sport_corrector/model/CaptorClass.dart';
import 'package:sport_corrector/model/MovementClass.dart';

import 'package:sport_corrector/data/AppColors.dart';

class Dev extends StatefulWidget {
  @override
  _DevState createState() => _DevState();
}

class _DevState extends State<Dev> {
  List<double> _accelerometerValues;
  List<double> _userAccelerometerValues;
  List<double> _gyroscopeValues;
  List<StreamSubscription<dynamic>> _streamSubscriptions =
      <StreamSubscription<dynamic>>[];
  List<Movement> movements = new List<Movement>();
  Timer timer;
  SVC svc;
  RandomForestClassifier rfc;
  int resultRfc = 0;
  int resultSvc = 0;
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
    loadModel("assets/MachineLearning/data_rfc.json").then((x) {
      this.rfc = RandomForestClassifier.fromMap(json.decode(x));
      resultRfc = this.rfc.predict(movements[movements.length - 1].getList());
      print("RFC : " + items[resultRfc]);
    });
    loadModel("assets/MachineLearning/data_svc.json").then((x) {
      this.svc = SVC.fromMap(json.decode(x));
      resultSvc = this.svc.predict(movements[movements.length - 1].getList());
      print("SVC : " + items[resultSvc]);
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

  void oneMovement() {
    Movement movement = new Movement();
    movements.add(movement);
    timer = Timer.periodic(Duration(milliseconds: 100), (Timer t) {
      movement.addCaptor(new Captor(
          _accelerometerValues?.map((double v) => v.toStringAsFixed(1))?.toList(),
          _gyroscopeValues?.map((double v) => v.toStringAsFixed(1))?.toList(),
          _userAccelerometerValues?.map((double v) => v.toStringAsFixed(1))?.toList()
          ), mlClass);
      print(t.tick);
      if(t.tick >= 22){
        timer?.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
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
                        color: AppColors.white),
                  ),
                  color: AppColors.foreground,
                  onPressed: () {
                    print("lancer");
                    oneMovement();
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
                    color: AppColors.white,
                  ),
                ),
                color: AppColors.foreground,
                onPressed: () {
                  print("afficher");
                  String result = "";
                  for(Movement movement in movements){
                    result += movement.toString() + "\n";
                  }
                  print(result);
                  predict();
                },
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(30.0)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Résultat SVC : ' + items[resultSvc]),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Résultat RFC : ' + items[resultRfc]),
            ),
          ],
        ),
      ),
    );
  }
}