import 'package:flutter/material.dart';
import 'package:sport_corrector/SensorsExample.dart';
import 'package:sport_corrector/exercice.dart';

import 'MachineLearning.dart';

class ExerciseMenu extends StatefulWidget {
  @override
  _ExerciseMenuState createState() => _ExerciseMenuState();
}

class _ExerciseMenuState extends State<ExerciseMenu> with TickerProviderStateMixin{
  TabController _tabController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Sport Corrector"),
          bottom: TabBar(
            controller: _tabController,
            tabs: [Tab(text: "Capteurs"), Tab(text: "Exercice"), Tab(text: "ML",)],
          )
      ),
      body: TabBarView(
        controller: _tabController,
        children: _just(),
        physics: NeverScrollableScrollPhysics(),
      ),
    );
  }

  List<Widget> _just() {
    return [
      SensorsExample(),
      Exercise(),
      HomePage()
    ];
  }
}