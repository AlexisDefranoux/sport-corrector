import 'dart:collection';

import 'package:sport_corrector/model/captor_class.dart';

class Movement {

  List<Captor> captorByTime;

  Movement() {
    captorByTime = new List<Captor>();
  }

  void addCaptor(Captor captor) {
    captorByTime.add(captor);
  }

  List<double> getList(){
    List<double> data = new List<double>();
    captorByTime.forEach((v) {
      v.accelerometer.forEach((s) {
        data.add(double.parse(s));
      });
      v.accelerometerUser.forEach((s) {
        data.add(double.parse(s));
      });
      v.gyroscope.forEach((s) {
        data.add(double.parse(s));
      });
    });
    print(data);
    return data;
  }

  String toString() {
    String data = "";
    captorByTime.forEach((v) {
      if(data == ""){
        data += v.toString();
      }else{
        data += "," + v.toString();
      }
    });
    return data;
  }
}