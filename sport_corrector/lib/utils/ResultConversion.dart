import 'package:flutter/material.dart';

class ResultConversion {

  static convert(int result) {
    switch(result){
      case 0 :
        return [Icons.check, 'Perfect motion !'];
        break;
      case 1 :
        return [Icons.warning, 'Motion too slow'];
        break;
      case 2 :
        return [Icons.warning, 'Motion too fast'];
        break;
      case 3 :
        return [Icons.warning, 'Low amplitude'];
        break;
      case 4 :
        return [Icons.warning, 'High amplitude'];
        break;
      default :
        return [Icons.flag, 'Unknown'];
        break;
    }
  }
}