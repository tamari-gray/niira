import 'package:flutter/material.dart';
import 'package:niira/services/game_service.dart';
import 'package:niira/utilities/validators.dart' as validators;
import 'package:provider/provider.dart';

class PasswordField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 20, 30, 100),
      child: TextFormField(
        key: Key('new_game1_password_field'),
        obscureText: true,
        decoration: InputDecoration(
            labelText: 'Password',
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black, width: 2.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black, width: 2.0),
            ),
            suffixIcon: Icon(Icons.visibility)),
        validator: validators.oneToFifteenChars,
        onChanged: (val) =>
            context.read<GameService>().newGameViewModel1.password = val,
      ),
    );
  }
}
