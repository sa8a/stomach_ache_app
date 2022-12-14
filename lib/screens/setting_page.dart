import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'package:stomach_ache_app/model/calendar.dart';

class SettingPage extends ConsumerWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final calendar = ref.watch(calendarProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('設定'),
      ),
      body: Center(
        child: ListView(
          children: [
            ListTile(
              leading: const Icon(Icons.share),
              title: const Text('このアプリをシェア'),
              trailing: const Icon(Icons.keyboard_arrow_right_rounded),
              onTap: () {
                Share.share('共有');
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text('カレンダーのデータを削除する'),
              trailing: const Icon(Icons.keyboard_arrow_right_rounded),
              onTap: () {
                calendar.deleteCalendarEvent();
              },
            ),
          ],
        ),
      ),
    );
  }
}
