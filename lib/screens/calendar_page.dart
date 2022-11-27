import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarPage extends StatelessWidget {
  const CalendarPage({Key? key}) : super(key: key);

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('腹痛管理'),
      ),
      body: Center(
        child: TableCalendar(
          // 曜日の日本語対応
          locale: 'ja_JP',

          // フォーマットボタン表示を消す
          headerStyle: const HeaderStyle(
            formatButtonVisible: false,
            titleCentered: true,
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
          ),

          firstDay: DateTime(2022, 11, 27),
          lastDay: DateTime(2040, 12, 31),
          focusedDay: DateTime.now(),
        ),
      ),
    );
  }
}
