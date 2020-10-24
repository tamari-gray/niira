import 'package:flutter/material.dart';
import 'package:niira/models/view_models/create_game2.dart';
import 'package:provider/provider.dart';

class SonarIntervalsSlider extends StatefulWidget {
  @override
  _SonarIntervalsSliderState createState() => _SonarIntervalsSliderState();
}

class _SonarIntervalsSliderState extends State<SonarIntervalsSlider> {
  double _sonarIntervals;

  @override
  void initState() {
    _setInitialSonarIntervals();
    super.initState();
  }

  // get initial sonar interval value from vm
  void _setInitialSonarIntervals() {
    final vm = Provider.of<CreateGameViewModel2>(context, listen: false);
    setState(() {
      _sonarIntervals = vm.sonarIntervals;
    });
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
            context.read<CreateGameViewModel2>().sonarIntervals = value;
          },
        ),
      ]),
    );
  }
}
