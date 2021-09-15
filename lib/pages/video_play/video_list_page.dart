import 'package:flutter/material.dart';
import 'package:flutter_utils/common/dimens.dart';
import 'package:flutter_utils/pages/video_play/video_play_widget.dart';
import 'package:flutter_utils/widget/custom_scaffold/w_app_bar.dart';

class VideoListPage extends StatefulWidget {
  const VideoListPage({Key? key}) : super(key: key);

  @override
  _VideoListPageState createState() => _VideoListPageState();
}

class _VideoListPageState extends State<VideoListPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WAppBar(
        titleConfig: WAppBarTitleConfig(title: '视频播放'),
        showDefaultBack: true,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: Dimens.pd16),
        child: Center(child: VideoPlayWidget()),
      ),
    );
  }
}
