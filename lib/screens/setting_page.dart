import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'package:stomach_ache_app/model/calendar.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                showDialog<void>(
                  context: context,
                  builder: (_) {
                    return const DeleteAlertDialog();
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// 削除時のポップアップ
class DeleteAlertDialog extends StatelessWidget {
  const DeleteAlertDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) => AlertDialog(
        title: const Text('本当に削除しますか？'),
        content: const Text('削除するとカレンダーのデータが全て消えます。\nこの変更は戻せません。'),
        actions: [
          TextButton(
            child: const Text('いいえ'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          TextButton(
            child: const Text('はい'),
            onPressed: () {
              ref.watch(calendarProvider).deleteCalendarEvent();
              Navigator.pop(context);
            },
          )
        ],
      ),
    );
  }
}
