import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class Calendar extends ChangeNotifier {
  // SharedPreferencesの`key`（キー）を設定
  final key = "event_key";

  // 状態を定義・保持
  DateTime focusedDay = DateTime.now();
  DateTime? selectedDay;
  Map<DateTime, List> eventsList = {};
  String eventListEncode = '';
  Map<DateTime, List<dynamic>> eventListDecode = {};
  String memo = '';
  List<bool> toggleList = [false, false, false]; // 「痛み」選択リスト
  String status = ''; // 「痛み」選択したboolをテキストに変換
  bool judgePost = false; // イベントが新規作成なのか編集なのかを判定するための変数

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

  // `getInstance()`は`Future型`を返すため、`async`, `await`をつける
  void initState() async {
    selectedDay = focusedDay;

    // SharedPreferencesオブジェクトの取得
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // 端末に保存されているエンコードしたイベントを取得。
    // なければ「No Data」(null)とする
    eventListEncode = prefs.getString(key) ?? 'No Data';

    // 保存したデータは`String型`のため`Map型`にデコード
    // デコード汎用関数（Map<String, dynamic>→Map<DateTime, dynamic>）
    Map<DateTime, dynamic> decodeMap(Map<String, dynamic> map) {
      Map<DateTime, dynamic> newMap = {};
      map.forEach((key, value) {
        newMap[DateTime.parse(key)] = map[key];
      });
      return newMap;
    }

    // `json.decode`で`String型`を`Map型`に変換
    eventListDecode = Map<DateTime, List<dynamic>>.from(
      decodeMap(
        json.decode(eventListEncode),
      ),
    );

    // デコード確認用
    // print(eventListDecode.runtimeType);
    // print(eventListDecode);

    // イベントリストにデコードしたデータを再代入
    eventsList = eventListDecode;
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

  // `getInstance()`は`Future型`を返すため、`async`, `await`をつける
  void addCalendarEvent() async {
    // 必須：SharedPreferencesオブジェクトの取得
    SharedPreferences prefs = await SharedPreferences.getInstance();

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

    // `setStringList` が `Map型`に対応していないため
    // `Map`=>`String`にエンコードして`String型`として保存
    // エンコード汎用関数（Map<DateTime, dynamic>→Map<String, dynamic>）
    Map<String, dynamic> encodeMap(Map<DateTime, dynamic> map) {
      Map<String, dynamic> newMap = {};
      map.forEach((key, value) {
        newMap[key.toString()] = map[key];
      });
      return newMap;
    }

    // json.encodeでMapをStringへ
    String eventListEncode = json.encode(encodeMap(eventsList));

    // エンコード確認
    // print(eventListEncode.runtimeType);
    // print(eventListEncode);

    // SharedPreferencesで端末に保存
    prefs.setString(key, eventListEncode);

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
    // print(toggleList);

    // 選択したトグルをStringにする
    if (toggleList[0]) {
      status = 'すごく痛い';
    } else if (toggleList[1]) {
      status = '痛い';
    } else if (toggleList[2]) {
      status = '普通';
    }

    // 選択したトグルをStringにして変数statusに代入
    // print(status);

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

  // カレンダーの日付に表示されるテキストをアイコンに変更
  // カレンダーのモーダルに表示されるテキストをアイコンに変更
  Widget todayStatus(String setStatus) {
    if (setStatus == 'すごく痛い') {
      return Icon(
        Icons.sick,
        color: Colors.red[300],
        size: 25,
      );
    } else if (setStatus == '痛い') {
      return Icon(
        Icons.sentiment_very_dissatisfied,
        color: Colors.orange[300],
        size: 25,
      );
    } else if (setStatus == '普通') {
      return Icon(
        Icons.sentiment_very_satisfied,
        color: Colors.green[300],
        size: 25,
      );
    } else {
      return const Text('---');
    }
  }

  // `getInstance()`は`Future型`を返すため、`async`, `await`をつける
  void deleteCalendarEvent() async {
    // 必須：SharedPreferencesオブジェクトの取得
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // `eventsList` の初期化と保存されているデータを削除
    eventsList = {};
    prefs.remove(key);
  }

  void judgePostStatus() {
    // 選択した日付がイベントリストの中に含まれているかを判定
    // print(selectedDay);
    // print(eventsList.containsKey(selectedDay));

    // true or false を再代入
    judgePost = eventsList.containsKey(selectedDay);
  }
}

// ChangeNotifierProviderを定義
final calendarProvider = ChangeNotifierProvider((ref) => Calendar());
