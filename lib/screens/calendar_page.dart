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
  // DateTime _focusedDay = DateTime.now();
  // DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    //  `ref` は StatefulWidget のすべてのライフサイクルメソッド内で使用可能です。
    // 例）ref.read(counterProvider);

    // _selectedDay = _focusedDay;

    // エラーコード
    // ref.watch(calendarProvider) = {
    //   DateTime.now().subtract(const Duration(days: 2)): ['Event A6', 'Event B6'],
    //   DateTime.now(): ['Event A7', 'Event B7', 'Event C7', 'Event D7'],
    // };
  }

  @override
  Widget build(BuildContext context) {
    // StateNotifierProviderを読み取る。watchを使用しているので、
    // state（状態）であるcalendarリストが更新されると、buildメソッドが再実行されて画面が更新される
    final calendar = ref.watch(calendarNotifierProvider);

    // CalendarNotifier を使用する場合は `.notifier` を付けてProviderを読み取る
    final notifier = ref.watch(calendarNotifierProvider.notifier);

    // notifier.focusedDay = DateTime.now();
    // notifier.selectedDay = notifier.focusedDay;

    notifier.initState();

    // TableCalendarでカレンダーに読み込むイベントをMapで定義した場合、
    // LinkedHashMapを使用することを推奨されている。
    final events = LinkedHashMap<DateTime, List>(
      equals: isSameDay,
      hashCode: notifier.getHashCode,
    )..addAll(calendar);

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
              focusedDay: notifier.focusedDay,

              // カレンダーのイベント読み込み
              eventLoader: getEventForDay,

              selectedDayPredicate: (day) {
                return isSameDay(notifier.selectedDay, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                if (!isSameDay(notifier.selectedDay, selectedDay)) {
                  setState(() {
                    notifier.selectedDay = selectedDay;
                    notifier.focusedDay = focusedDay;
                  });
                  getEventForDay(selectedDay);
                }
              },
              onPageChanged: (focusedDay) {
                notifier.focusedDay = focusedDay;
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
                        color: notifier.textColor(day),
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
                        color: notifier.textColor(day),
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
                        color: notifier.textColor(day),
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
              children: getEventForDay(notifier.selectedDay!)
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
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => const CalendarAddPage(),
          //   ),
          // );
          print(notifier.focusedDay);
          print(notifier.selectedDay);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
