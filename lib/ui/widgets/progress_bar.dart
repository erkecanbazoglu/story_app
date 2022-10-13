import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class ProgressBar extends StatelessWidget {
  final double percentWatched;
  const ProgressBar({Key? key, required this.percentWatched}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LinearPercentIndicator(
      lineHeight: 5,
      percent: percentWatched,
      progressColor: Colors.grey[300],
      backgroundColor: Colors.grey[400],
      linearStrokeCap: LinearStrokeCap.roundAll,
    );
  }
}
