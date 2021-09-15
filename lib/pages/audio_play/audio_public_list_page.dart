import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_utils/common/constants.dart';
import 'package:flutter_utils/common/dimens.dart';
import 'package:flutter_utils/pages/audio_play/play/public_bottom_play_widget.dart';
import 'package:flutter_utils/utils/toast_utils.dart';
import 'package:flutter_utils/widget/cache_network_image_widget.dart';
import 'package:flutter_utils/widget/custom_scaffold/w_app_bar.dart';
import 'package:flutter_utils/widget/list_item_widget.dart';
import 'package:flutter_utils/widget/refresh_list_widget.dart';
import 'package:flutter_utils/widget/widgets.dart';

import 'bloc/controller_bloc/audio_controller_bloc.dart';

/// jacokwu
/// 8/26/21 9:43 AM

class AudioPublicListPage extends StatefulWidget {
  final String title;

  final Future<List<Map<String, dynamic>>> Function(int, int) fetch;

  final void Function(int, Map<String, dynamic>) onTapItem;

  const AudioPublicListPage({Key? key, required this.title, required this.fetch, required this.onTapItem}) : super(key: key);

  @override
  _AudioPublicListPageState createState() => _AudioPublicListPageState();
}

class _AudioPublicListPageState extends State<AudioPublicListPage> {
  int pageNo = 1;
  int pageSize = 15;
  int total = 0;

  List<Map<String, dynamic>> fetchList = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WAppBar(
        titleConfig: WAppBarTitleConfig(title: widget.title),
        showDefaultBack: true,
      ),
      body: PublicBottomPlayWidget(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: Dimens.pd12, horizontal: Dimens.pd16),
              child: TextButton.icon(
                onPressed: () {
                  showToast('暂未开放');
                  // List<Map<String, dynamic>> _list = [];
                  // fetchList.forEach((element) {
                  //   print(element);
                  //   _list.addAll(element['trackList'].map((e) => <String, dynamic>{
                  //     ...e,
                  //     'TSID': e['TSID'] ?? e['assetId']
                  //   }));
                  // });
                  // BlocProvider.of<AudioControllerBloc>(context).state.audioPlayController.replacePlayList(_list, null);
                },
                icon: Icon(
                  Icons.play_arrow,
                  color: Colors.black,
                  size: Dimens.font_size_16,
                ),
                label: Text(
                  '播放全部',
                  style: TextStyle(color: Colors.black, fontSize: Dimens.font_size_12),
                ),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Constants.lightLineColor),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  )),
                  padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: Dimens.pd16)),
                ),
              ),
            ),
            Expanded(
              child: RefreshListWidget<Map<String, dynamic>>(
                onRefresh: () async {
                  pageNo = 1;
                  return widget.fetch(pageNo, pageSize);
                },
                onLoad: () async {
                  pageNo++;
                  return widget.fetch(pageNo, pageSize);
                },
                dataSource: fetchList,
                itemBuilder: (index, value) => CustomListItem(
                  title: Padding(
                    padding: EdgeInsets.symmetric(vertical: Dimens.pd4),
                    child: Text(
                      value['title'],
                      style: TextStyle(fontSize: Dimens.font_size_14),
                    ),
                  ),
                  subtitle: value['artist'] != null
                      ? Padding(
                          padding: EdgeInsets.symmetric(vertical: Dimens.pd4),
                          child: Text(
                            value['artist'].map((e) => e['name']).join('/'),
                            style: TextStyle(fontSize: Dimens.font_size_12),
                          ),
                        )
                      : null,
                  minLeadingWidth: 60,
                  leading: CacheNetworkImageWidget(
                    imageUrl: value['pic'],
                    width: 50,
                    height: 50,
                  ),
                  trailing: value['trackCount'] != null
                      ? Text(
                          '${value['trackCount']}首单曲',
                          style: TextStyle(color: Constants.gray_9, fontSize: Dimens.font_size_12),
                        )
                      : null,
                  onTap: () {
                    widget.onTapItem(index, value);
                  },
                ),
              ),
            ),
            safeAreaBottom(context),
          ],
        ),
      ),
    );
  }
}
