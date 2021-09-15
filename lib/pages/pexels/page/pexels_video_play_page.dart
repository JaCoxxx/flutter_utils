import 'package:cached_network_image/cached_network_image.dart';
import 'package:fijkplayer/fijkplayer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_utils/common/dimens.dart';
import 'package:flutter_utils/common/model/pexels_video_model.dart';
import 'package:flutter_utils/widget/custom_fijk_video_play/custom_fijk_panel.dart';
import 'package:flutter_utils/widget/custom_fijk_video_play/custom_video_play.dart';
import 'package:flutter_utils/widget/custom_scaffold/w_app_bar.dart';
import 'package:flutter_utils/widget/list_item_widget.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

/// jacokwu
/// 8/18/21 3:33 PM

class PexelsVideoPlayPage extends StatefulWidget {
  final PexelsVideoModel videoModel;

  const PexelsVideoPlayPage({Key? key, required this.videoModel}) : super(key: key);

  @override
  _PexelsVideoPlayPageState createState() => _PexelsVideoPlayPageState();
}

class _PexelsVideoPlayPageState extends State<PexelsVideoPlayPage> {
  FijkPlayer _player = FijkPlayer();

  @override
  void initState() {
    super.initState();
    _player.setDataSource(widget.videoModel.videoFiles[0].link, autoPlay: false, showCover: true);
  }

  @override
  void dispose() {
    super.dispose();
    _player.release();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomVideoPlay(
              url: widget.videoModel.videoFiles[0].link,
              imageUrl: widget.videoModel.image,
            ),
            Dimens.hGap12,
            CustomListItem(
              leading: Icon(FontAwesomeIcons.user),
              title: Text('${widget.videoModel.user.name}'),
              subtitle: Text('${widget.videoModel.user.url}'),
              trailing: TextButton(onPressed: () {
                launch(widget.videoModel.user.url);
              }, child: Text('前往'),),
            ),
          ],
        ),
      ),
    );
  }
}
