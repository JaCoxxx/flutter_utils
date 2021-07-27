import 'package:bot_toast/bot_toast.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_utils/common/dimens.dart';
import 'package:flutter_utils/utils/request.dart';
import 'package:flutter_utils/widget/custom_scaffold/w_app_bar.dart';
import 'package:get/get.dart';

class VideoListPage extends StatefulWidget {
  const VideoListPage({Key? key}) : super(key: key);

  @override
  _VideoListPageState createState() => _VideoListPageState();
}

class _VideoListPageState extends State<VideoListPage> {
  List videoList = [];

  Map videoItem = {
    'video_files': [],
    'video_pictures': [],
  };

  @override
  void initState() {
    super.initState();
    _getVideoList();
  }

  _getVideoList() async {
    BotToast.showLoading();
    await Dio()
        .get<Map>('https://api.pexels.com/videos/popular?per_page=1',
            options: Options(headers: {
              'Authorization':
                  '563492ad6f917000010000012bf324bd1c894725a2d599a8bacdae12',
            }))
        .then((value) {
          // Map data = value as Map;
      print(value.data);
      videoList.addAll(value.data?['videos'] ?? []);
      videoItem = value.data?['videos'][0];
      setState(() { });
      BotToast.cleanAll();
    }).catchError((err) {
      print(err);
      BotToast.cleanAll();
    });
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
        child: _buildVideoItem(),
      ),
    );
  }

  Widget _buildVideoItem() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('用户信息'),
          Card(
            child: Text(videoItem['user'].toString()),
          ),
          Text('视频文件'),
          Card(
            child: ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              itemCount: videoItem['video_files'].length,
              itemBuilder: (_, index) {
                return Text('${videoItem['video_files'][index]['link']}\n${videoItem['video_files'][index]['quality']}');
              },
              shrinkWrap: true,
            ),
          ),
          Text('视频图片文件'),
          Card(
            child: ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              itemCount: videoItem['video_pictures'].length,
              itemBuilder: (_, index) {
                return Text('${videoItem['video_pictures'][index]['picture']}');
              },
              shrinkWrap: true,
            ),
          ),
          OutlinedButton(
            child: Text('点击播放'),
            onPressed: () {
              Get.toNamed('/video-play', arguments: videoItem['video_files']);
            },
          ),
        ],
      ),
    );
  }
}
