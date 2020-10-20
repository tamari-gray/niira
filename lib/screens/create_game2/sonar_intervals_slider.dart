import 'package:flutter/material.dart';
import 'package:niira/services/game_service.dart';
import 'package:provider/provider.dart';

class SonarIntervalsSlider extends StatefulWidget {
  @override
  _SonarIntervalsSliderState createState() => _SonarIntervalsSliderState();
}

class _SonarIntervalsSliderState extends State<SonarIntervalsSlider> {
  double _sonarIntervals;

  @override
  void initState() {
    _sonarIntervals = 120;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text(
          'Sonar intervals: ',
          style: TextStyle(fontSize: 18),
        ),
        Slider(
          value: _sonarIntervals,
          min: 30,
          max: 300,
          divisions: 9,
          label: '${(_sonarIntervals).round().toString()} seconds',
          activeColor: Theme.of(context).accentColor,
          onChanged: (double value) {
            setState(() {
              _sonarIntervals = value;
            });
            context.read<GameService>().createGameViewModel2.sonarIntervals =
                value.round();
          },
        ),
      ]),
    );
  }
}
