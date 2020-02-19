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

import 'package:sport_corrector/data/AppColors.dart';

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
  String dropdownValue = '0-bon';
  int mlClass = 0;
  List<String> items = <String>['0-bon', '1-low speed', '2-high speed', '3-low amplitude', '4-high amplitude', '5-on the side', '6-immobile', '7-horizontal', '8-shake', '9-garbage'];
  AnimationController controller;

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
      if(t.tick >= 20){
        timer?.cancel();
        predict();
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
                    color: Colors.black87,
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
                                  if (controller.isAnimating)
                                    controller.stop();
                                  else {
                                    oneMovement();
                                    print("lancer");
                                    controller.reverse(
                                        from: controller.value == 0.0
                                            ? 1.0
                                            : controller.value);
                                  }
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