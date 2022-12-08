import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:stomach_ache_app/screens/calendar_add_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stomach_ache_app/model/calendar.dart';

class CalendarPage extends ConsumerStatefulWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  CalendarPageState createState() => CalendarPageState();
}

class CalendarPageState extends ConsumerState<CalendarPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Providerを読み取る。watchを使用しているので、
    // `Calendar` の状態が更新されると、buildメソッドが再実行され、画面が更新される
    final calendar = ref.watch(calendarProvider);

    // 初期化
    calendar.initState();

    // TableCalendarでカレンダーに読み込むイベントをMapで定義した場合、
    // LinkedHashMapを使用することを推奨されている。
    final events = LinkedHashMap<DateTime, List>(
      equals: isSameDay,
      hashCode: calendar.getHashCode,
    )..addAll(calendar.eventsList);

    List getEventForDay(DateTime day) {
      return events[day] ?? [];
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('腹痛管理'),
      ),
      body: Center(
        child: Column(
          children: [
            TableCalendar(
              // 基本設定
              firstDay: DateTime(2022, 1, 1),
              lastDay: DateTime(2100, 12, 31),
              focusedDay: calendar.focusedDay,

              // カレンダーのイベント読み込み
              eventLoader: getEventForDay,

              selectedDayPredicate: (day) {
                return isSameDay(calendar.selectedDay, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                if (!isSameDay(calendar.selectedDay, selectedDay)) {
                  setState(() {
                    calendar.selectedDay = selectedDay;
                    calendar.focusedDay = focusedDay;
                  });
                  getEventForDay(selectedDay);
                }
              },
              onPageChanged: (focusedDay) {
                calendar.focusedDay = focusedDay;
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
                        color: calendar.textColor(day),
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
                        color: calendar.textColor(day),
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
                        color: calendar.textColor(day),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                },
              ),
            ),
            ListView(
              shrinkWrap: true,
              children: getEventForDay(calendar.selectedDay!)
                  .map((event) => ListTile(
                        title: Text(event.toString()),
                      ))
                  .toList(),
            )
          ],
        ),
      ),

      // カレンダーのイベント作成用ボタン（あとでカスタマイズ）
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CalendarAddPage(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
