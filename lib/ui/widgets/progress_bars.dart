import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:test_app/ui/widgets/progress_bar.dart';

class ProgressBars extends StatelessWidget {
  List<double> percentWatched;
  ProgressBars({Key? key, required this.percentWatched}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 20,
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
      child: ListView.builder(
          shrinkWrap: true,
          itemCount: percentWatched.length,
          itemExtent: ((MediaQuery.of(context).size.width - 16) /
              percentWatched.length),
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return ProgressBar(percentWatched: percentWatched[index]);
          }),
    );
  }
}
