import 'package:flutter/material.dart';
import 'package:flutter_utils/pages/audio_play/request/post_http.dart';
import 'package:flutter_utils/pages/audio_play/widget/album_item_widget.dart';
import 'package:flutter_utils/utils/toast_utils.dart';
import 'package:flutter_utils/widget/refresh_list_widget.dart';

/// jacokwu
/// 9/1/21 3:09 PM

class SearchAlbumWidget extends StatefulWidget {

  final String word;

  const SearchAlbumWidget({Key? key, required this.word}) : super(key: key);

  @override
  _SearchAlbumWidgetState createState() => _SearchAlbumWidgetState();
}

class _SearchAlbumWidgetState extends State<SearchAlbumWidget> {

  int pageNo = 1;
  int pageSize = 15;
  List<Map<String, dynamic>> dataSource = [];

  bool _needRefresh = true;

  Future<List<Map<String, dynamic>>> _fetchList() async {
    return await AudioPostHttp.search(widget.word, pageNo, pageSize, '3').then((value) {
      List<Map<String, dynamic>> fetchList = [];
      if (value['state'] == true) {
        fetchList.addAll(value['data']['typeAlbum'].map<Map<String, dynamic>>((e) => e as Map<String, dynamic>));
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
      itemBuilder: (index, value) => AlbumItemWidget(albumItem: value),
    );
  }
}

