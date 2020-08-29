import 'package:flutter/material.dart';
import 'package:niira/models/game.dart';
import 'package:niira/models/player.dart';
import 'package:niira/screens/waiting_for_game_to_start.dart';
import 'package:niira/services/auth/auth_service.dart';
import 'package:niira/services/database/database_service.dart';
import 'package:provider/provider.dart';

class InputPasswordScreen extends StatefulWidget {
  final Game game;
  InputPasswordScreen({@required this.game});
  @override
  _InputPasswordScreenState createState() => _InputPasswordScreenState();
}

class _InputPasswordScreenState extends State<InputPasswordScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: Key('inputPasswordScreen'),
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text('Password'),
      ),
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
          if (_formKey.currentState.validate()) {
            // get player details
            final userId = await context.read<AuthService>().currentUserId;
            final username =
                await context.read<DatabaseService>().getUserName(userId);

            // add user as player to game
            final player = Player(
              id: userId,
              username: username,
              isTagger: false,
              hasBeenTagged: false,
              hasItem: false,
              isAdmin: false,
            );
            await context
                .read<DatabaseService>()
                .joinGame(widget.game.id, player);

            // navigate to waiting screen
            await Navigator.push<dynamic>(
              context,
              MaterialPageRoute<dynamic>(
                builder: (context) => WaitingForGameToStartScreen(),
              ),
            );
          }
        },
      ),
      body: Container(
        child: Center(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(50, 0, 50, 0),
              child: TextFormField(
                key: Key('input_password_screen_text_feild'),
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Input password',
                  prefixIcon: Icon(Icons.visibility),
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter password';
                  } else if (value != widget.game.password) {
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
