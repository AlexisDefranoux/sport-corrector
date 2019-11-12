import 'dart:collection';

import 'package:sport_corrector/model/captor_class.dart';

class Movement {

  HashMap<int, Captor> captorByTime;

  Movement() {
    captorByTime = new HashMap<int, Captor>();
  }

  addCaptor(int time, Captor captor) {
    captorByTime [time] = captor;
  }

  String toString() {
    String data = "";
    captorByTime.forEach((k, v) {
      if(k == 1){
        data += v.toString();
      }else{
        data += "," + v.toString();
      }
    });
    print(data);
    return data;
  }
}