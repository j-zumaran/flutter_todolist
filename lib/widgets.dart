import 'package:flutter/material.dart';

class BorderTextField extends StatelessWidget {
  BorderTextField(this._label, this._controller, this._validate, {this.obscureText = false});

  factory BorderTextField.required(String label, TextEditingController controller) {
    return BorderTextField(label, controller, (text) => text.isEmpty ? 'enter $label': null);
  }

  factory BorderTextField.password(TextEditingController controller) {
    return BorderTextField('password', controller, (pass) => pass.isEmpty ? 'enter password': null);
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
          child: TextFormField(
            autofocus: true,
            obscureText: obscureText,
            controller: _controller,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: _label,
              errorText: _validate(_controller.text)
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