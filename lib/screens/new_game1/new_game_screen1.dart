import 'package:flutter/material.dart';
import 'package:niira/models/view_models/new_game1.dart';
import 'package:niira/navigation/navigation.dart';
import 'package:niira/screens/new_game1/game_name_field.dart';
import 'package:niira/screens/new_game1/password_field.dart';
import 'package:provider/provider.dart';

class NewGameScreen1 extends StatefulWidget {
  static const routeName = '/new_game1';

  const NewGameScreen1({Key key}) : super(key: key);

  @override
  _NewGameScreen1State createState() => _NewGameScreen1State();
}

class _NewGameScreen1State extends State<NewGameScreen1> {
  final _formKey = GlobalKey<FormState>();

  final _vm = NewGameViewModel1();
  bool _autoValidateForm = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Create Your Game', style: TextStyle(color: Colors.white)),
      ),
      floatingActionButton: FloatingActionButton.extended(
        key: Key('new_game1_submit_button'),
        onPressed: () {
          if (_formKey.currentState.validate()) {
            context.read<Navigation>().navigateTo('/new_game2');
          } else {
            setState(() {
              _autoValidateForm = true;
            });
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
                children: <Widget>[GameNameField(_vm), PasswordField(_vm)],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
