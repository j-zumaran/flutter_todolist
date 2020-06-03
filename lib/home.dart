import 'package:flutter/material.dart';
import 'profile.dart';
import 'api.dart';
import 'widgets.dart';
import 'dashboard.dart';
import 'calendar.dart';

class HomePage extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState([DashBoard(), CalendarPage(), ProfilePage()]);
}

class _HomeState extends State<HomePage> {
  final List<HomeSection> sections;
  _HomeState(this.sections);

  @override
  Widget build(BuildContext context) {
    return WillPopScope( // disables back button
      onWillPop: () => yesNoDialog(context, 'Exit application?', () => api.logout()),
      child: DefaultTabController(
        length: sections.length,
        child: Scaffold(
          body: TabBarView(children: sections),
          bottomNavigationBar: TabBar(tabs: sections.map((e) => e.tab).toList())),
      ),
    );
  }
}

abstract class HomeSection extends StatefulWidget {
  final Widget tab;
  HomeSection(this.tab);
}

abstract class HomeSectionState<H extends HomeSection> extends State<H> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
}