import 'package:flutter/material.dart';
import 'package:niira/loading.dart';
import 'package:niira/navigation/navigation.dart';
import 'package:provider/provider.dart';

class NewGameScreen1 extends StatefulWidget {
  const NewGameScreen1({Key key}) : super(key: key);

  @override
  _NewGameScreen1State createState() => _NewGameScreen1State();
}

class _NewGameScreen1State extends State<NewGameScreen1> {
  final _formKey = GlobalKey<FormState>();
  bool _waitingForNameResult;
  bool _autoValidateForm;
  String _email;
  String _password;

  @override
  void initState() {
    super.initState();
    _waitingForNameResult = false;
    _autoValidateForm = false;
    _clearForm();
  }

  void _clearForm() {
    setState(() {
      _email = '';
      _password = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Create Your Game',
          style: TextStyle(color: Colors.white),
        ),
        // backgroundColor: Color.fromRGBO(247, 152, 0, 1),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.read<Navigation>().navigateTo('/new_game2'),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5))),
        label: Text('Next'),
        icon: Icon(Icons.arrow_forward_ios),
      ),
      body: _waitingForNameResult
          ? Loading()
          : SingleChildScrollView(
              child: Container(
                child: Center(
                  child: Form(
                    autovalidate: _autoValidateForm,
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        NameField((val) => setState(() => _email = val)),
                        PasswordField((val) => setState(() => _password = val)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}

class NameField extends StatelessWidget {
  final void Function(String) _onChanged;
  const NameField(
    this._onChanged, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 20, 30, 0),
      child: TextFormField(
        key: Key('name_field'),
        decoration: InputDecoration(
          labelText: 'Name',
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black, width: 2.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black, width: 2.0),
          ),
        ),
        validator: (value) {
          final pattern =
              r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
          final regex = RegExp(pattern);
          if (value.isEmpty) {
            return 'Please enter name';
          }
          if (!regex.hasMatch(value)) {
            return 'Please enter valid name';
          } else {
            return null;
          }
        },
        onChanged: _onChanged,
      ),
    );
  }
}

class PasswordField extends StatelessWidget {
  final void Function(String) _onChanged;
  const PasswordField(this._onChanged, {Key key}) : super(key: key);

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
        onChanged: _onChanged,
      ),
    );
  }
}
