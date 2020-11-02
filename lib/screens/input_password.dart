import 'package:flutter/material.dart';
import 'package:niira/models/game.dart';
import 'package:niira/navigation/navigation.dart';
import 'package:niira/screens/waiting_screen/waiting_for_game_to_start.dart';
import 'package:niira/services/auth/auth_service.dart';
import 'package:niira/services/database/database_service.dart';
import 'package:niira/services/game_service.dart';
import 'package:provider/provider.dart';

class InputPasswordScreen extends StatefulWidget {
  static const routeName = '/input_pasword';

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
        automaticallyImplyLeading: false,
        title: Text('Joining ${_game.name}'),
        actions: [
          FlatButton.icon(
              onPressed: () {
                context.read<Navigation>().pop();
                context.read<GameService>().leaveCurrentGame();
              },
              icon: Icon(
                Icons.clear,
                color: Colors.white,
              ),
              label: Text('Cancel', style: TextStyle(color: Colors.white)))
        ],
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
            await context
                .read<DatabaseService>()
                .joinGame(_game.id, userId, false);

            await context
                .read<Navigation>()
                .navigateTo(WaitingForGameToStartScreen.routeName);
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
                  suffixIcon: Icon(Icons.visibility),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 2.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 2.0),
                  ),
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
