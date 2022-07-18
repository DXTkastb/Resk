import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';

import '../statwids/statProvider.dart';

class CircleIndicator extends StatelessWidget {
  final Future future;

  const CircleIndicator(this.future);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return FutureBuilder(
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Consumer<StatProvider>(builder: (ctx2, provider, _) {
            return CircularPercentIndicator(
              animation: true,
              animationDuration: 200,
              animateFromLastPercent: true,
              radius: 13.5,
              lineWidth: 6,
              percent: provider.getPercent(),
              progressColor: Colors.deepOrangeAccent,
              circularStrokeCap: CircularStrokeCap.round,
            );
          });
        }
        return const SizedBox();
      },
      future: future,
    );
  }
}
