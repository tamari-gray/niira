import 'package:flutter/material.dart';
import 'package:niira/screens/create_account.dart';
import 'package:niira/screens/sign_in.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key key}) : super(key: key);
  static const navigateToSignInBtn = Key('navigateToSignIn');
  static const navigateToCreateAccountBtn = Key('navigateToCreateAccount');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 200, 0, 0),
                child: Text(
                  'Niira',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 96,
                    color: const Color(0xffface4d),
                    letterSpacing: 8.553599853515625,
                    fontWeight: FontWeight.w500,
                    shadows: [
                      Shadow(
                        color: const Color(0xfff71a0d),
                        offset: Offset(0, 3),
                        blurRadius: 15,
                      )
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Text.rich(
                TextSpan(
                  style: TextStyle(
                    fontFamily: 'Helvetica Neue',
                    fontSize: 24,
                    color: const Color(0xff82fab8),
                  ),
                  children: [
                    TextSpan(
                      text: 'Hyper ',
                    ),
                    TextSpan(
                      text: 'hide and go seek',
                      style: TextStyle(
                        color: const Color(0xfffefefe),
                      ),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 150, 0, 0),
                child: Container(
                  child: Column(
                    children: <Widget>[
                      RaisedButton(
                        key: navigateToCreateAccountBtn,
                        color: Color.fromRGBO(247, 152, 0, 1),
                        onPressed: () {
                          Navigator.push<dynamic>(
                            context,
                            MaterialPageRoute<dynamic>(
                                builder: (context) => CreateAccountScreen()),
                          );
                        },
                        child: Text(
                          'Create account',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      Text('or'),
                      OutlineButton(
                        key: navigateToSignInBtn,
                        onPressed: () {
                          Navigator.push<dynamic>(
                            context,
                            MaterialPageRoute<dynamic>(
                                builder: (context) => SignInScreen()),
                          );
                        },
                        color: Color.fromRGBO(247, 152, 0, 1),
                        child: Text(
                          'Sign in',
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
