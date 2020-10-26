import 'package:flutter/material.dart';
import 'package:niira/models/view_models/create_game.dart';
import 'package:provider/provider.dart';

class BoundarySizeSlider extends StatefulWidget {
  @override
  _BoundarySizeSliderState createState() => _BoundarySizeSliderState();
}

class _BoundarySizeSliderState extends State<BoundarySizeSlider> {
  double _boundarySize;

  @override
  void initState() {
    _setInitialBoundarySize();
    super.initState();
  }

  // get initial boundary size value from vm
  void _setInitialBoundarySize() {
    final vm = Provider.of<CreateGameViewModel>(context, listen: false);
    setState(() {
      _boundarySize = vm.boundarySize;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text(
          'Boundary size: ',
          style: TextStyle(fontSize: 18),
        ),
        Slider(
          value: _boundarySize,
          min: 25,
          max: 250,
          divisions: 9,
          label: '${_boundarySize.round().toString()} metres  ',
          activeColor: Theme.of(context).accentColor,
          onChanged: (double value) => _updateBoundarySize(value),
        ),
      ]),
    );
  }

  void _updateBoundarySize(double size) {
    setState(() {
      _boundarySize = size;
    });
    context.read<CreateGameViewModel>().updateBoundarySize(size);
  }
}
