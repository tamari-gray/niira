import 'package:flutter/material.dart';
import 'package:niira/navigation/navigation.dart';
import 'package:niira/screens/create_game1/game_name_field.dart';
import 'package:niira/screens/create_game1/password_field.dart';
import 'package:niira/screens/create_game2/create_game_screen2.dart';
import 'package:niira/services/game_service.dart';
import 'package:provider/provider.dart';

class CreateGameScreen1 extends StatefulWidget {
  static const routeName = '/create_game1';
  const CreateGameScreen1({Key key}) : super(key: key);
  @override
  _CreateGameScreen1State createState() => _CreateGameScreen1State();
}

class _CreateGameScreen1State extends State<CreateGameScreen1> {
  final _formKey = GlobalKey<FormState>();
  bool _autoValidateForm = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: false,
        title: const Text('Create Game 1/2',
            style: TextStyle(color: Colors.white)),
        actions: [
          FlatButton.icon(
              onPressed: () {
                context.read<Navigation>().pop();
                context.read<GameService>().createGameViewModel1.clear();
              },
              icon: Icon(
                Icons.clear,
                color: Colors.white,
              ),
              label: Text('Cancel', style: TextStyle(color: Colors.white)))
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        key: Key('new_game1_submit_button'),
        onPressed: () {
          if (_formKey.currentState.validate()) {
            context.read<Navigation>().navigateTo(CreateGameScreen2.routeName);
          } else {
            setState(() => _autoValidateForm = true);
          }
        },
        label: Text('Next'),
        icon: Icon(Icons.arrow_forward_ios),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Center(
            child: Form(
              autovalidate: _autoValidateForm,
              key: _formKey,
              child: Column(
                children: <Widget>[GameNameField(), PasswordField()],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
