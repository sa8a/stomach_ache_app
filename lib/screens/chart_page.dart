import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class ChartPage extends StatelessWidget {
  const ChartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                color: Colors.red,
                value: 2 / 24 * 100,
                titlePositionPercentageOffset: 0.5,
                title: "サンプル\nサンプル",
                titleStyle: const TextStyle(fontSize: 16, color: Colors.white),
                radius: 120,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
