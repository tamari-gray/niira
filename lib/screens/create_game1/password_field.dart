import 'package:flutter/material.dart';
import 'package:niira/models/view_models/create_game.dart';
import 'package:niira/utilities/validators.dart' as validators;
import 'package:provider/provider.dart';

class PasswordField extends StatefulWidget {
  @override
  _PasswordFieldState createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _show = false;
  var _icon = Icon(Icons.visibility_off);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 20, 30, 100),
      child: TextFormField(
        key: Key('new_game1_password_field'),
        obscureText: !_show,
        decoration: InputDecoration(
            labelText: 'Password',
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black, width: 2.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black, width: 2.0),
            ),
            suffixIcon: IconButton(
              icon: _icon,
              onPressed: () => setState(() {
                _show = !_show;
                if (_show) {
                  _icon = Icon(Icons.visibility);
                } else {
                  _icon = Icon(Icons.visibility_off);
                }
              }),
            )),
        validator: validators.gamePassword,
        onChanged: (val) => context.read<CreateGameViewModel>().password = val,
      ),
    );
  }
}
