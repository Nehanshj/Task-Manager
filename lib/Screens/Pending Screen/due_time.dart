import 'package:flutter/material.dart';

class DueTime extends StatelessWidget {
  DueTime(this.time);
  final Duration time;

  String timeString = "Due for ";

  @override
  Widget build(BuildContext context) {
    //Checking for Days/Hours/Minutes
    if (time.inDays > 0)
      timeString += "${time.inDays} Days";
    else if (time.inHours > 0)
      timeString += "${time.inHours} Hours";
    else
      timeString += "${time.inMinutes} Minutes";

    return Text(
      timeString,
      style: TextStyle(color: Colors.red),
    );
  }
}
