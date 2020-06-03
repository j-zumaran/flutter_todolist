import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'util.dart';
import 'widgets.dart';
import 'user.dart';
import 'home.dart';
import 'api.dart';

enum CalendarViewState { DAY, WEEK, MONTH }

extension _Name on CalendarViewState {
  String get name => enumName(this.toString());
}

//=========================================================================

class CalendarPage extends HomeSection {
  CalendarPage() : super(const Tab(text: 'calendar'));

  final _calendar = api.getUserCalendar();

  final _stateItems = CalendarViewState.values
      .map<DropdownMenuItem<CalendarViewState>>(
          (val) => DropdownMenuItem(
            value: val,
            child: Text(val.name),
      )
  ).toList();

  @override
  _CalendarState createState() => _CalendarState();

  CalendarViewState get defaultView => _calendar.defaultView;
}

class _CalendarState extends HomeSectionState<CalendarPage> {

  _CalendarView _currentView;
  CalendarViewState _currentViewState;
  String _title;

  @override
  void initState() {
    super.initState();
    _currentViewState = widget.defaultView;
    _currentView = mapView();
    _title = _currentView.title;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Center(
          child: Text('$_title'),
        ),
        leading: FlatButton(
          child: Icon(Icons.arrow_back),
          onPressed: previousView,
        ),
        actions: <Widget>[
          FlatButton(
            child: Icon(Icons.arrow_forward),
            onPressed: () {},
          ),
        ],
      ),
      body: Center(child: _currentView),
      persistentFooterButtons: <Widget>[
        DropdownButton<CalendarViewState>(
          value: _currentViewState,
          items: widget._stateItems,
          onChanged: (value) => setState(() {
            _currentViewState = value;
            _currentView = mapView();
            _title = _currentView.title;
          }),
        ),
      ],
    );
  }


  void updateTitle(String title) {
    setState(() => _title = title);
  }

  _CalendarView mapView() {
    switch (_currentViewState) {
      case CalendarViewState.DAY:
        return DayView(widget._calendar.currentDay,
          onDayChanged: updateTitle,
        );
      case CalendarViewState.WEEK:
        return WeekView(widget._calendar.currentWeek);
      case CalendarViewState.MONTH:
        return MonthView(widget._calendar.currentMonth,
          onMonthChanged: updateTitle,
        );
    }
    return null;
  }

  previousView() {
    widget._calendar.setPrevious();
    setState(() => _currentView = mapView());
  }
}

//=============================================================================

typedef void OnDateChanged(String title);

abstract class _CalendarView extends StatefulWidget {
  final String title;
  final OnDateChanged onDateChanged;
  _CalendarView(this.title, {this.onDateChanged});

  nextView() {

  }
}

abstract class _CalendarViewState<S extends _CalendarView> extends State<S> {
  //UserCalendar _calendar;
  //_CalendarViewState(this._calendar);

  /*refresh() {
    setState(() => _calendar = api.getUserCalendar());
  }*/
}

//============================================================================

class DayView extends _CalendarView {
  final UserDay _day;

  DayView(this._day, {OnDateChanged onDayChanged})
      : super(_day.nameDate, onDateChanged: onDayChanged);

  @override
  _DayViewState createState() => _DayViewState();
}

class _DayViewState extends _CalendarViewState<DayView> {
  //_DayViewState(UserCalendar calendar);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: renderHours(widget._day),
    );
  }

  ListView renderHours(UserDay day) {
    return ListView.builder(
      itemCount: 48,
      itemBuilder: (context, index) => Container(
          height: 30,
          color: Colors.amber.withOpacity(0 + index / 48),
          child: Center(
            child: Row(
              children: <Widget>[
                Text('${(index ~/ 2).toString().padLeft(2, '0')}:${index.isEven? '00': '30'}')
              ],
            ),
          )
      ),
    );
  }

}

//============================================================================

class WeekView extends _CalendarView {
  final UserWeek _week;

  WeekView(this._week, {OnDateChanged onWeekChanged})
      : super('${_week.firstDayDate}', onDateChanged: onWeekChanged);

  @override
  _WeekViewState createState() => _WeekViewState();
}

class _WeekViewState extends _CalendarViewState<WeekView> {
  UserWeek _week;

  @override
  void initState() {
    super.initState();
    _week = widget._week;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: weekDays(_week.days),
    );
  }

  ListView weekDays(List<UserDay> days) {
    return ListView.builder(
      itemCount: days.length,
      itemBuilder: (context, index) => Container(
        height: 120,
        color: Colors.amber.withOpacity(0 + index / days.length),
        child: Row(
            children: <Widget>[
              Text('${days[index].shortName}'),
              dayEvents(days[index].events),
            ]
        ),
      )
    );
  }

  ListView dayEvents(List<Event> events) {
    return ListView.builder(
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      itemCount: events.length,
      itemBuilder: (context, index) => Container(
        width: 100,
        child: Text('${events[index].name}'),
      ),
    );
  }
  
}

//============================================================================

class MonthView extends _CalendarView {
  final UserMonth _month;
  MonthView(this._month, {OnDateChanged onMonthChanged})
      : super(_month.name, onDateChanged: onMonthChanged);

  @override
  _MonthViewState createState() => _MonthViewState();
}

class _MonthViewState extends _CalendarViewState<MonthView> {
  UserMonth _month;

  @override
  void initState() {
    super.initState();
    _month = widget._month;
  }

  @override
  Widget build(BuildContext context) {
    final monthView = <Widget>[Row(children: dayHeaders(_month.weekDays))];

    monthView.addAll(monthWeeks(_month.weeks));

    return CenteredColumn(
      children: monthView,
    );
  }

  List<Widget> dayHeaders(List<Day> weekDays) {
    return List.generate(weekDays.length, (index) =>
      Expanded(
        child: Container(
          child: Text('${weekDays[index].shortName}'),
        ),
      )
    );
  }

  List<Widget> monthWeeks(List<UserWeek> weeks) {
    return List.generate(weeks.length, (index) =>
      Expanded(
        child: Container(
          child: Row(
            children: renderWeek(weeks[index].days),
          ),
        ),
      )
    );
  }

  renderWeek(List<UserDay> days) {
    return List.generate(days.length, (index) => Expanded(
        child: Container(
          child: Text('${days[index].date}'),
        ),
      )
    );
  }


}

//============================================================================