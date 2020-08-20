import 'package:flutter/material.dart';
import 'package:niira/loading.dart';
import 'package:niira/models/user_data.dart';
import 'package:niira/screens/sign_in.dart';
import 'package:niira/services/auth/auth_service.dart';
import 'package:provider/provider.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({Key key}) : super(key: key);

  @override
  _CreateAccountScreenState createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final _formKey = GlobalKey<FormState>();

  bool _waitingForAuthResult;
  bool _autoValidateForm;
  String _userName;
  String _email;
  String _password;

  @override
  void initState() {
    _waitingForAuthResult = false;
    _autoValidateForm = false;
    _clearForm();
    super.initState();
  }

  void _clearForm() {
    _userName = '';
    _password = '';
    _email = '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Create account',
          style: TextStyle(color: Colors.white),
        ),
        // backgroundColor: Color.fromRGBO(247, 152, 0, 1),
      ),
      body: _waitingForAuthResult
          ? Loading()
          : SingleChildScrollView(
              child: Container(
                child: Center(
                  child: Form(
                    autovalidate: _autoValidateForm,
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(30, 20, 30, 0),
                          child: TextFormField(
                            key: Key('username_field'),
                            decoration: InputDecoration(
                                labelText: 'Username',
                                prefixIcon: Icon(Icons.person)),
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter username';
                              }
                              return null;
                            },
                            onChanged: (val) {
                              setState(() {
                                _userName = val;
                              });
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(30, 20, 30, 0),
                          child: TextFormField(
                            key: Key('email_field'),
                            decoration: InputDecoration(
                                labelText: 'Email',
                                prefixIcon: Icon(Icons.email)),
                            validator: (value) {
                              final pattern =
                                  r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                              final regex = RegExp(pattern);
                              if (value.isEmpty) {
                                return 'Please enter email address';
                              }
                              if (!regex.hasMatch(value)) {
                                return 'Please enter valid email';
                              } else {
                                return null;
                              }
                            },
                            onChanged: (val) {
                              setState(() {
                                _email = val;
                              });
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(30, 20, 30, 0),
                          child: TextFormField(
                            key: Key('password_field'),
                            obscureText: true,
                            decoration: InputDecoration(
                                labelText: 'Password',
                                prefixIcon: Icon(Icons.visibility)),
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter password';
                              }
                              return null;
                            },
                            onChanged: (val) {
                              setState(() {
                                _password = val;
                              });
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(30, 20, 30, 100),
                          child: TextFormField(
                            key: Key('re_password_field'),
                            obscureText: true,
                            decoration: InputDecoration(
                              labelText: 'Re-enter password',
                              prefixIcon: Icon(Icons.visibility),
                            ),
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please re-enter password';
                              } else if (value != _password) {
                                return 'Passwords do not match, please try again';
                              }
                              return null;
                            },
                          ),
                        ),
                        RaisedButton(
                          key: Key('create_account_submit_btn'),
                          color: Theme.of(context).primaryColor,
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              setState(() {
                                _waitingForAuthResult = true;
                              });
                            } else {
                              _autoValidateForm = true;
                            }
                            final authResult = await context
                                .read<AuthService>()
                                .createUserAccount(_email, _password);

                            // go to lobby if successfull login
                            if (authResult is UserData) {
                              Navigator.pop(context);
                            } else if (authResult == null) {
                              setState(() {
                                _waitingForAuthResult = false;
                              });
                            }
                          },
                          child: Text('Submit'),
                        ),
                        Text('Already have an account?'),
                        InkWell(
                            key: Key('navigate_to_sign_in_link'),
                            child: Text(
                              'sign in here',
                              style: TextStyle(
                                  color: Color.fromRGBO(247, 152, 0, 1),
                                  decoration: TextDecoration.underline),
                            ),
                            onTap: () {
                              _formKey.currentState.reset();
                              _clearForm();
                              Navigator.pushReplacement<SignInScreen,
                                  CreateAccountScreen>(
                                context,
                                MaterialPageRoute<SignInScreen>(
                                  builder: (context) => SignInScreen(),
                                ),
                              );
                            }),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
