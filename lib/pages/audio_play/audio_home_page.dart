import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_utils/common/constants.dart';
import 'package:flutter_utils/common/dimens.dart';
import 'package:flutter_utils/pages/audio_play/audio_public_list_page.dart';
import 'package:flutter_utils/pages/audio_play/bloc/controller_bloc/audio_controller_bloc.dart';
import 'package:flutter_utils/pages/audio_play/config/audio_play_controller.dart';
import 'package:flutter_utils/pages/audio_play/tracklist/category_list_page.dart';
import 'package:flutter_utils/pages/audio_play/config/audio_config.dart';
import 'package:flutter_utils/pages/audio_play/request/post_http.dart';
import 'package:flutter_utils/pages/audio_play/tracklist/track_detail_page.dart';
import 'package:flutter_utils/pages/audio_play/play/public_bottom_play_widget.dart';
import 'package:flutter_utils/utils/toast_utils.dart';
import 'package:flutter_utils/utils/utils.dart';
import 'package:flutter_utils/widget/cache_network_image_widget.dart';
import 'package:flutter_utils/widget/custom_scaffold/search_app_bar.dart';
import 'package:flutter_utils/widget/list_item_widget.dart';
import 'package:flutter_utils/widget/slide_widget.dart';
import 'package:flutter_utils/widget/widgets.dart';
import 'package:get/get.dart';

import 'album/album_detail_page.dart';
import 'search/audio_search_page.dart';
import 'model/track_list_model.dart';

/// jacokwu
/// 8/25/21 9:08 AM

class AudioHomePage extends StatefulWidget {
  const AudioHomePage({Key? key}) : super(key: key);

  @override
  _AudioHomePageState createState() => _AudioHomePageState();
}

class _AudioHomePageState extends State<AudioHomePage> {
  int pageNo = 1;
  int pageSize = 50;

  /// 最新专辑
  List _newAlbumList = [];

  /// 推荐歌单
  List _recommendTrackList = [];

  /// 歌单流派列表
  List _tracklistTagList = [];

  /// 推荐歌手列表
  List _recommendArtistList = [];

  /// 新歌列表
  List _newSongList = [];

  /// 精选视频
  List _recommendVideoList = [];

  late AudioPlayController _controller;


  @override
  void initState() {
    super.initState();
    _initData();
  }

  _initData() async {
    _getHomeData();
    _controller = BlocProvider.of<AudioControllerBloc>(context).state.audioPlayController..init();
  }

  Future<List> _getBannerList() async {
    // await Future.delayed(Duration(milliseconds: 3000));
    // return [
    //   {
    //     'pic': 'https://jacokwu.cn/images/public/background.jpg',
    //   },
    //   {
    //     'pic': 'https://jacokwu.cn/images/public/background.png',
    //   },
    // ];
    return await AudioPostHttp.getBannerList().then((value) {
      if (value['state'] == true) {
        return value['data']['result'];
      } else {
        showToast(value['errmsg']);
        return [];
      }
    });
  }

  _getHomeData() async {
    return await AudioPostHttp.getHomeData().then((value) {
      if (value['state'] == true) {
        List<Map<String, dynamic>> _homeData =
            value['data'].map<Map<String, dynamic>>((e) => e as Map<String, dynamic>).toList();
        _newAlbumList
          ..clear()
          ..addAll(_homeData
              .firstWhere((element) => element['type'] == 'album', orElse: () => {'result': []})['result']
              .map((e) => e));

        _recommendTrackList
          ..clear()
          ..addAll(_homeData
              .firstWhere((element) => element['type'] == 'tracklist', orElse: () => {'result': []})['result']
              .map((e) => e));

        _tracklistTagList
          ..clear()
          ..addAll(_homeData
              .firstWhere((element) => element['type'] == 'tracklist_tag', orElse: () => {'result': []})['result']
              .map((e) => e));

        _recommendArtistList
          ..clear()
          ..addAll(_homeData
              .firstWhere((element) => element['type'] == 'artist', orElse: () => {'result': []})['result']
              .map((e) => e));

        _newSongList
          ..clear()
          ..addAll(_homeData
              .firstWhere((element) => element['type'] == 'song', orElse: () => {'result': []})['result']
              .map((e) => e));

        _recommendVideoList
          ..clear()
          ..addAll(_homeData
              .firstWhere((element) => element['type'] == 'video', orElse: () => {'result': []})['result']
              .map((e) => e));
        setState(() {});
      } else {
        showToast(value['errmsg']);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SearchAppBar(
        searchHint: '周杰伦',
        onSearchBoxTap: () {
          Get.toNamed('/audio-search');
        },
      ),
      body: PublicBottomPlayWidget(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: Dimens.pd12),
          color: Color(0xFFFEFEFE),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildBanner(),
                Dimens.hGap16,
                _buildTopMenuList(),
                Dimens.hGap16,
                _buildNewAlbumWidget(),
                Dimens.hGap16,
                _buildRecommendTrackListWidget(),
                Dimens.hGap16,
                _buildCategoryCardWidget(),
                Dimens.hGap16,
                _buildRecommendArtistWidget(),
                Dimens.hGap16,
                _buildNewSongWidget(),
                Dimens.hGap16,
                _buildRecommendVideoWidget(),
                Dimens.hGap16,
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBanner() {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
      child: SlideWidget(
        getList: _getBannerList,
        urlKey: 'pic',
        height: ScreenUtil().setWidth(280),
        fit: BoxFit.fitWidth,
        paginationBuilder: CustomSwiperPaginationBuilder(
          size: Size(20, 10),
          activeSize: Size(20, 10),
        ),
        onTap: (index, value) {
          switch(value['jumpType']) {
            case '1':
              break;
            case '2':
              Get.to(AlbumDetailPage(albumAssetCode: value['jumpLinkOutput']));
              break;
            case '3':
              Get.to(TrackDetailPage(trackId: value['jumpLinkOutput']));
              break;
            default:break;
          }
        },
      ),
    );
  }

  Widget _buildTopMenuList() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ...AudioConfig.homeTopMenuList.map<Widget>((e) => GestureDetector(
              onTap: () {
                switch (e['key']) {
                  case 'track':
                    Get.to(CategoryListPage());
                    break;
                  case 'artist':
                    Get.toNamed('/artist-list');
                    break;
                  case 'top':
                    Get.toNamed('/audio-top');
                    break;
                  default:
                    break;
                }
              },
              child: Column(
                children: [
                  CircleAvatar(
                    child: Image.asset(
                      e['image'],
                      width: e['width'] ?? 22,
                    ),
                    backgroundColor: Color(0xFFFCF0F5),
                    foregroundColor: Colors.red,
                  ),
                  Dimens.hGap6,
                  Text(
                    e['title'],
                    style: TextStyle(fontSize: Dimens.font_size_14),
                  ),
                ],
              ),
            )),
      ],
    );
  }

  Widget _buildNewAlbumWidget() {
    return _buildHomeCardWidget(
      '最新专辑',
      () {
        Get.to(AudioPublicListPage(
          title: '最新专辑',
          fetch: (pageNo, pageSize) async {
            return await AudioPostHttp.getNewAlbumList(pageNo, pageSize).then((value) {
              if (value['state'] == true) {
                return value['data']['result'].map<Map<String, dynamic>>((e) => e as Map<String, dynamic>).toList();
              } else {
                showToast(value['errmsg']);
                return [];
              }
            });
          },
          onTapItem: (int index, Map<String, dynamic> value) {
            Get.to(AlbumDetailPage(
              albumAssetCode: value['albumAssetCode'],
            ));
          },
        ));
      },
      _buildRowListWidget(
          (index) => GestureDetector(
                onTap: () {
                  Get.to(AlbumDetailPage(
                    albumAssetCode: _newAlbumList[index]['albumAssetCode'],
                  ));
                },
                child: Container(
                  width: ScreenUtil().setWidth(280),
                  padding: EdgeInsets.only(left: index == 0 ? 0 : Dimens.pd12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CacheNetworkImageWidget(
                        imageUrl: _newAlbumList[index]['pic'],
                        width: ScreenUtil().setWidth(280),
                        height: ScreenUtil().setWidth(280),
                        fit: BoxFit.fill,
                      ),
                      Dimens.hGap12,
                      Text(
                        _newAlbumList[index]['title'],
                        style:
                            TextStyle(color: Colors.black, fontSize: Dimens.font_size_12, fontWeight: FontWeight.w600),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Dimens.hGap6,
                      Text(
                        _newAlbumList[index]['artist'].map((e) => e['name']).join('/'),
                        style: TextStyle(
                            color: Constants.black_3, fontSize: Dimens.font_size_12, fontWeight: FontWeight.w300),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
          _newAlbumList.length),
    );
  }

  Widget _buildRecommendTrackListWidget() {
    return _buildHomeCardWidget('推荐歌单', () {
      Get.to(AudioPublicListPage(
        title: '推荐歌单',
        fetch: (pageNo, pageSize) async {
          return await AudioPostHttp.getTrackList(pageNo, pageSize, null).then((value) {
            if (value['state'] == true) {
              return value['data']['result'].map<Map<String, dynamic>>((e) => e as Map<String, dynamic>).toList();
            } else {
              showToast(value['errmsg']);
              return [];
            }
          });
        },
        onTapItem: (int index, Map<String, dynamic> value) {
          Get.to(TrackDetailPage(trackId: value['id'].toString()));
        },
      ));
    },
        _buildRowListWidget(
            (index) => GestureDetector(
                  onTap: () {
                    Get.to(TrackDetailPage(trackId: _recommendTrackList[index]['id'].toString()));
                  },
                  child: Container(
                    width: ScreenUtil().setWidth(280),
                    padding: EdgeInsets.only(left: index == 0 ? 0 : Dimens.pd12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CacheNetworkImageWidget(
                          imageUrl: _recommendTrackList[index]['pic'],
                          width: ScreenUtil().setWidth(280),
                          height: ScreenUtil().setWidth(280),
                          fit: BoxFit.fill,
                        ),
                        Dimens.hGap12,
                        Text(
                          _recommendTrackList[index]['title'],
                          style: TextStyle(
                              color: Colors.black, fontSize: Dimens.font_size_12, fontWeight: FontWeight.w600),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Dimens.hGap6,
                        Text(
                          '${_recommendTrackList[index]['trackCount']}首单曲',
                          style: TextStyle(
                              color: Constants.black_3, fontSize: Dimens.font_size_12, fontWeight: FontWeight.w300),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
            _recommendTrackList.length));
  }

  Widget _buildCategoryCardWidget() {
    return _buildHomeCardWidget('流派歌单', () {
      Get.to(CategoryListPage());
    },
        Wrap(
          spacing: 10,
          children: List.generate(
            _tracklistTagList.length,
            (index) => GestureDetector(
              onTap: () {
                Get.to(AudioPublicListPage(
                  title: _tracklistTagList[index]['categoryName'],
                  fetch: (pageNo, pageSize) async {
                    return await AudioPostHttp.getTrackList(pageNo, pageSize, _tracklistTagList[index]['categoryId'])
                        .then((value) {
                      if (value['state'] == true) {
                        return value['data']['result']
                            .map<Map<String, dynamic>>((e) => e as Map<String, dynamic>)
                            .toList();
                      } else {
                        showToast(value['errmsg']);
                        return [];
                      }
                    });
                  },
                  onTapItem: (int index, Map<String, dynamic> value) {
                    Get.to(TrackDetailPage(trackId: value['categoryId'].toString()));
                  },
                ));
              },
              child: Chip(
                labelPadding: EdgeInsets.symmetric(horizontal: Dimens.pd25),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                label: Text(
                  _tracklistTagList[index]['categoryName'],
                  style: TextStyle(color: Constants.gray_9, fontSize: Dimens.font_size_14),
                ),
                backgroundColor: Constants.backgroundColor,
              ),
            ),
          ),
        ));
  }

  Widget _buildRecommendArtistWidget() {
    return _buildHomeCardWidget('推荐歌手', () {
      Get.toNamed('/artist-list');
    },
        _buildRowListWidget(
            (index) => GestureDetector(
                  onTap: () {
                    Get.toNamed('/artist-detail', arguments: _recommendArtistList[index]['artistCode']);
                  },
                  child: Container(
                    height: ScreenUtil().setWidth(360),
                    child: Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                      elevation: 4,
                      shadowColor: Constants.lightLineColor,
                      margin: EdgeInsets.only(left: index == 0 ? 0 : Dimens.pd12),
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: Dimens.pd8, horizontal: Dimens.pd20),
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: ScreenUtil().setWidth(70),
                              child: emptyWidget,
                              backgroundImage: CachedNetworkImageProvider(_recommendArtistList[index]['pic']),
                            ),
                            Dimens.hGap8,
                            Text(_recommendArtistList[index]['name']),
                            Dimens.hGap4,
                            Text(
                              '${unitConverter(_recommendArtistList[index]['favoriteCount'])}人已收藏',
                              style: TextStyle(color: Constants.gray_8e, fontSize: Dimens.font_size_12),
                            ),
                            TextButton(
                              onPressed: () {
                                showToast('暂不支持');
                              },
                              child: Text('收藏'),
                              style: ButtonStyle(
                                textStyle: MaterialStateProperty.all(
                                    TextStyle(color: Colors.white, fontSize: Dimens.font_size_12)),
                                backgroundColor: MaterialStateProperty.all(Colors.black),
                                foregroundColor: MaterialStateProperty.all(Colors.white),
                                padding: MaterialStateProperty.all(EdgeInsets.all(1)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
            _recommendArtistList.length));
  }

  Widget _buildNewSongWidget() {
    return _buildHomeCardWidget(
        '新歌推荐',
        () {},
        _buildRowListWidget((index) {
          int cIndex = index * 3;
          return Container(
            width: ScreenUtil().setWidth(600),
            padding: EdgeInsets.only(left: index == 0 ? 0 : Dimens.pd12),
            child: Column(
              children: _newSongList
                  .sublist(cIndex, cIndex + 3)
                  .map(
                    (e) => Expanded(
                      child: CustomListItem(
                        title: Text(
                          e['title'],
                          style: TextStyle(fontSize: Dimens.font_size_14),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text(
                          e['albumTitle'],
                          style: TextStyle(fontSize: Dimens.font_size_12),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        minLeadingWidth: 50,
                        leading: CacheNetworkImageWidget(
                          imageUrl: e['pic'],
                          width: 40,
                          height: 40,
                          memCacheWidth: 40,
                          memCacheHeight: 40,
                          fit: BoxFit.fitWidth,
                        ),
                        trailing: IconButton(
                            onPressed: () {
                              _controller.replacePlayList(_newSongList.map<Map<String, dynamic>>((e) => e as Map<String, dynamic>).toList(), e['TSID']);
                            },
                            icon: Icon(
                              Icons.play_arrow,
                              color: Colors.black,
                            )),
                      ),
                    ),
                  )
                  .toList(),
            ),
          );
        }, (_newSongList.length / 3).floor()));
  }

  Widget _buildRecommendVideoWidget() {
    return _buildHomeCardWidget(
        '精选视频',
        () {},
        _buildRowListWidget(
            (index) => Container(
                  width: ScreenUtil().setWidth(500),
                  padding: EdgeInsets.only(left: index == 0 ? 0 : Dimens.pd12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CacheNetworkImageWidget(
                        imageUrl: _recommendVideoList[index]['pic'],
                        width: ScreenUtil().setWidth(500),
                        height: ScreenUtil().setWidth(260),
                        fit: BoxFit.cover,
                      ),
                      Dimens.hGap12,
                      Text(
                        _recommendVideoList[index]['title'],
                        style:
                            TextStyle(color: Colors.black, fontSize: Dimens.font_size_12, fontWeight: FontWeight.w600),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Dimens.hGap6,
                      Text(
                        _recommendVideoList[index]['artist'].map((e) => e['name']).join('/'),
                        style: TextStyle(
                            color: Constants.black_3, fontSize: Dimens.font_size_12, fontWeight: FontWeight.w300),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
            _recommendVideoList.length));
  }

  Widget _buildHomeCardWidget(String title, VoidCallback onTap, Widget content) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(color: Colors.black, fontSize: Dimens.font_size_18, fontWeight: FontWeight.w600),
            ),
            TextButton(
                onPressed: onTap,
                child: Text(
                  '更多',
                  style: TextStyle(color: Colors.black, fontSize: Dimens.font_size_12, fontWeight: FontWeight.w300),
                )),
          ],
        ),
        content,
      ],
    );
  }

  Widget _buildRowListWidget(Widget Function(int) itemBuilder, int length) {
    return Container(
      height: ScreenUtil().setWidth(380),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(length, itemBuilder),
        ),
      ),
    );
  }
}
