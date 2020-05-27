import 'package:flutter/material.dart';

import 'api.dart';

class HomePage extends StatefulWidget {

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<HomePage> {

  String data ='';

  @override
  void initState() {
    super.initState();
    welcome();
  }

  welcome() async {
    final home = await api.home();
    setState(() {
      data = home.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              data,
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
    );
  }

}