import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Calendar extends ChangeNotifier {
  // 状態を定義・保持
  DateTime focusedDay = DateTime.now();
  DateTime? selectedDay;
  Map<DateTime, List> eventsList = {};
  String memo = '';

  // 以下は状態を操作するメソッド
  // `notifyListeners();` で状態（変数）の変化を通知し、
  // 変数を使用しているWidgetの再構築が行われる

  void initState() {
    selectedDay = focusedDay;
    eventsList = {
      DateTime.now().subtract(const Duration(days: 2)): [
        'Event A6',
        'Event B6'
      ],
      // DateTime.now(): ['Event A7', 'Event B7', 'Event C7', 'Event D7'],
    };
  }

  // DateTime型から20210930の8桁のint型へ変換
  int getHashCode(DateTime key) {
    return key.day * 1000000 + key.month * 10000 + key.year;
  }

  // 土（青）日（赤）に色をつける関数
  Color textColor(DateTime day) {
    const defaultTextColor = Colors.black87;

    if (day.weekday == DateTime.sunday) {
      return Colors.red;
    }
    if (day.weekday == DateTime.saturday) {
      return Colors.blue[600]!;
    }
    return defaultTextColor;
  }

  void addCalendarEvent() {
    // カレンダーにイベントを追加
    eventsList.addAll({
      selectedDay!: [
        {
          'memo': memo,
        }
      ]
    });

    // 値が残るのでリセット
    memo = '';

    // リスト追加後のリスト確認
    print(eventsList);

    notifyListeners();
  }
}

// ChangeNotifierProviderを定義
final calendarProvider = ChangeNotifierProvider((ref) => Calendar());
