import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:stomach_ache_app/screens/calendar_page.dart';
import 'package:stomach_ache_app/screens/setting_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/rendering.dart';

void main() {
  // レイアウトのデバッグモード
  debugPaintSizeEnabled = false;
  initializeDateFormatting('ja').then(
    (_) => runApp(
      // riverpod : プロバイダースコープでアプリを囲む
      const ProviderScope(
        child: MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // 開発中のSlow Modeバナーを非表示にする
      debugShowCheckedModeBanner: false,

      // アプリのテーマカラー
      theme: ThemeData(primarySwatch: Colors.teal),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const _screens = [
    CalendarPage(),
    SettingPage(),
  ];

  int _selectedIndex = 0;

  void _onTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: _onTapped,
        currentIndex: _selectedIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month_outlined),
            label: 'カレンダー',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: '設定',
          ),
        ],
      ),
    );
  }
}
