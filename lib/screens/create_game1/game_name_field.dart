import 'package:flutter/material.dart';
import 'package:niira/models/view_models/create_game.dart';
import 'package:niira/utilities/validators.dart' as validators;
import 'package:provider/provider.dart';

class GameNameField extends StatelessWidget {
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
        validator: validators.gameName,
        onChanged: (val) => context.read<CreateGameViewModel>().name = val,
      ),
    );
  }
}
