import 'package:fijkplayer/fijkplayer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_utils/widget/custom_fijk_video_play/custom_fijk_panel.dart';

/// jacokwu
/// 8/17/21 4:08 PM

class VideoPlayWidget extends StatefulWidget {
  const VideoPlayWidget({Key? key}) : super(key: key);

  @override
  _VideoPlayWidgetState createState() => _VideoPlayWidgetState();
}

class _VideoPlayWidgetState extends State<VideoPlayWidget> {
  FijkPlayer _player = FijkPlayer();

  @override
  void initState() {
    super.initState();
    _player.setDataSource("https://sample-videos.com/video123/flv/240/big_buck_bunny_240p_10mb.flv", autoPlay: true);
  }

  @override
  void dispose() {
    super.dispose();
    _player.release();
  }

  @override
  Widget build(BuildContext context) {
    return FijkView(player: _player, panelBuilder: (player, fijkData, context, size, rect) {
      return CustomFijkPanel(player: player, buildContext: context, viewSize: size, texturePos: rect,);
    },);
  }
}
