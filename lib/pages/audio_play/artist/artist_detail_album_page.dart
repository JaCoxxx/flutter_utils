import 'package:flutter/material.dart';
import 'package:flutter_utils/common/dimens.dart';
import 'package:flutter_utils/pages/audio_play/album/album_detail_page.dart';
import 'package:flutter_utils/pages/audio_play/request/post_http.dart';
import 'package:flutter_utils/pages/audio_play/widget/album_item_widget.dart';
import 'package:flutter_utils/utils/toast_utils.dart';
import 'package:flutter_utils/widget/cache_network_image_widget.dart';
import 'package:flutter_utils/widget/custom_text.dart';
import 'package:flutter_utils/widget/list_item_widget.dart';
import 'package:flutter_utils/widget/refresh_list_widget.dart';
import 'package:get/get.dart';

/// jacokwu
/// 8/27/21 10:57 AM

class ArtistDetailAlbumPage extends StatefulWidget {

  /// 歌手code
  final String artistCode;

  final ScrollController? controller;

  const ArtistDetailAlbumPage({Key? key, required this.artistCode, this.controller}) : super(key: key);

  @override
  _ArtistDetailAlbumPageState createState() => _ArtistDetailAlbumPageState();
}

class _ArtistDetailAlbumPageState extends State<ArtistDetailAlbumPage> with AutomaticKeepAliveClientMixin {
  int pageNo = 1;
  int pageSize = 20;
  List<Map<String, dynamic>> _artistAlbumList = [];

  @override
  void initState() {
    super.initState();
    _getArtistAlbumList();
  }

  Future<List<Map<String, dynamic>>> _getArtistAlbumList() async {
    return await AudioPostHttp.getArtistAlbumList(pageNo, pageSize, widget.artistCode).then((value) {
      List<Map<String, dynamic>> fetchList = [];
      if (value['state'] == true) {
        fetchList.addAll(value['data']['result'].map<Map<String, dynamic>>((e) => e as Map<String, dynamic>));
        if (pageNo == 1)
          _artistAlbumList
            ..clear()
            ..addAll(fetchList.map((e) => e));
      } else {
        showToast(value['errmsg']);
      }
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
          return _getArtistAlbumList();
        },
        dataSource: _artistAlbumList,
        itemBuilder: (index, value) => AlbumItemWidget(albumItem: value, showArtist: false,),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

