import 'package:flutter/material.dart';
import 'package:niira/screens/create_game2/create_game_map.dart';

class CreateGameScreen2 extends StatefulWidget {
  static const routeName = '/create_game2';

  @override
  _CreateGameScreen2State createState() => _CreateGameScreen2State();
}

class _CreateGameScreen2State extends State<CreateGameScreen2> {
  double _boundarySize;
  double _sonarIntervals;

  @override
  void initState() {
    _boundarySize = 100;
    _sonarIntervals = 120;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: false,
        title: const Text('Create Game 2/2',
            style: TextStyle(color: Colors.white)),
      ),
      floatingActionButton: FloatingActionButton.extended(
        key: Key('create_game_screen_2_submit_button'),
        onPressed: () {
          //TODO: navigate to waiting screen + submit data
        },
        label: Text('Next'),
        icon: Icon(Icons.arrow_forward_ios),
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // TODO: make map responsive in #57
            Container(
              height: 250,
              child: CreateGameMap(),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 50),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Move map to reposition boundary',
                      style: TextStyle(fontSize: 18),
                    ),
                    Container(
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Set boundary size: '),
                            Slider(
                              value: _boundarySize,
                              min: 50,
                              max: 500,
                              divisions: 9,
                              label:
                                  '${_boundarySize.round().toString()} metres  ',
                              activeColor: Theme.of(context).accentColor,
                              onChanged: (double value) {
                                setState(() {
                                  _boundarySize = value;
                                });
                              },
                            ),
                          ]),
                    ),
                    Container(
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Set sonar intervals: '),
                            Slider(
                              value: _sonarIntervals,
                              min: 30,
                              max: 300,
                              divisions: 9,
                              label:
                                  '${(_sonarIntervals).round().toString()} seconds',
                              activeColor: Theme.of(context).accentColor,
                              onChanged: (double value) {
                                setState(() {
                                  _sonarIntervals = value;
                                });
                              },
                            ),
                          ]),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
