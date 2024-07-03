import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';

import '../../constants/constants.dart';

class ChordChartView extends StatefulWidget {
  const ChordChartView({super.key});

  @override
  State<ChordChartView> createState() => _ChordChartViewState();
}

class _ChordChartViewState extends State<ChordChartView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.charcoal,
      appBar: AppBar(
        backgroundColor: AppColors.charcoal,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            FluentIcons.arrow_circle_left_48_regular,
            size: 40,
            color: AppColors.white7,
          ),
        ),
      ),
      body: SafeArea(
        child: InteractiveViewer(
          maxScale: 5,
          child: Center(child: Image.asset("assets/chordchart.jpg", fit: BoxFit.contain,)))
      ),
    );
  }
}