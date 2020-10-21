import 'package:flutter/material.dart';
import 'package:niira/models/view_models/create_game2.dart';
import 'package:provider/provider.dart';

class BoundarySizeSlider extends StatefulWidget {
  @override
  _BoundarySizeSliderState createState() => _BoundarySizeSliderState();
}

class _BoundarySizeSliderState extends State<BoundarySizeSlider> {
  double _boundarySize;

  @override
  void initState() {
    _setDefaultBoundarySize();
    super.initState();
  }

  // sets boundary size in vm if not already set (boundarySize == null)
  void _setDefaultBoundarySize() {
    final vm = Provider.of<CreateGameViewModel2>(context, listen: false);

    vm.boundarySize != null
        ? _boundarySize = vm.boundarySize
        : _boundarySize = vm.defaultBoundarySize;
  }

  void _updateBoundarySize(double size) {
    setState(() {
      _boundarySize = size;
    });
    context.read<CreateGameViewModel2>().updateBoundarySize(size);
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
}
