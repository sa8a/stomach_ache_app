import 'package:flutter/material.dart';

class CalendarPage extends StatelessWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('腹痛管理'),
      ),
      body: const Center(
        child: Text('カレンダーを表示'),
      ),
    );
  }
}
