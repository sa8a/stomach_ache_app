import 'dart:collection';
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

  // カレンダーのイベントリスト
  Map<DateTime, List> _eventsList = {};

  // DateTime型から20210930の8桁のint型へ変換
  int getHashCode(DateTime key) {
    return key.day * 1000000 + key.month * 10000 + key.year;
  }

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;

    // イベントのサンプルリスト
    _eventsList = {
      DateTime.now().subtract(Duration(days: 2)): ['Event A6', 'Event B6'],
      DateTime.now(): ['Event A7', 'Event B7', 'Event C7', 'Event D7'],
      DateTime.now().add(Duration(days: 1)): [
        'Event A8',
        'Event B8',
        'Event C8',
        'Event D8'
      ],
      DateTime.now().add(Duration(days: 3)):
          Set.from(['Event A9', 'Event A9', 'Event B9']).toList(),
      DateTime.now().add(Duration(days: 7)): [
        'Event A10',
        'Event B10',
        'Event C10'
      ],
      DateTime.now().add(Duration(days: 11)): ['Event A11', 'Event B11'],
      DateTime.now().add(Duration(days: 17)): [
        'Event A12',
        'Event B12',
        'Event C12',
        'Event D12'
      ],
      DateTime.now().add(Duration(days: 22)): ['Event A13', 'Event B13'],
      DateTime.now().add(Duration(days: 26)): [
        'Event A14',
        'Event B14',
        'Event C14'
      ],
    };
  }

  @override
  Widget build(BuildContext context) {
    // TableCalendarでカレンダーに読み込むイベントをMapで定義した場合、
    // LinkedHashMapを使用することを推奨されている。
    final _events = LinkedHashMap<DateTime, List>(
      equals: isSameDay,
      hashCode: getHashCode,
    )..addAll(_eventsList);

    List getEventForDay(DateTime day) {
      return _events[day] ?? [];
    }

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

          // カレンダーのイベント読み込み
          eventLoader: getEventForDay,

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
          onPageChanged: (focusedDay) {
            _focusedDay = focusedDay;
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
              color: Colors.teal[100],
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
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            },
          ),
        ),
      ),

      // カレンダーのイベント作成用ボタン（あとでカスタマイズ）
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CalendarPage(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
