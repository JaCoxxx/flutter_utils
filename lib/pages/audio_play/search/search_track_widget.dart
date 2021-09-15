import 'package:flutter/material.dart';
import 'package:flutter_utils/pages/audio_play/request/post_http.dart';
import 'package:flutter_utils/pages/audio_play/widget/music_item_widget.dart';
import 'package:flutter_utils/utils/toast_utils.dart';
import 'package:flutter_utils/widget/refresh_list_widget.dart';

/// jacokwu
/// 9/1/21 3:09 PM

class SearchTrackWidget extends StatefulWidget {

  final String word;

  const SearchTrackWidget({Key? key, required this.word}) : super(key: key);

  @override
  _SearchTrackWidgetState createState() => _SearchTrackWidgetState();
}

class _SearchTrackWidgetState extends State<SearchTrackWidget> {

  int pageNo = 1;
  int pageSize = 15;
  List<Map<String, dynamic>> dataSource = [];

  bool _needRefresh = true;

  Future<List<Map<String, dynamic>>> _fetchList() async {
    return await AudioPostHttp.search(widget.word, pageNo, pageSize, '1').then((value) {
      List<Map<String, dynamic>> fetchList = [];
      if (value['state'] == true) {
        fetchList.addAll(value['data']['typeTrack'].map<Map<String, dynamic>>((e) => e as Map<String, dynamic>));
      } else {
        showToast(value['errmsg']);
      }
      _needRefresh = false;
      setState(() { });
      return fetchList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshListWidget<Map<String, dynamic>>(
      firstRefresh: true,
      onRefresh: _needRefresh ? () async {
        pageNo = 1;
        return await _fetchList();
      } : null,
      onLoad: () async {
        pageNo ++;
        return await _fetchList();
      },
      dataSource: dataSource,
      itemBuilder: (index, value) => MusicItemWidget(musicItem: value),
    );
  }
}

