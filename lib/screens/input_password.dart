import 'package:flutter/material.dart';
import 'package:niira/models/game.dart';
import 'package:niira/navigation/navigation.dart';
import 'package:niira/navigation/route_names.dart';
import 'package:niira/screens/waiting_for_game_to_start.dart';
import 'package:niira/services/auth/auth_service.dart';
import 'package:niira/services/database/database_service.dart';
import 'package:niira/services/game_service.dart';
import 'package:provider/provider.dart';

class InputPasswordScreen extends StatefulWidget {
  @override
  _InputPasswordScreenState createState() => _InputPasswordScreenState();
}

class _InputPasswordScreenState extends State<InputPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  Game _game;

  @override
  void initState() {
    _game = context.read<GameService>().currentGame;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: Key('inputPasswordScreen'),
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text('Password'),
      ),
      // form submit button
      floatingActionButton: FloatingActionButton.extended(
        key: Key('input_password_screen_submit_btn'),
        label: Text(
          'Next',
          style: TextStyle(color: Colors.white),
        ),
        icon: Icon(
          Icons.navigate_next,
          color: Colors.white,
        ),
        onPressed: () async {
          // check if password is correct
          if (_formKey.currentState.validate()) {
            // get player details
            final userId = await context.read<AuthService>().currentUserId;

            // add player to game in database
            await context.read<DatabaseService>().joinGame(_game.id, userId);

            await context
                .read<Navigation>()
                .navigateTo(waiting_for_game_to_start);
          }
        },
      ),
      body: Container(
        child: Center(
          // form to inpt game password
          child: Form(
            key: _formKey,
            child: Padding(
              padding: EdgeInsets.fromLTRB(50, 0, 50, 0),
              child: TextFormField(
                key: Key('input_password_screen_text_feild'),
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Input password',
                  prefixIcon: Icon(Icons.visibility),
                ),
                // check if password is correct
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter password';
                  } else if (value != _game.password) {
                    return 'Password is incorrect';
                  }
                  return null;
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
