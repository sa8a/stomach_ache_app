import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  // 土（青）日（赤）に色をつける関数
  Color _textColor(DateTime day) {
    const _defaultTextColor = Colors.black87;

    if (day.weekday == DateTime.sunday) {
      return Colors.red;
    }
    if (day.weekday == DateTime.saturday) {
      return Colors.blue[600]!;
    }
    return _defaultTextColor;
  }

  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('腹痛管理'),
      ),
      body: Center(
        child: TableCalendar(
          // 基本設定
          firstDay: DateTime(2022, 1, 1),
          lastDay: DateTime(2040, 12, 31),
          focusedDay: _focusedDay,

          selectedDayPredicate: (day) {
            return isSameDay(_selectedDay, day);
          },
          onDaySelected: (selectedDay, focusedDay) {
            if (!isSameDay(_selectedDay, selectedDay)) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            }
          },

          // 曜日の日本語対応
          locale: 'ja_JP',

          // フォーマットボタン表示を消す
          headerStyle: const HeaderStyle(
            formatButtonVisible: false,
            titleCentered: true,
          ),

          // カスタマイズ用のスタイル
          calendarStyle: CalendarStyle(
            // defaultDecoration: BoxDecoration(),
            // outsideDecoration: BoxDecoration(),
            // weekendDecoration: BoxDecoration(),

            // 今日の日付のスタイル
            todayDecoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[200],
            ),
            todayTextStyle: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          // カスタマイズ用の関数
          calendarBuilders: CalendarBuilders(
            // dowBuilderまたはdaysOfWeekBuilder（曜日）
            // defaultBuilder（日付）
            // disabledBuilder（先月、来月の日付）
            // selectedBuilder（選択中の日付）
            // markerBuilder（マーカー付き日付）
            // todayBuilder（今日の日付）

            // 曜日の土（青）日（赤）に色をつける
            dowBuilder: (BuildContext context, DateTime day) {
              final dowText = DateFormat.E('ja').format(day);
              return Center(
                child: Text(
                  dowText,
                  style: TextStyle(
                    color: _textColor(day),
                  ),
                ),
              );
            },

            // 日付の土（青）日（赤）に色をつける
            defaultBuilder:
                (BuildContext context, DateTime day, DateTime focusedDay) {
              return Center(
                child: Text(
                  day.day.toString(),
                  style: TextStyle(
                    color: _textColor(day),
                  ),
                ),
              );
            },

            // 選択した日付のスタイル
            selectedBuilder:
                (BuildContext context, DateTime day, DateTime focusedDay) {
              return Center(
                child: Text(
                  day.day.toString(),
                  style: TextStyle(
                    color: _textColor(day),
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
