import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

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
          ],
        ),
      ),
    );
  }
}
