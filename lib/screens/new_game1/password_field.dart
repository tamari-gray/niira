import 'package:flutter/material.dart';
import 'package:niira/models/view_models/new_game1.dart';
import 'package:niira/utilities/validators.dart' as validators;

class PasswordField extends StatefulWidget {
  const PasswordField({Key key}) : super(key: key);

  @override
  _PasswordFieldState createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  NewGameViewModel1 _vm;

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
        onChanged: (val) => setState(() => _vm?.password = val),
      ),
    );
  }
}
