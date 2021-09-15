import 'package:flutter/material.dart';
import 'package:flutter_utils/common/constants.dart';
import 'package:flutter_utils/common/dimens.dart';
import 'package:flutter_utils/pages/audio_play/request/post_http.dart';
import 'package:flutter_utils/pages/audio_play/widget/music_item_widget.dart';
import 'package:flutter_utils/utils/toast_utils.dart';
import 'package:flutter_utils/utils/utils.dart';
import 'package:flutter_utils/widget/custom_text.dart';
import 'package:flutter_utils/widget/list_item_widget.dart';
import 'package:flutter_utils/widget/refresh_list_widget.dart';

/// jacokwu
/// 8/30/21 1:34 PM

class AudioRefreshWidget extends StatefulWidget {
  final String bdid;
  final ScrollController scrollController;

  const AudioRefreshWidget({Key? key, required this.bdid, required this.scrollController}) : super(key: key);

  @override
  _AudioRefreshWidgetState createState() => _AudioRefreshWidgetState();
}

class _AudioRefreshWidgetState extends State<AudioRefreshWidget> with AutomaticKeepAliveClientMixin {
  int pageNo = 1;
  int pageSize = 20;
  List<Map<String, dynamic>> _fetchList = [];

  Future<List<Map<String, dynamic>>> _getList() async {
    return await AudioPostHttp.getTopList(widget.bdid, pageNo, pageSize).then((value) {
      if (value['state'] == true) {
        return value['data']['result'].map<Map<String, dynamic>>((e) => e as Map<String, dynamic>).toList();
      } else {
        showToast(value['errmsg']);
        return [];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RefreshListWidget<Map<String, dynamic>>(
      scrollController: widget.scrollController,
        dataSource: _fetchList,
        onRefresh: () async {
          pageNo = 1;
          return await _getList();
        },
        onLoad: () async {
          pageNo++;
          return await _getList();
        },
        itemBuilder: (index, value) => MusicItemWidget(musicItem: value, index: index,));
  }

  @override
  bool get wantKeepAlive => true;
}
