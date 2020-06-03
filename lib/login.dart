import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertodolist/user.dart';

import 'widgets.dart';
import 'home.dart';
import 'api.dart';
import 'signup.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<LoginPage> {
  final _emailTEC = TextEditingController();
  final _passwordTEC = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  var _state = 'mascota';

  void login() async {
    if (!_formKey.currentState.validate()) return;

    setState(() => _state = 'sending request');

    final user = LoginCredentials(_emailTEC.text, _passwordTEC.text);

    final login = await api.login(user);

    setState(() => _state = login.msg);

    if (login.isSuccessful()) {
      Navigator.push(context, MaterialPageRoute(builder: (c) => HomePage()));
      Timer(Duration(seconds:2), () {
        _emailTEC.text = '';
        _passwordTEC.text = '';
      });
      _state = '';
    }
  }

  signUp() async {
    final email = await Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpPage()));
    setState(() => _emailTEC.text = email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CenteredColumn(
        children: <Widget>[
          const Text('login'),
          Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                BorderTextField.required('email', _emailTEC),
                BorderTextField.password(_passwordTEC),
                Button('login', login),
              ],
            ),
          ),
          Button('no account? sign up', signUp),
          Text('$_state',
            style: Theme.of(context).textTheme.headline4,
          ),
        ],
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