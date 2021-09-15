import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_utils/common/constants.dart';
import 'package:flutter_utils/common/dimens.dart';
import 'package:flutter_utils/common/strings.dart';
import 'package:flutter_utils/pages/audio_play/model/lyric_item_model.dart';
import 'package:flutter_utils/pages/audio_play/widget/show_detail_widget.dart';
import 'package:flutter_utils/utils/cache_utils.dart';
import 'package:flutter_utils/utils/utils.dart';
import 'package:flutter_utils/widget/custom_divider.dart';
import 'package:flutter_utils/widget/custom_text.dart';
import 'package:flutter_utils/widget/list_item_widget.dart';
import 'package:flutter_utils/widget/widgets.dart';
import 'package:get/get.dart';

/// jacokwu
/// 8/24/21 3:47 PM

class AudioConfig {
  /// 首页金刚位
  static const List<Map<String, dynamic>> homeTopMenuList = [
    {
      'title': '歌手',
      'key': 'artist',
      'image': 'assets/images/artist.png',
    },
    {
      'title': '分类歌单',
      'key': 'track',
      'image': 'assets/images/tracklist.png',
    },
    {
      'title': '榜单',
      'key': 'top',
      'image': 'assets/images/rankinglist.png',
      'width': 18.0,
    },
  ];

  /// 歌手分类
  static const List<String> artistRegionList = ['全部', '内地', '港台', '欧美', '韩国', '日本', '其他'];

  /// 歌手分类2
  static const List<String> artistGenderList = ['全部', '男', '女', '组合', '乐队'];

  /// 播放方式
  static const List<Map<String, dynamic>> listPlayMode = [
    {
      'key': 'single',
      'title': '单曲循环',
      'icon': Icons.repeat_one,
    },
    {
      'key': 'list',
      'title': '列表循环',
      'icon': Icons.repeat,
    },
    {
      'key': 'random',
      'title': '随机播放',
      'icon': Icons.shuffle,
    },
  ];

  static showBottomCustomSheetDialog(
    BuildContext context, {
    required List<Map<String, dynamic>> menuList,
    required void Function(String) onTap,
    bool needDivider = false,
    bool needCancel = true,
  }) {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
        ),
        backgroundColor: Colors.white,
        builder: (_) {
          return Container(
            padding: EdgeInsets.only(top: Dimens.pd12, bottom: MediaQuery.of(context).padding.bottom),
            clipBehavior: Clip.antiAlias,
            constraints: BoxConstraints(
              minHeight: 100,
              maxHeight: 320,
            ),
            decoration: BoxDecoration(
              color: Constants.backgroundColor,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
            ),
            child: Column(
              children: [
                Expanded(
                  child: MediaQuery.removePadding(
                    context: context,
                    removeTop: true,
                    removeBottom: true,
                    child: ListView.separated(
                      physics: menuList.length > 5 ? BouncingScrollPhysics() : NeverScrollableScrollPhysics(),
                      itemBuilder: (_, index) => CustomListItem(
                        onTap: () {
                          Get.back();
                          onTap(menuList[index]['key']);
                        },
                        title: Padding(
                          padding: const EdgeInsets.symmetric(vertical: Dimens.pd8),
                          child: CustomText.title(menuList[index]['title']),
                        ),
                        leading: menuList[index]['image'] != null
                            ? Image.asset(
                                menuList[index]['image'],
                                width: Dimens.font_size_18,
                              )
                            : menuList[index]['icon'] != null
                                ? Icon(
                                    menuList[index]['icon'],
                                    size: Dimens.font_size_18,
                                    color: Colors.red,
                                  )
                                : null,
                      ),
                      separatorBuilder: (_, index) => needDivider ? CustomDivider() : emptyWidget,
                      itemCount: menuList.length,
                    ),
                  ),
                ),
                Dimens.hGap4,
                if (needCancel)
                  GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: Container(
                        color: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: Dimens.pd12),
                        child: Center(
                            child: Text(
                          '取消',
                          style: TextStyle(
                              color: Colors.black, fontSize: Dimens.font_size_16, fontWeight: FontWeight.w300),
                        ))),
                  ),
              ],
            ),
          );
        });
  }

  static showPageDetailDialog(
    BuildContext context, {
    String? pic,
    required String title,
    String? desc,
    bool isAlbum = false,
        List<String>? tagList,
  }) {
    showDialog(
        context: context,
        useSafeArea: false,
        builder: (_) {
          return ShowDetailWidget(
            pic: pic,
            title: title,
            desc: desc,
            isAlbum: isAlbum,
            tagList: tagList,
          );
        });
  }

  /// 获取歌词列表
  static Map<String, dynamic> getLyricList(String dataSource) {
    List<LyricItemModel> lyricList = [];
    List<String> initialData = dataSource.split('\n');
    bool canScroll = false;
    if (initialData.every((element) => !RegExp(r"^\[\d{2}").hasMatch(element))) {
      // 没有时间轴
      canScroll = false;
      lyricList.add(LyricItemModel(lyric: '*当前歌词不可滚动*'));
      initialData.forEach((element) {
        lyricList.add(LyricItemModel(lyric: element));
      });
    } else {
      canScroll = true;
      initialData.where((element) => RegExp(r"^\[\d{2}").hasMatch(element)).forEach((element) {
        String time = element.substring(0, element.indexOf(']') + 1);
        String lyric = element.substring(element.indexOf(']') + 1);
        time = element.substring(1, time.length - 1);
        int minute = int.parse(time.substring(0, time.indexOf(':')));
        int seconds = 0;
        int milliseconds = 0;
        if (time.indexOf('.') != -1) {
          seconds = int.parse(time.substring(time.indexOf(':') + 1, time.indexOf('.')));
          milliseconds = int.parse(time.substring(time.indexOf('.') + 1));
        } else {
          if (time.substring(time.indexOf(':') + 1).length > 2) {
            seconds = int.parse(time.substring(time.indexOf(':') + 1, time.indexOf(':') + 3));
            milliseconds = int.parse(time.substring(time.indexOf(':') + 3));
          } else {
            seconds = int.parse(time.substring(time.indexOf(':') + 1));
          }
        }

        Duration startTime = Duration(minutes: minute, seconds: seconds, milliseconds: milliseconds);
        int _existIndex =
            lyricList.indexWhere((element) => element.startTime!.inMilliseconds == startTime.inMilliseconds);
        if (_existIndex != -1) {
          lyricList[_existIndex].lyric += '\n$lyric';
        } else {
          lyricList.add(LyricItemModel(startTime: startTime, endTime: startTime, lyric: lyric));
        }
      });
      lyricList.asMap().keys.forEach((element) {
        lyricList[element].endTime = element + 1 > lyricList.length - 1 ? null : lyricList[element + 1].startTime;
      });
    }

    return {
      'canScroll': canScroll,
      'lyricList': lyricList,
    };
  }

  /// 根据当前进度获取当前歌词行
  static int getLyricLineByCurrentPosition(Duration position, List<LyricItemModel> lyricList) {
    int milliseconds = position.inMilliseconds;
    int index = lyricList.indexWhere((element) =>
        element.startTime!.inMilliseconds <= milliseconds &&
        (element.endTime == null || element.endTime!.inMilliseconds > milliseconds));
    return index == -1 ? 0 : index;
  }

  /// 点击歌手名跳转歌手页
  static void getToArtistPage(BuildContext context, List<Map<String, dynamic>> artistList) {
    if (artistList.length == 1) {
      Get.toNamed('/artist-detail', arguments: artistList[0]['artistCode']);
    } else {
      showDialog(
          context: context,
          builder: (_) => Dialog(
                child: Container(
                  height: ((40 + Dimens.pd8 * 2) * artistList.length + 40).toDouble(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          height: 40,
                          padding: EdgeInsets.symmetric(horizontal: Dimens.pd12, vertical: Dimens.pd8),
                          child: CustomText.title('请选择要查看的歌手')),
                      ListView.builder(
                        itemBuilder: (_, index) => CustomListItem(
                          onTap: () {
                            Get
                              ..back()
                              ..toNamed('/artist-detail', arguments: artistList[index]['artistCode']);
                          },
                          title: CustomText.title(artistList[index]['name']),
                          minLeadingWidth: 50,
                          leading: isStringEmpty(artistList[index]['pic'])
                              ? Container(
                                  width: 40,
                                  height: 40,
                                  color: Constants.lightLineColor,
                                )
                              : CachedNetworkImage(
                                  imageUrl: artistList[index]['pic'],
                                  width: 40,
                                  height: 40,
                                ),
                        ),
                        itemCount: artistList.length,
                        shrinkWrap: true,
                      ),
                    ],
                  ),
                ),
              ));
    }
  }

  static saveSearchHistory(List<String> value) async {
    await CacheUtils.remove(Strings.TAIHE_SEARCH_HISTORY);
    await CacheUtils.setStringList(Strings.TAIHE_SEARCH_HISTORY, value);
  }

  static Future<List<String>?> getSearchHistory() async {
    return await CacheUtils.getStringList(Strings.TAIHE_SEARCH_HISTORY);
  }

  static Future<void> savePlayList(String value) async {
    await CacheUtils.remove(Strings.TAIHE_PLAY_LIST);
    await CacheUtils.setString(Strings.TAIHE_PLAY_LIST, value);
  }

  static Future<String?> getPlayList() async {
    return await CacheUtils.getString(Strings.TAIHE_PLAY_LIST);
  }

  static Future<void> removePlayList() async {
    await CacheUtils.remove(Strings.TAIHE_PLAY_LIST);
  }

  static Future<void> saveCurrentPlay(String value) async {
    await CacheUtils.remove(Strings.TAIHE_CURRENT_PLAY);
    await CacheUtils.setString(Strings.TAIHE_CURRENT_PLAY, value);
  }

  static Future<String?> getCurrentPlay() async {
    return await CacheUtils.getString(Strings.TAIHE_CURRENT_PLAY);
  }

  static Future<void> removeCurrentPlay() async {
    await CacheUtils.remove(Strings.TAIHE_CURRENT_PLAY);
  }
}
