import 'package:flutter/material.dart';

import 'api.dart';
import 'widgets.dart';
import 'user.dart';
import 'home.dart';

class DashBoard extends HomeSection {
  DashBoard() : super(const Tab(text: 'dashboard'));

  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends HomeSectionState<DashBoard> {
  String data ='';

  Future<void> welcome() async {
    final home = await api.home();
    setState(() => data = home.toString());
  }

  addRandomTag() {
    api.addUserTag(UserTag.name(UniqueKey().toString()));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: CenteredColumn(
        children: <Widget>[
          Text(data),
          Button('refresh', welcome),
          Button('random tag', addRandomTag)
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {},
      ),
    );
  }
}