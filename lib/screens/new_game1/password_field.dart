import 'package:flutter/material.dart';
import 'package:niira/models/view_models/new_game1.dart';

class PasswordField extends StatefulWidget {
  final NewGameViewModel1 _vm;
  const PasswordField(this._vm, {Key key}) : super(key: key);

  @override
  _PasswordFieldState createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 20, 30, 100),
      child: TextFormField(
        key: Key('password_field'),
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
        validator: (value) {
          if (value.isEmpty) {
            return 'Please enter password';
          }
          return null;
        },
        onChanged: (val) => setState(() => widget._vm.password = val),
      ),
    );
  }
}
