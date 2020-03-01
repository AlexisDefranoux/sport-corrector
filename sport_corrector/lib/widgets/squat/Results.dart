import 'package:flutter/material.dart';
import 'package:sport_corrector/utils/ResultConversion.dart';


class Results extends StatefulWidget {
  @override
  _ResultsState createState() {
    return new _ResultsState();
  }
}

class _ResultsState extends State<Results> {

  final results = [1, 2, 3, 6];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _myListView(context)
    );
  }

  Widget _myListView(BuildContext context) {
    return ListView(
      children: getList()
    );
  }

  List<Widget> getList(){
    List<Widget> items = new List<Widget>();
    var my;
    int nbr = 1;
    results.forEach((v) {
      my = ResultConversion.convert(v);
      items.add(ListTile(
          leading: Icon(
            my[0],
            size: 40.0,
          ),
          title: Text('Squat ' + nbr.toString() + ' : ' + my[1]),
        )
      );
      nbr++;
    });
    return items;
  }
}