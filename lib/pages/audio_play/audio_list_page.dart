import 'package:flutter/material.dart';
import 'package:flutter_utils/widget/custom_scaffold/w_app_bar.dart';

class AudioListPage extends StatefulWidget {
  const AudioListPage({Key? key}) : super(key: key);

  @override
  _AudioListPageState createState() => _AudioListPageState();
}

class _AudioListPageState extends State<AudioListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WAppBar(
        titleConfig: WAppBarTitleConfig(title: '音乐播放列表'),
      ),
    );
  }
}
