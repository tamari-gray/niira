import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  final String message;
  Loading({Key key, this.message = 'loading...'}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SpinKitPulse(
            key: Key('loading_indicator'),
            color: Theme.of(context).primaryColor,
            size: 100.0,
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(25, 50, 25, 0),
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: Text(
                '$message',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
