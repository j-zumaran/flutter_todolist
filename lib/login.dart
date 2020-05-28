import 'package:flutter/material.dart';

import 'widgets.dart';
import 'home.dart';
import 'api.dart';

class LoginPage extends StatefulWidget {

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<LoginPage> {
  final _emailTEC = TextEditingController();
  final _passwordTEC = TextEditingController();

  bool validateUser() => _emailTEC.text.isNotEmpty && _passwordTEC.text.isNotEmpty;

  String _state = '';

  void login() async {
    if (!validateUser()) return;

    setState(() {
      _state = 'sending request';
    });

    final login = await api.login(_emailTEC.text, _passwordTEC.text);

    setState(() {
      _state = login.msg;
      if (login.isSuccessful()) {
        Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
      }
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            BorderTextField.required('email', _emailTEC),
            BorderTextField.password(_passwordTEC),
            Button('Login', login),
            Text('$_state',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailTEC.dispose();
    _passwordTEC.dispose();
    super.dispose();
  }
}