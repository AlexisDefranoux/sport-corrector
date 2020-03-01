import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sensors/sensors.dart';
import 'package:sklite/SVM/SVM.dart';
import 'package:sklite/ensemble/forest.dart';
import 'package:sklite/utils/io.dart';
import 'package:sport_corrector/model/CaptorClass.dart';
import 'package:sport_corrector/model/MovementClass.dart';
import 'package:sport_corrector/utils/CustomTimerPainter.dart';

class Exercise extends StatefulWidget {
  @override
  _ExerciseState createState() => _ExerciseState();
}

class _ExerciseState extends State<Exercise>
    with TickerProviderStateMixin {
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
  int dropdownValue = 3;
  int mlClass = 0;
  List<String> items = <String>['0-bon', '1-low speed', '2-high speed', '3-low amplitude', '4-high amplitude', '5-on the side', '6-immobile', '7-horizontal', '8-shake', '9-garbage'];
  AnimationController controller;
  List<int> savedRfc = <int>[];
  List<int> savedSvc = <int>[];
  bool pause = false;

  @override
  void initState() {
    super.initState();

    //Controller
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );

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
      savedRfc.add(resultRfc);
    });
    loadModel("assets/MachineLearning/data_svc.json").then((x) {
      this.svc = SVC.fromMap(json.decode(x));
      resultSvc = this.svc.predict(movements[movements.length - 1].getList());
      print("SVC : " + items[resultSvc]);
      savedSvc.add(resultSvc);
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

  void allMovement() {
    savedRfc = [];
    savedSvc = [];

    int nbTickStep = 21;

    controller.reverse(
        from: controller.value == 0.0
            ? 1.0
            : controller.value);

    Movement movement = new Movement();
    timer = Timer.periodic(Duration(milliseconds: 100), (Timer t) {
      if (!pause) {
        movement.addCaptor(new Captor(
            _accelerometerValues?.map((double v) => v.toStringAsFixed(1))
                ?.toList(),
            _gyroscopeValues?.map((double v) => v.toStringAsFixed(1))
                ?.toList(),
            _userAccelerometerValues?.map((double v) => v.toStringAsFixed(1))
                ?.toList()
        ), mlClass);
      }
      print(t.tick);
      if (t.tick % nbTickStep == 0) {
        if (!pause) {
          movements.add(movement);
          predict();
          movement = new Movement();
        }
        controller.reverse(
            from: controller.value == 0.0
                ? 1.0
                : controller.value);
        pause = !pause;
      }
      if (t.tick >= nbTickStep * (2*dropdownValue - 1)) {
        timer?.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
          animation: controller,
          builder: (context, child) {
            return Stack(
              children: <Widget>[
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    color: pause ? Colors.yellow : Colors.black87,
                    height:
                    controller.value * MediaQuery.of(context).size.height,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: Align(
                          alignment: FractionalOffset.center,
                          child: AspectRatio(
                            aspectRatio: 1.0,
                            child: Stack(
                              children: <Widget>[
                                Positioned.fill(
                                  child: CustomPaint(
                                      painter: CustomTimerPainter(
                                        animation: controller,
                                        backgroundColor: Colors.white,
                                        color: Theme.of(context).indicatorColor,
                                      )),
                                ),
                                Align(
                                  alignment: FractionalOffset.center,
                                  child: Column(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text('Résultat SVC : ' + items[resultSvc]),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text('Résultat RFC : ' + items[resultRfc]),
                                      ),
                                      DropdownButton<int>(
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
                                        onChanged: (int newValue) {
                                          setState(() {
                                            dropdownValue = newValue;
                                          });
                                        },
                                        items: [1,2,3,4,5]
                                            .map<DropdownMenuItem<int>>((int value) {
                                          return DropdownMenuItem<int>(
                                            value: value,
                                            child: Text(value.toString()),
                                          );
                                        }).toList(),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      AnimatedBuilder(
                          animation: controller,
                          builder: (context, child) {
                            return FloatingActionButton.extended(
                                onPressed: () {
                                  allMovement();
                                },
                                icon: Icon(controller.isAnimating
                                    ? Icons.pause
                                    : Icons.play_arrow),
                                label: Text(
                                    controller.isAnimating ? "Pause" : "Play"));
                          }),
                    ],
                  ),
                ),
              ],
            );
          }),
    );
  }
}