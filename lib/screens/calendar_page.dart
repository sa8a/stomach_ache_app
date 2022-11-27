import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarPage extends StatelessWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('腹痛管理'),
      ),
      body: Center(
        child: TableCalendar(
          firstDay: DateTime(2022, 11, 27),
          lastDay: DateTime(2040, 12, 31),
          focusedDay: DateTime.now(),
        ),
      ),
    );
  }
}
