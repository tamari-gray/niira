import 'package:flutter/material.dart';
import 'package:niira/models/game.dart';
import 'package:niira/navigation/navigation.dart';
import 'package:niira/services/auth/auth_service.dart';
import 'package:niira/services/database/database_service.dart';
import 'package:provider/provider.dart';

import '../loading.dart';

class InputPasswordScreen extends StatelessWidget {
  static const routeName = '/input_pasword';
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final _gameId = ModalRoute.of(context).settings.arguments as String;
    return StreamBuilder<Game>(
        stream: context.watch<DatabaseService>().streamOfJoinedGame(_gameId),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            context.read<Navigation>().displayError(snapshot.error);
          }
          if (!snapshot.hasData) {
            return Loading(message: 'getting game data..');
          }
          final _game = snapshot.data;
          return Scaffold(
            key: Key('inputPasswordScreen'),
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: Text('Joining ${_game.name}'),
              actions: [
                FlatButton.icon(
                    onPressed: () {
                      context.read<Navigation>().popUntilLobby();
                    },
                    icon: Icon(
                      Icons.clear,
                      color: Colors.white,
                    ),
                    label:
                        Text('Cancel', style: TextStyle(color: Colors.white)))
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

              /// navigation will be handled by CheckIfJoinedGame
              /// after we update GameService.currentGameId
              onPressed: () async {
                // check if password is correct
                if (_formKey.currentState.validate()) {
                  // get player details
                  final userId =
                      await context.read<AuthService>().currentUserId;

                  // add player to game in database
                  await context
                      .read<DatabaseService>()
                      .joinGame(_gameId, userId);

                  // remove current route stack
                  await context.read<Navigation>().popUntilLobby();
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
                          borderSide:
                              BorderSide(color: Colors.black, width: 2.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black, width: 2.0),
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
        });
  }
}
