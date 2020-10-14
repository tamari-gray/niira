import 'package:flutter/material.dart';
import 'package:niira/loading.dart';
import 'package:niira/models/location.dart';
import 'package:niira/navigation/navigation.dart';
import 'package:niira/screens/create_game2/create_game_map.dart';
import 'package:niira/screens/waiting_screen/waiting_for_game_to_start.dart';
import 'package:niira/services/game_service.dart';
import 'package:provider/provider.dart';

class CreateGameScreen2 extends StatefulWidget {
  static const routeName = '/create_game2';

  @override
  _CreateGameScreen2State createState() => _CreateGameScreen2State();
}

class _CreateGameScreen2State extends State<CreateGameScreen2> {
  double _boundarySize;
  Location _boundaryLocation;
  double _sonarIntervals;
  bool _loadingMap;

  @override
  void initState() {
    _boundarySize = 100;
    _sonarIntervals = 120;
    _loadingMap = true;
    super.initState();
  }

  void _loadedMap() {
    setState(() {
      _loadingMap = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final navigation = context.watch<Navigation>();
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: false,
        title: const Text('Create Game 2/2',
            style: TextStyle(color: Colors.white)),
        actions: [
          FlatButton.icon(
              onPressed: () {
                // navigate back to lobby
                navigation.showConfirmationDialog(
                  onConfirmed: navigation.popUntilLobby,
                );
              },
              icon: Icon(
                Icons.clear,
                color: Colors.white,
              ),
              label: Text('Cancel', style: TextStyle(color: Colors.white)))
        ],
      ),
      floatingActionButton: _loadingMap
          ? Container()
          : FloatingActionButton.extended(
              key: Key('create_game_screen_2_submit_button'),
              onPressed: () {
                // put all data in global state
                final vm = context.read<GameService>().createGameViewModel2;
                vm.boundarySize = _boundarySize;
                vm.location = _boundaryLocation;
                vm.sonarIntervals = _sonarIntervals.toInt();

                /// prompt user to confirm navigation
                navigation.showConfirmationDialog(
                  message: 'Are you ready?',
                  confirmText: 'Yes',
                  cancelText: 'No',
                  onConfirmed: () => navigation
                      .navigateTo(WaitingForGameToStartScreen.routeName),
                );
              },
              label: Text('Next'),
              icon: Icon(Icons.arrow_forward_ios),
            ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 250,
              child: CreateGameMap(
                boundarySize: _boundarySize,
                loadedMap: _loadedMap,
              ),
            ),
            _loadingMap
                ? Expanded(
                    child: Loading(
                      message: 'loading map...',
                    ),
                  )
                : Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 50, 0, 50),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                                  Text(
                                    'Set boundary size: ',
                                    style: TextStyle(fontSize: 18),
                                  ),
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
                                  Text(
                                    'Set sonar intervals: ',
                                    style: TextStyle(fontSize: 18),
                                  ),
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
