import 'package:flutter/material.dart';
import 'package:niira/loading.dart';
import 'package:niira/models/user_data.dart';
import 'package:niira/navigation/navigation.dart';
import 'package:niira/services/auth/auth_service.dart';
import 'package:provider/provider.dart';
import 'package:niira/extensions/custom_colors_extension.dart';

class SignInScreen extends StatefulWidget {
  static const routeName = '/sign_in';

  const SignInScreen({Key key}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();

  bool _waitingForAuthResult;
  bool _autoValidateForm;
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
          'Sign in',
          style: TextStyle(color: Colors.white),
        ),
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
                          padding: const EdgeInsets.fromLTRB(30, 20, 30, 100),
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
                        RaisedButton(
                          key: Key('sign_in_submit_btn'),
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
                                .signInWithEmail(_email, _password);

                            // if successfull login,
                            // go to lobby and set user in local state
                            if (authResult != null) {
                              context.read<Navigation>().pop();
                            } else if (authResult == null) {
                              setState(() {
                                _waitingForAuthResult = false;
                              });
                            }
                          },
                          child: Text('Submit'),
                        ),
                        Text("Don't have an account yet?"),
                        InkWell(
                            key: Key('navigate_to_create_account_link'),
                            child: Text(
                              'Create account here',
                              style: TextStyle(
                                  color: CustomColorScheme.variant,
                                  decoration: TextDecoration.underline),
                            ),
                            onTap: () {
                              _formKey.currentState.reset();
                              _clearForm();
                              context
                                  .read<Navigation>()
                                  .switchToCreateAccount();
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
