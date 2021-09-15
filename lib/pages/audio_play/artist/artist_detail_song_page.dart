import 'package:flutter/material.dart';
import 'package:flutter_utils/common/dimens.dart';
import 'package:flutter_utils/pages/audio_play/request/post_http.dart';
import 'package:flutter_utils/pages/audio_play/widget/music_item_widget.dart';
import 'package:flutter_utils/utils/toast_utils.dart';
import 'package:flutter_utils/utils/utils.dart';
import 'package:flutter_utils/widget/custom_text.dart';
import 'package:flutter_utils/widget/list_item_widget.dart';
import 'package:flutter_utils/widget/refresh_list_widget.dart';

/// jacokwu
/// 8/27/21 10:57 AM

class ArtistDetailSongPage extends StatefulWidget {
  /// 歌手code
  final String artistCode;

  final ScrollController? controller;

  const ArtistDetailSongPage({Key? key, required this.artistCode, this.controller}) : super(key: key);

  @override
  _ArtistDetailSongPageState createState() => _ArtistDetailSongPageState();
}

class _ArtistDetailSongPageState extends State<ArtistDetailSongPage> with AutomaticKeepAliveClientMixin {
  int pageNo = 1;
  int pageSize = 20;
  List<Map<String, dynamic>> _artistSongList = [];

  @override
  void initState() {
    super.initState();
    _getArtistSongList();
  }

  Future<List<Map<String, dynamic>>> _getArtistSongList() async {
    return await AudioPostHttp.getArtistSongList(pageNo, pageSize, widget.artistCode).then((value) {
      List<Map<String, dynamic>> fetchList = [];
      if (value['state'] == true) {
        fetchList.addAll(value['data']['result'].map<Map<String, dynamic>>((e) => e as Map<String, dynamic>));
        if (pageNo == 1)
          _artistSongList
            ..clear()
            ..addAll(fetchList.map((e) => e));
      } else {
        showToast(value['errmsg']);
      }
      setState(() {});
      return fetchList;
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Container(
      child: RefreshListWidget<Map<String, dynamic>>(
        scrollController: widget.controller,
        onLoad: () async {
          pageNo++;
          return _getArtistSongList();
        },
        dataSource: _artistSongList,
        itemBuilder: (index, value) => MusicItemWidget(
          musicItem: value,
          minLeadingWidth: 30,
          leading: CustomText.content((index + 1).toString()),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
