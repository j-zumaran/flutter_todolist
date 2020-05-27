import 'package:flutter/material.dart';

import 'widgets.dart';
import 'home.dart';
import 'api.dart';

class LoginPage extends StatefulWidget {
  LoginPage({ Key key }) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<LoginPage> {
  final _emailText = TextEditingController();
  final _passwordText = TextEditingController();

  bool validateUser() => _emailText.text.isNotEmpty && _passwordText.text.isNotEmpty;

  String _state;

  void login() async {
    if (validateUser()) {
      setState(() {
        _state = "Sending request";
      });

      final response = await api.login(_emailText.text, _passwordText.text);

      setState(() {
        switch (response.statusCode) {
          case 200:
            _state = "success ${response.statusMessage} $response";
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
            break;
          case 401: _state = 'Invalid credentials'; break;
          default: _state = '${response.statusMessage}';
        }
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
            BorderTextField.required('email', _emailText),
            BorderTextField.password(_passwordText),
            Button('Login', login),
            Text(
              '$_state',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailText.dispose();
    _passwordText.dispose();
    super.dispose();
  }
}