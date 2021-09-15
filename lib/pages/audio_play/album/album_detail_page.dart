import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_utils/common/constants.dart';
import 'package:flutter_utils/common/dimens.dart';
import 'package:flutter_utils/pages/audio_play/bloc/controller_bloc/audio_controller_bloc.dart';
import 'package:flutter_utils/pages/audio_play/config/audio_config.dart';
import 'package:flutter_utils/pages/audio_play/config/audio_play_controller.dart';
import 'package:flutter_utils/pages/audio_play/play/public_bottom_play_widget.dart';
import 'package:flutter_utils/pages/audio_play/request/post_http.dart';
import 'package:flutter_utils/pages/audio_play/widget/music_item_widget.dart';
import 'package:flutter_utils/utils/toast_utils.dart';
import 'package:flutter_utils/utils/utils.dart';
import 'package:flutter_utils/widget/cache_network_image_widget.dart';
import 'package:flutter_utils/widget/custom_scaffold/w_app_bar.dart';
import 'package:flutter_utils/widget/custom_text.dart';
import 'package:flutter_utils/widget/list_item_widget.dart';
import 'package:flutter_utils/widget/sliver/sliver_top_hover_delegate.dart';
import 'package:flutter_utils/widget/widgets.dart';
import 'package:get/get.dart';

/// jacokwu
/// 8/25/21 9:11 AM

class AlbumDetailPage extends StatefulWidget {
  final String albumAssetCode;

  const AlbumDetailPage({Key? key, required this.albumAssetCode}) : super(key: key);

  @override
  _AlbumDetailPageState createState() => _AlbumDetailPageState();
}

class _AlbumDetailPageState extends State<AlbumDetailPage> {
  Map<String, dynamic> _albumInfo = {};

  late AudioPlayController _controller;

  @override
  void initState() {
    super.initState();

    _controller = BlocProvider.of<AudioControllerBloc>(context).state.audioPlayController;
  }

  Future<Map<String, dynamic>> _getAlbumInfo() async {
    return await AudioPostHttp.getAlbumInfo(widget.albumAssetCode).then((value) {
      if (value['state'] == true) {
        _albumInfo = value['data'];
      } else {
        showToast(value['errmsg']);
      }
      return _albumInfo;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WAppBar(
        showDefaultBack: true,
        titleConfig: WAppBarTitleConfig(title: '专辑详情'),
      ),
      backgroundColor: Colors.white,
      body: PublicBottomPlayWidget(
        child: FutureBuilder<Map<String, dynamic>>(
            future: _getAlbumInfo(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return pageLoading(context);
              return CustomScrollView(
                slivers: [
                  SliverPersistentHeader(
                    delegate: SliverTopHoverDelegate(
                        child: _buildHeaderWidget(),
                        childMaxExtent: ScreenUtil().setWidth(330),
                        childMinExtent: ScreenUtil().setWidth(330)),
                  ),
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: SliverTopHoverDelegate(
                        child: _buildTopBarWidget(),
                        childMaxExtent: ScreenUtil().setWidth(100),
                        childMinExtent: ScreenUtil().setWidth(100)),
                  ),
                  SliverSafeArea(
                    top: false,
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (_, index) => MusicItemWidget(
                          musicItem: _albumInfo['trackList'][index],
                          leading: CustomText.content(fillInNum(index + 1)),
                          minLeadingWidth: 26,
                        ),
                        childCount: _albumInfo['trackList'].length,
                      ),
                    ),
                  ),
                ],
              );
            }),
      ),
    );
  }

  Widget _buildHeaderWidget() {
    return GestureDetector(
      onTap: () async {
        AudioConfig.showPageDetailDialog(context,
            pic: _albumInfo['pic'],
            desc: _albumInfo['introduce'],
            isAlbum: true,
            title: _albumInfo['title'],
            tagList: _albumInfo['tagList'] == null ? [] : _albumInfo['tagList'].map<String>((e) => e as String).toList());
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: Dimens.pd15, horizontal: Dimens.pd16),
        child: Row(
          children: [
            Expanded(
              child: Stack(
                children: [
                  Positioned(
                    left: 0,
                    right: 0,
                    top: 5,
                    child: Container(
                      width: ScreenUtil().setWidth(240),
                      height: ScreenUtil().setWidth(240),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                  ),
                  Container(
                      margin: EdgeInsets.only(top: Dimens.pd15),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(6)), color: Constants.backgroundColor),
                      clipBehavior: Clip.antiAlias,
                      child: isStringEmpty(_albumInfo['pic'])
                          ? null
                          : CacheNetworkImageWidget(
                              imageUrl: _albumInfo['pic'],
                              width: ScreenUtil().setWidth(240),
                              height: ScreenUtil().setWidth(240),
                              fit: BoxFit.cover,
                            )),
                ],
              ),
            ),
            Dimens.wGap8,
            Expanded(
              flex: 2,
              child: Container(
                padding: EdgeInsets.only(top: Dimens.pd15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText.title(
                          _albumInfo['title'],
                          fontSize: Dimens.font_size_18,
                        ),
                        Dimens.hGap12,
                        GestureDetector(
                            onTap: () {
                              AudioConfig.getToArtistPage(
                                  context,
                                  _albumInfo['artist']
                                      .map<Map<String, dynamic>>((e) => e as Map<String, dynamic>)
                                      .toList());
                              // Get.toNamed('/artist-detail',arguments: _albumInfo['artist'][0]['artistCode']);
                            },
                            child: CustomText.content('歌手：${_albumInfo['artist'].map((e) => e['name']).join('/')}')),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText.content(
                          '发行时间：${_albumInfo['releaseDate'].toString().substring(0, 10)}',
                          fontSize: Dimens.font_size_12,
                        ),
                        CustomText.content(
                          _albumInfo['introduce'],
                          fontSize: Dimens.font_size_12,
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBarWidget() {
    return Container(
      color: Colors.white,
      child: CustomListItem(
        contentPadding: EdgeInsets.symmetric(horizontal: Dimens.pd16),
        title: Text('播放全部'),
        onTap: () {
          _controller.replacePlayList(
              _albumInfo['trackList']
                  .map<Map<String, dynamic>>((e) => <String, dynamic>{...e, 'TSID': e['assetId']})
                  .toList(),
              null);
        },
        leading: Icon(
          Icons.play_circle_fill_outlined,
          color: Colors.red,
          size: Dimens.font_size_18,
        ),
        trailing: Row(
          children: [
            IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.download_outlined,
                  color: Colors.black,
                  size: Dimens.font_size_18,
                )),
            IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.check_circle_outline,
                  color: Colors.black,
                  size: Dimens.font_size_18,
                )),
          ],
        ),
      ),
    );
  }
}
