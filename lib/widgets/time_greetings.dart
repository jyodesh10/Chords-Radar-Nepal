import 'package:flutter/material.dart';

import '../constants/constants.dart';

class TimeGreeting extends StatefulWidget {
  const TimeGreeting({super.key, required this.username});
  final String username;

  @override
  State<TimeGreeting> createState() => _TimeGreetingState();
}

class _TimeGreetingState extends State<TimeGreeting> {
  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final hour = now.hour;

    String greeting = "";

    if (hour < 12) {
      setState(() {
        greeting = "Good Morning";
      });
    } else if (hour < 17) {
      setState(() {
        greeting = "Good Afternoon";
      });
    } else if (hour < 21) {
      setState(() {
        greeting = "Good Evening";
      });
    } else {
      setState(() {
        greeting = "Good Night";
      });
    }

    return Text(
      "$greeting,\n${widget.username}",
      style: titleStyle,
    );
  }
}