class Captor {
  List<String> accelerometer;
  List<String> accelerometerUser;
  List<String> gyroscope;

  Captor(this.accelerometer, this.accelerometerUser, this.gyroscope);

  String toString(){
    return this.accelerometer[0] + ", " + this.accelerometer[1] + ", " + this.accelerometer[2] + ", " + this.accelerometerUser[0] + ", " + this.accelerometerUser[1] + ", " + this.accelerometerUser[2] + ", " + this.gyroscope[0] + ", " + this.gyroscope[1] + ", " + this.gyroscope[2];
  }
}