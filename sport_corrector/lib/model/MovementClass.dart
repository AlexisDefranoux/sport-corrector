import 'package:sport_corrector/model/CaptorClass.dart';

class Movement {

  List<Captor> captorByTime;
  int mlClass;

  Movement() {
    captorByTime = new List<Captor>();
  }

  void addCaptor(Captor captor, int mlClass) {
    captorByTime.add(captor);
    this.mlClass = mlClass;
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
    return data;
  }

  String toString() {
    String data = "";
    captorByTime.forEach((v) {
        data +=v.toString()+", ";
    });
    data+=mlClass.toString();
    return data;
  }
}