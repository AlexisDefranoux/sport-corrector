import 'package:flutter/material.dart';

class ResultConversion {

  static convert(int result) {
    switch(result){
      case 0 :
        return [Icons.warning, 'Correct motion'];
        break;
      case 1 :
        return [Icons.check, 'Correct motion'];
        break;
      case 2 :
        return [Icons.check, 'Correct motion'];
        break;
      default :
        return [Icons.flag, 'Unknown'];
        break;
    }
  }
}