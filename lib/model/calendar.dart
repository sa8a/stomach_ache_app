import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Calendar {
  const Calendar({
    required this.focusedDay,
    required this.selectedDay,
    required this.status,
    required this.memo,
  });

  // イミュータブルなクラスのプロパティはすべて `final` にする
  // final DateTime focusedDay = DateTime.now();
  final DateTime focusedDay;
  final DateTime? selectedDay;
  final String status;
  final String memo;

  // Calendar はイミュータブルであり、内容を直接変更できないためコピーを作る必要がある
  // これはオブジェクトの各プロパティの内容をコピーして新たな Calendar を返すメソッド
  Calendar copyWith({
    DateTime? focusedDay,
    DateTime? selectedDay,
    String? status,
    String? memo,
  }) {
    return Calendar(
      focusedDay: focusedDay ?? this.focusedDay,
      selectedDay: selectedDay ?? this.selectedDay,
      status: status ?? this.status,
      memo: memo ?? this.memo,
    );
  }
}

class CalendarNotifier extends StateNotifier<Map<DateTime, List>> {
  // calendarリストを空のリストとして初期化
  CalendarNotifier() : super({});

  // 未使用
  // DateTime initDay() {
  //   DateTime focusedDay = DateTime.now();
  //   DateTime? selectedDay = focusedDay;
  //   return selectedDay;
  // }

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
}

// 最後に CalendarNotifier のインスタンスを値に持つ StateNotifierProvider を作成し、
// UI 側から calendar リストを操作することを可能に。
final calendarProvider =
    StateNotifierProvider<CalendarNotifier, Map<DateTime, List>>((ref) {
  return CalendarNotifier();
});
