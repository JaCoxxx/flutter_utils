import 'package:cached_network_image/cached_network_image.dart';
import 'package:fijkplayer/fijkplayer.dart';
import 'package:flutter/material.dart';

import 'custom_fijk_panel.dart';

/// jacokwu
/// 8/19/21 9:51 AM

class CustomVideoPlay extends StatefulWidget {
  final String url;
  final String? title;
  final String? imageUrl;
  final double height;
  const CustomVideoPlay({Key? key, required this.url, this.title, this.imageUrl, this.height = 200}) : super(key: key);

  @override
  _CustomVideoPlayState createState() => _CustomVideoPlayState();
}

class _CustomVideoPlayState extends State<CustomVideoPlay> {
  FijkPlayer _player = FijkPlayer();

  @override
  void initState() {
    super.initState();
    _player.setDataSource(widget.url, autoPlay: false, showCover: true);
  }

  @override
  void dispose() {
    super.dispose();
    _player.release();
  }

  @override
  Widget build(BuildContext context) {
    return FijkView(
      player: _player,
      height: widget.height,
      width: double.infinity,
      fit: FijkFit.fitWidth,
      fsFit: FijkFit.fitWidth,
      cover: widget.imageUrl == null ? null : CachedNetworkImageProvider(widget.imageUrl!),
      panelBuilder: (player, fijkData, context, size, rect) {
        return CustomFijkPanel(player: player, buildContext: context, viewSize: size, texturePos: rect, title: widget.title,);
      },
    );
  }
}

