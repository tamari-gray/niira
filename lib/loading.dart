import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  const Loading({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: SpinKitPulse(
          key: Key('loading_indicator'),
          color: Theme.of(context).primaryColor,
          size: 100.0,
        ),
      ),
    );
  }
}
