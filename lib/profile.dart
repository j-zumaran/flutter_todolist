import 'package:flutter/material.dart';
import 'package:fluttertodolist/widgets.dart';

import 'home.dart';
import 'user.dart';
import 'api.dart';


class ProfilePage extends HomeSection {
  ProfilePage() : super(const Tab(text: 'profile'));

  @override
  _ProfileState createState() {
    return _ProfileState();
  }
}

class _ProfileState extends State<ProfilePage> {
  var data = '';

  @override
  void initState() {
    super.initState();
    //getProfile();
  }

  getProfile() async {
    final profile = await api.profile();
    setState(() => data = profile);
  }

  @override
  Widget build(BuildContext context) {
    return CenteredColumn(
      children: <Widget>[
        Text(data)
      ],
    );
  }
  
}