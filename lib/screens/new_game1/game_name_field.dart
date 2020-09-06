import 'package:flutter/material.dart';
import 'package:niira/models/view_models/new_game1.dart';
import 'package:niira/services/game_service.dart';
import 'package:niira/utilities/validators.dart' as validators;
import 'package:provider/provider.dart';

class GameNameField extends StatefulWidget {
  const GameNameField({Key key}) : super(key: key);

  @override
  _GameNameFieldState createState() => _GameNameFieldState();
}

class _GameNameFieldState extends State<GameNameField> {
  NewGameViewModel1 _vm;

  @override
  void initState() {
    super.initState();
    _vm = context.read<GameService>().newGameViewModel1;
  }

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
        validator: validators.oneToFifteenChars,
        onChanged: (val) => setState(() => _vm?.name = val),
      ),
    );
  }
}
