import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stomach_ache_app/model/calendar.dart';

class CalendarAddPage extends ConsumerStatefulWidget {
  const CalendarAddPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CalendarAddPageState();
}

class _CalendarAddPageState extends ConsumerState<CalendarAddPage> {
  @override
  Widget build(BuildContext context) {
    // Providerを読み取る。watchを使用しているので、
    // `Calendar` の状態が更新されると、buildメソッドが再実行され、画面が更新される
    final calendar = ref.watch(calendarProvider);

    return Scaffold(
      appBar: AppBar(
        // 選択した日付のテキストを表示
        title: Text(
            "${calendar.selectedDay!.year}年 ${calendar.selectedDay!.month}月 ${calendar.selectedDay!.day}日"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              width: double.infinity,
              child: Text(
                '一言メモ',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
              onChanged: (String text) {
                calendar.memo = text;
                // print(calendar.memo);
              },
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  calendar.addCalendarEvent();
                  Navigator.of(context).pop();
                },
                child: const Text(
                  '保存',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
