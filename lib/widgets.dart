import 'package:flutter/material.dart';

class BorderTextField extends StatelessWidget {
  BorderTextField(this._label, this._controller, this._validate, {this.obscureText = false});

  factory BorderTextField.required(String label, TextEditingController controller) {
    return BorderTextField(label, controller, (text) => text.isEmpty ? 'enter $label': null);
  }

  factory BorderTextField.password(TextEditingController controller) {
    return BorderTextField('password', controller, (pass) => pass.isEmpty ? 'enter password': null, obscureText: true);
  }

  factory BorderTextField.passwordConfirm(TextEditingController controller, TextEditingController confirm) {
    return BorderTextField('confirm password', controller,
            (pass) => pass.isEmpty? 'enter password': pass == confirm.text? null: "passwords don't match",
        obscureText: true);
  }

  final String _label;
  final TextEditingController _controller;
  final String Function(String) _validate;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          width: 300,
          padding: const EdgeInsets.all(10),
          child: TextFormField(
            obscureText: obscureText,
            controller: _controller,
            validator: _validate,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: _label,
             // errorText: _validate(_controller.text),
            ),
          ),
        )
      ],
    );
  }
}

class Button extends StatelessWidget {
  Button(this._label, this._onPressed);

  final String _label;
  final VoidCallback _onPressed;

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: _onPressed,
      child: Text(_label),
    );
  }
}

final yesNoDialog = (BuildContext context, String msg, Function yesAction, {Function noAction}) => showDialog<bool>(
  context: context,
  builder: (c) => AlertDialog(
    content: Text(msg),
    actions: <Widget>[
      FlatButton(
        child: const Text('Yes'),
        onPressed: () {
          Navigator.pop(c, true);
          yesAction.call();
        },
      ),
      FlatButton(
        child: const Text('No'),
        onPressed: () {
          Navigator.pop(c, false);
          noAction?.call();
        },
      )
    ],
  ),
);

class CenteredColumn extends StatelessWidget {
  CenteredColumn({this.children});
  final List<Widget> children;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: children,
        ),
      ),
    );
  }
}