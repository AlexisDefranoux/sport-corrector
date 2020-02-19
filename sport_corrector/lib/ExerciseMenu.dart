import 'package:flutter/material.dart';
import 'package:sport_corrector/widgets/squat/Training.dart';
import 'package:sport_corrector/data/AppColors.dart';
import 'package:sport_corrector/widgets/squat/Exercise.dart';
import 'package:sport_corrector/widgets/squat/dev.dart';

import 'widgets/squat/Results.dart';

class ExerciseMenu extends StatefulWidget {
  @override
  _ExerciseMenuState createState() => _ExerciseMenuState();
}

class _ExerciseMenuState extends State<ExerciseMenu> with TickerProviderStateMixin{
  TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.foreground,
        title: Text("Sport Corrector"),
        bottom: TabBar(
          controller: _tabController,
          tabs: [Tab(text: "Training"), Tab(text: "Exercice"), Tab(text: "Results",), Tab(text: "Dev")],
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
      Training(),
      Exercise(),
      Results(),
      Dev()
    ];
  }
}