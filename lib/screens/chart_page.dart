import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stomach_ache_app/model/calendar.dart';

class ChartPage extends ConsumerWidget {
  const ChartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Providerを読み取る。watchを使用しているので、
    // `Calendar` の状態が更新されると、buildメソッドが再実行され、画面が更新される
    final calendar = ref.watch(calendarProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('グラフ'),
      ),
      body: Center(
        child: PieChart(
          PieChartData(
            // 開始位置を12時方向にするためにはstartDegreeOffsetを指定
            // デフォルトだと3時の方向なので、値は270や-90など開始位置から90度反時計回りに
            startDegreeOffset: 270,
            centerSpaceRadius: 50, // くり抜き
            sectionsSpace: 0,
            sections: [
              PieChartSectionData(
                borderSide: const BorderSide(color: Colors.black, width: 0),
                color: Colors.green,
                value: 2 / 24 * 100,
                titlePositionPercentageOffset: 0.5,
                title: "普通",
                titleStyle: const TextStyle(fontSize: 18, color: Colors.white),
                radius: 120,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          // 1. 月の日付数を算出する
          // 2. 痛みの種類別に数を算出する

          print(calendar.eventsList);
        },
      ),
    );
  }
}
