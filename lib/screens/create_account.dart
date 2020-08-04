import 'package:flutter/material.dart';
import 'package:niira/screens/sign_in.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({Key key}) : super(key: key);

  @override
  _CreateAccountScreenState createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final _formKey = GlobalKey<FormState>();
  bool waitingForAuthResult;
  String userName;
  String email;
  String password;

  @override
  void initState() {
    super.initState();
    waitingForAuthResult = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "Create account",
          style: TextStyle(color: Colors.white),
        ),
        // backgroundColor: Color.fromRGBO(247, 152, 0, 1),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Center(
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(30, 20, 30, 0),
                    child: TextFormField(
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
                          userName = val;
                        });
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(30, 20, 30, 0),
                    child: TextFormField(
                      decoration: InputDecoration(
                          labelText: 'Email', prefixIcon: Icon(Icons.email)),
                      validator: (value) {
                        Pattern pattern =
                            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                        RegExp regex = new RegExp(pattern);
                        if (value.isEmpty) {
                          return 'Please enter email address';
                        }
                        if (!regex.hasMatch(value))
                          return 'Enter Valid Email';
                        else
                          return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(30, 20, 30, 0),
                    child: TextFormField(
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
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(30, 20, 30, 100),
                    child: TextFormField(
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Re-enter password',
                        prefixIcon: Icon(Icons.visibility),
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please re-enter password';
                        } else if (value != password) {
                          return 'retry, passwords do not match';
                        }
                        return null;
                      },
                    ),
                  ),
                  RaisedButton(
                    color: Theme.of(context).primaryColor,
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        // replace snackbar with loading icon
                        Scaffold.of(context).showSnackBar(
                            SnackBar(content: Text('Processing Data')));
                      }
                    },
                    child: Text('Submit'),
                  ),
                  Text('Already have an account?'),
                  InkWell(
                      child: Text(
                        'sign in here',
                        style: TextStyle(
                            color: Color.fromRGBO(247, 152, 0, 1),
                            decoration: TextDecoration.underline),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SignInScreen()),
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
