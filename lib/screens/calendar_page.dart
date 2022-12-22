import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:stomach_ache_app/screens/calendar_add_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stomach_ache_app/model/calendar.dart';

class CalendarPage extends ConsumerStatefulWidget {
  const CalendarPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CalendarPageState();
}

class _CalendarPageState extends ConsumerState<CalendarPage> {
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
                // 現在保持しているのデータと数を確認
                // print(calendar.eventsList);
                // print(calendar.eventsList.length);

                if (!isSameDay(calendar.selectedDay, selectedDay)) {
                  setState(() {
                    calendar.selectedDay = selectedDay;
                    calendar.focusedDay = focusedDay;
                  });
                  getEventForDay(selectedDay);

                  // 全イベントのキーを表示
                  // print(calendar.eventsList.keys);

                  // イベントのキーをループ処理（単純な日付比較ができなかったため）
                  for (DateTime key in calendar.eventsList.keys) {
                    // 全イベントのキーをループで表示
                    // print(key);

                    // 全イベントのキーをString型にフォーマット
                    DateFormat outputFormat = DateFormat('yyyy-MM-dd');
                    String dateKey = outputFormat.format(key);
                    // print(dateKey);

                    // 選択された日付のイベントのキーを表示
                    // print(calendar.selectedDay);

                    // 選択した日付の日付のイベントのキーをString型にフォーマット
                    String dateSelect =
                        outputFormat.format(calendar.selectedDay!);
                    // print(dateSelect);
                    // print(dateSelect == dateKey);

                    // 全イベントのキーと選択したイベントのキーを比較する
                    // true: 下からモーダルを表示
                    // false: 何も起こらない（ただ日付を選択した状態になる）
                    if (dateSelect == dateKey) {
                      showModalBottomSheet(
                        //モーダルの背景の色、透過
                        backgroundColor: Colors.transparent,
                        //ドラッグ可能にする（高さもハーフサイズからフルサイズになる様子）
                        isScrollControlled: true,
                        context: context,
                        builder: (BuildContext context) {
                          return Container(
                            margin: const EdgeInsets.only(top: 64),
                            decoration: const BoxDecoration(
                              //モーダル自体の色
                              color: Colors.white,
                              //角丸にする
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                              ),
                            ),
                            child: ListView(
                              shrinkWrap: true,
                              // 日付を選択したときにイベントがあった場合のモーダル
                              children: getEventForDay(calendar.selectedDay!)
                                  .map((event) => modalCalenderDetail(event))
                                  .toList(),
                            ),
                          );
                        },
                      );
                    }
                  }
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

                // イベントがあるマーカーのスタイル
                markerBuilder: (context, date, List events) {
                  if (events.isNotEmpty) {
                    return Positioned(
                      right: 5,
                      bottom: 5,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: 20.0,
                        height: 20.0,
                        child: Center(
                          child: calendar.todayStatus(events.last['status']),
                        ),
                      ),
                    );
                  }
                  return null;
                },
              ),
            ),
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

// 日付を選択したときにイベントがあった場合のモーダル
Widget modalCalenderDetail(Map event) {
  // `Widget`でriverpodにアクセスするConsumer
  // 通常のWidgetをラップし(この場合Text)、ラップしたWidget内でProviderでアクセスできるようになる。
  // StatelessWidgetやStatefulWidgetのWidgetでriverpodを使用したい場合に使用する。
  // 例
  // Consumer(
  //   builder: (context, ref, child) => Text(
  //     '${ref.watch(_stateProvider).state}',
  //     style: Theme.of(context).textTheme.headline4,
  //   ),
  // )

  return Consumer(
    builder: (context, ref, child) => Padding(
      padding: const EdgeInsets.all(30.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.blueGrey[900],
                ),
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                child: Text(
                  "${ref.watch(calendarProvider).selectedDay!.month}月${ref.watch(calendarProvider).selectedDay!.day}日",
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  // 編集画面時には、その日付の「痛み」を表示さえるためのデータ渡し
                  ref.watch(calendarProvider).toggleList =
                      ref.watch(calendarProvider).editBoolToggleList();
                  print(ref.watch(calendarProvider).toggleList);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CalendarAddPage(),
                    ),
                  );
                },
                child: const Text('編集'),
              )
            ],
          ),
          const SizedBox(height: 30),
          Row(
            children: [
              const Text(
                '痛み',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 40),
              ref.watch(calendarProvider).todayStatus(event['status']),
              const SizedBox(width: 10),
              Text(
                event['status'],
                style: const TextStyle(
                  fontSize: 15,
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          Row(
            children: const [
              Text(
                '考えられる原因',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Wrap(
            runSpacing: 10,
            spacing: 16,
            children: event['causes'].map<Widget>((cause) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(32)),
                  border: Border.all(
                    width: 1,
                    color: Colors.teal,
                  ),
                  color: Colors.teal,
                ),
                child: Text(
                  cause,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 30),
          const Text(
            '一言メモ',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            event['memo'],
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
        ],
      ),
    ),
  );
}
// }
