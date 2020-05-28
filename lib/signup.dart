import 'package:flutter/material.dart';
import 'dart:async';
import 'api.dart';
import 'widgets.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUpPage> {
  final _emailTEC = TextEditingController();
  final _passwordTEC = TextEditingController();
  final _passwordConfirmTEC = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  var _state = '';

  signUp() async {
    if (!_formKey.currentState.validate()) return;

    setState(() => _state = 'sending request');
    final signUp = await api.signUp(_emailTEC.text, _passwordTEC.text, _passwordConfirmTEC.text);

    setState(() => _state = signUp.msg);

    if (signUp.isSuccessful()) {
      Timer(Duration(seconds: 1), () {
        Navigator.pop(context, _emailTEC.text);
          _emailTEC.text = '';
          _passwordTEC.text = '';
          _passwordConfirmTEC.text = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('signup'),
            Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  BorderTextField.required('email', _emailTEC),
                  BorderTextField.password(_passwordTEC),
                  BorderTextField.passwordConfirm(_passwordConfirmTEC, _passwordTEC),
                  Button('sign up', signUp),
                  Button('cancel', () => Navigator.pop(context, ''))
                ],
              ),
            ),
            Text('$_state',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
    );
  }

}