import 'package:flutter/material.dart';
import 'package:sport_corrector/utils/ResultConversion.dart';


class Results extends StatefulWidget {
  final List<int> results;
  final List<int> results2;
  Results(this.results, this.results2);

  @override
  _ResultsState createState() {
    return new _ResultsState(results, results2);
  }
}

class _ResultsState extends State<Results> {

  List<int> results;
  List<int> results2;
  _ResultsState(this.results, this.results2);

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
          title: Text('RFC Squat ' + nbr.toString() + ' : ' + my[1]),
        )
      );
      nbr++;
    });

    nbr = 1;
    results2.forEach((v) {
      my = ResultConversion.convert(v);
      items.add(ListTile(
        leading: Icon(
          my[0],
          size: 40.0,
        ),
        title: Text('SVC Squat ' + nbr.toString() + ' : ' + my[1]),
      )
      );
      nbr++;
    });
    return items;
  }
}