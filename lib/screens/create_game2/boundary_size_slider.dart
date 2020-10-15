import 'package:flutter/material.dart';
import 'package:niira/services/game_service.dart';
import 'package:provider/provider.dart';

class BoundarySizeSlider extends StatefulWidget {
  @override
  _BoundarySizeSliderState createState() => _BoundarySizeSliderState();
}

class _BoundarySizeSliderState extends State<BoundarySizeSlider> {
  double _boundarySize;

  @override
  void initState() {
    _boundarySize = 50;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text(
          'Set boundary size: ',
          style: TextStyle(fontSize: 18),
        ),
        Slider(
            value: _boundarySize,
            min: 50,
            max: 500,
            divisions: 9,
            label: '${_boundarySize.round().toString()} metres  ',
            activeColor: Theme.of(context).accentColor,
            onChanged: (double value) {
              setState(() {
                _boundarySize = value;
              });
              context.read<GameService>().updateBoundarySize(value);
            }),
      ]),
    );
  }
}
