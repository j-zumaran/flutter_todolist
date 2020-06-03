import 'package:fluttertodolist/calendar.dart';

import 'util.dart';

enum Day {
  Monday, Tuesday, Wednesday, Thursday, Friday, Saturday, Sunday
}

extension DayExt on Day {
  String get name => enumName(this.toString());
  String get shortName => name.substring(0, 3);
  bool get isWeekEnd {
    switch (this) {
      case Day.Saturday: return true;
      case Day.Sunday: return true;
      default: return false;
    }
  }
}

enum Month {
  January, February, March, April, May, June, July, August, September, November, December
}

extension MonthExt on Month {
  String get name => enumName(this.toString());
}

class UserCalendar {
  final List<UserMonth> months;
  
  Month _currentMonth = Month.values[DateTime.now().month - 1];

  UserCalendar(this.months);

  int _currentDay() => DateTime.now().day;

  UserMonth get currentMonth => months.firstWhere((m) => m._month == _currentMonth);

  UserWeek get currentWeek => currentMonth.weeks.firstWhere((w) => _currentDay() >= w.firstDayDate);

  UserDay get currentDay => currentWeek.days.firstWhere((d) => _currentDay() == d.date);

  CalendarViewState get defaultView => CalendarViewState.DAY;

  void setPrevious() {}
}

class UserMonth {
  final Month _month;
  final List<UserWeek> weeks;
  UserMonth(this._month, this.weeks);

  List<Day> get weekDays => weeks[0].days.map((d) => d._day).toList();

  String get name => _month.name;
}

class UserWeek {
  final List<UserDay> days;
  UserWeek(this.days);

  int get firstDayDate => days[0].date;
}

class UserDay {
  final Day _day;
  final int date;
  final List<Event> events;

  UserDay(this._day, this.date, this.events);

  String get name => _day.name;
  String get nameDate => '${_day.name} $date';
  String get shortName => _day.shortName;
}


class Event {
  final String name;
  Event(this.name);
}


class LoginCredentials {
  final String email;
  final String password;
  bool rememberMe;

  LoginCredentials(this.email, this.password, [this.rememberMe = false]);
}


class UserData {
  UserData(this.id);

  final int id;
}

class Todo {
  String name;
}

class UserTag {
  int _id;
  String name;

  UserTag(this._id, this.name);
  UserTag.name(this.name);

  Map<String, dynamic> toJson(){
    return {
      'id': _id,
      'name': name
    };
  }

  factory UserTag.fromJson(Map<dynamic, dynamic> json) {
    return UserTag(json['id'], json['name']);
  }
}