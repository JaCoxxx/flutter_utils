import 'package:flutter/material.dart';
import 'package:flutter_utils/common/dimens.dart';
import 'package:flutter_utils/pages/audio_play/request/post_http.dart';
import 'package:flutter_utils/utils/toast_utils.dart';
import 'package:flutter_utils/widget/cache_network_image_widget.dart';
import 'package:flutter_utils/widget/custom_scaffold/w_app_bar.dart';
import 'package:flutter_utils/widget/refresh_grid_widget.dart';

class AudioListPage extends StatefulWidget {
  const AudioListPage({Key? key}) : super(key: key);

  @override
  _AudioListPageState createState() => _AudioListPageState();
}

class _AudioListPageState extends State<AudioListPage> {
  late List<Map<String, dynamic>> _trackList;
  int pageNo = 1;
  int pageSize = 15;
  int total = 0;
  String? subCateId;

  @override
  void initState() {
    super.initState();
    _trackList = [];
  }

  Future<List<Map<String, dynamic>>> _getTrackList() async {
    return await AudioPostHttp.getTrackList(pageNo, pageSize, subCateId).then((value) {
      if (value['state'] == true) {
        if (pageNo == 1) _trackList.clear();
        total = value['data']['total'];
        _trackList.addAll(value['data']['result'].map<Map<String, dynamic>>((e) => e as Map<String, dynamic>));
        setState(() {});
        return value['data']['result'].map<Map<String, dynamic>>((e) => e as Map<String, dynamic>).toList();
      } else {
        showToast(value['errmsg']);
        return [];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WAppBar(
        titleConfig: WAppBarTitleConfig(title: '音乐播放列表'),
        showDefaultBack: true,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: Dimens.pd8, horizontal: Dimens.pd12),
        child: RefreshGridWidget<Map<String, dynamic>>(
          onRefresh: () async {
            pageNo = 1;
            return _getTrackList();
          },
          onLoad: () async {
            pageNo++;
            return _getTrackList();
          },
          dataSource: _trackList,
          childAspectRatio: 0.7,
          mainAxisSpacing: Dimens.pd12,
          crossAxisSpacing: Dimens.pd8,
          itemBuilder: (int index, value) {
            return GestureDetector(
              onTap: () {},
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: CacheNetworkImageWidget(imageUrl: value['pic'])),
                  Dimens.hGap6,
                  Text(
                    value['title'],
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                    style: TextStyle(
                      fontSize: Dimens.font_size_14,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
