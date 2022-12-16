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

    // 選択した日付がイベントリストの中に含まれているかを判定
    calendar.judgePostStatus();

    return Scaffold(
      appBar: AppBar(
        // 選択した日付のテキストを表示
        title: Text(
            // 三項演算子：「新規作成」「編集」どちらを表示するか分ける処理
            "${calendar.selectedDay!.year}年 ${calendar.selectedDay!.month}月 ${calendar.selectedDay!.day}日 ${(calendar.judgePost) ? '編集' : '新規作成'}"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 「痛み」を選択
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
                ToggleButtons(
                  onPressed: calendar.toggleTap,
                  borderWidth: 1,
                  borderColor: Colors.grey[400],
                  borderRadius: BorderRadius.circular(50.0),
                  // 状態がONのボタンの文字色と枠の色
                  selectedColor: Colors.white,
                  selectedBorderColor: Colors.grey[400],
                  // 状態がONのボタンの背景色
                  fillColor: Colors.teal,
                  // ON/OFFの指定（provider）
                  isSelected: calendar.toggleList,
                  // 各ボタン表示の子ウィジェットの指定
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: const [
                          Icon(Icons.sick),
                          Text(
                            'すごく痛い',
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 20,
                      ),
                      child: Column(
                        children: const [
                          Icon(Icons.sentiment_very_dissatisfied),
                          Text(
                            '痛い',
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 20,
                      ),
                      child: Column(
                        children: const [
                          Icon(Icons.sentiment_very_satisfied),
                          Text(
                            '普通',
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 30),

            // 考えられる原因
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
              children: calendar.causes.map((cause) {
                // selectedTags の中に自分がいるかを確かめる
                final causeSelected = calendar.selectedCauses.contains(cause);
                return InkWell(
                  borderRadius: const BorderRadius.all(Radius.circular(32)),
                  onTap: () {
                    calendar.whichCause(cause, causeSelected);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(32)),
                      border: Border.all(
                        width: 1,
                        color: Colors.teal,
                      ),
                      color: causeSelected ? Colors.teal : null,
                    ),
                    child: Text(
                      cause,
                      style: TextStyle(
                        color: causeSelected ? Colors.white : Colors.teal,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 30),

            // メモ
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

            // メモ テキストフィールド
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

            // 保存ボタン
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
