import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Calendar extends ChangeNotifier {
  // 状態を定義・保持
  DateTime focusedDay = DateTime.now();
  DateTime? selectedDay;
  Map<DateTime, List> eventsList = {};
  String memo = '';
  List<bool> toggleList = [false, false, false]; // 「痛み」選択リスト
  String status = ''; // 「痛み」選択したboolをテキストに変換

// 原因の初期リスト
  List<String> causes = [
    '緊張',
    '寒い',
    '気疲れ',
    '疲れ',
    '通勤・通学',
    'ストレス',
    '人混み',
    '空腹',
    '睡眠不足',
    '寝過ぎ'
  ];

  // 選択された原因を格納
  List<String> selectedCauses = [];

  // 以下は状態を操作するメソッド
  // `notifyListeners();` で状態（変数）の変化を通知し、
  // 変数を使用しているWidgetの再構築が行われる

  void initState() {
    selectedDay = focusedDay;
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
          'status': status,
          'causes': selectedCauses,
          'memo': memo,
        }
      ]
    });

    // 値が残るのでリセット
    toggleList = [false, false, false];
    selectedCauses = [];
    memo = '';

    // リスト追加後のリスト確認
    // print(eventsList);

    notifyListeners();
  }

  // トグルボタンを押下する時の切り替え処理
  // ボタンが押されたときの処理（1つだけを選択させる）
  void toggleTap(int index) {
    for (int buttonIndex = 0; buttonIndex < toggleList.length; buttonIndex++) {
      if (buttonIndex == index) {
        toggleList[buttonIndex] = true;
      } else {
        toggleList[buttonIndex] = false;
      }
    }

    // トグルボタンのbool状態を確認
    print(toggleList);

    // 選択したトグルをStringにする
    if (toggleList[0]) {
      status = 'すごく痛い';
    } else if (toggleList[1]) {
      status = '痛い';
    } else if (toggleList[2]) {
      status = '普通';
    }

    // 選択したトグルをStringにして変数statusに代入
    print(status);

    notifyListeners();
  }

  // 原因を選択する処理
  void whichCause(cause, causeSelected) {
    if (causeSelected) {
      // すでに選択されていれば取り除く
      selectedCauses.remove(cause);
    } else {
      // 選択されていなければ追加する
      selectedCauses.add(cause);
    }
    notifyListeners();
  }
}

// ChangeNotifierProviderを定義
final calendarProvider = ChangeNotifierProvider((ref) => Calendar());
