import 'package:flutter/material.dart';

class StoryProgressIndicator extends StatelessWidget {
  const StoryProgressIndicator({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blueGrey[100],
      child: const Center(
        child: SizedBox(
          height: 60,
          width: 60,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: Colors.blueGrey,
          ),
        ),
      ),
    );
  }
}
