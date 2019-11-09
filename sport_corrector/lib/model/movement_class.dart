import 'dart:collection';

import 'package:sport_corrector/model/captor_class.dart';

class Movement {

  HashMap<double, Captor> captorByTime;

  Movement() {
    captorByTime = new HashMap<double, Captor>();
  }

  addCaptor(double time, Captor captor) {
    captorByTime [time] = captor;
  }

  printMovement() {
    print(captorByTime);
    captorByTime.forEach((k, v) {
      if(k == 0){
        print(v.toString());
      }else{
        print("," + v.toString());
      }
    });
  }
}