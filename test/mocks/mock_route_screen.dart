import 'package:flutter/material.dart';

class MockRoute extends StatelessWidget {
  final String navigateTo;
  const MockRoute({Key key, @required this.navigateTo}) : super(key: key);
  static const routeName = '/mock_route';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          child: RaisedButton(
        child: Text('navigate'),
        onPressed: () =>
            Navigator.pushNamed(context, navigateTo, arguments: 'test_game_id'),
      )),
    );
  }
}
