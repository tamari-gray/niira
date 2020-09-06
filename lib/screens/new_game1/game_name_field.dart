import 'package:flutter/material.dart';
import 'package:niira/models/view_models/new_game1.dart';
import 'package:niira/utilities/validators.dart';

class GameNameField extends StatefulWidget {
  final NewGameViewModel1 _vm;
  const GameNameField(this._vm, {Key key}) : super(key: key);

  @override
  _GameNameFieldState createState() => _GameNameFieldState();
}

class _GameNameFieldState extends State<GameNameField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 20, 30, 0),
      child: TextFormField(
        key: Key('new_game1_name_field'),
        decoration: InputDecoration(
          labelText: 'Name',
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black, width: 2.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black, width: 2.0),
          ),
        ),
        validator: oneToFifteenChars,
        onChanged: (val) => setState(() => widget._vm.gameName = val),
      ),
    );
  }
}
