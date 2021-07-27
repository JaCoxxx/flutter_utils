import 'package:bot_toast/bot_toast.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_utils/widget/custom_scaffold/w_app_bar.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class VideoPlayPage extends StatefulWidget {
  const VideoPlayPage({Key? key}) : super(key: key);

  @override
  _VideoPlayPageState createState() => _VideoPlayPageState();
}

class _VideoPlayPageState extends State<VideoPlayPage> {
  List data = [];

  late VideoPlayerController _controller;
  late ChewieController _chewieController;

  @override
  void initState() {
    super.initState();
    data = Get.arguments;
    _loadVideo();
  }

  _loadVideo() async {
    BotToast.showLoading();
    print('http://vd3.bdstatic.com/mda-ifvqu9yp3eaqueep/mda-ifvqu9yp3eaqueep.mp4');
    _controller = VideoPlayerController.network('https://jacokwu.cn/images/public/movie.mp4')
      ..initialize().then((_) {
        print('success');
        _chewieController = ChewieController(
          videoPlayerController: _controller,
          autoPlay: true,
          looping: false,
        );
        BotToast.cleanAll();
        setState(() {});
      }).catchError((err) {
        print('err$err');
      });
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    _chewieController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WAppBar(
        titleConfig: WAppBarTitleConfig(
          title: '视频播放',
        ),
      ),
      body: Chewie(
        controller: _chewieController,
      ),
    );
  }
}
