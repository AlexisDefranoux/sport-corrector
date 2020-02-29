import 'package:flutter/material.dart';


class Results extends StatefulWidget {
  @override
  _ResultsState createState() {
    return new _ResultsState();
  }
}

class _ResultsState extends State<Results> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _myListView(context)
    );
  }

  Widget _myListView(BuildContext context) {

    final results = [1, 2, 3, 6];

    return ListView(
      children: <Widget>[
        ListTile(
          leading: Icon(
            Icons.warning,
            size: 40.0,
          ),
          title: Text('Sun'),
        ),
        ListTile(
          leading: Icon(
            Icons.check,
            size: 40.0,
          ),
          title: Text('Moon'),
        ),
        ListTile(
          leading: Icon(
            Icons.warning,
            size: 40.0,
          ),
          title: Text('Star'),
        ),
      ],
    );
  }
}