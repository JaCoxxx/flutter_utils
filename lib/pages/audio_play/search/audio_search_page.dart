import 'package:flutter/material.dart';
import 'package:flutter_utils/common/constants.dart';
import 'package:flutter_utils/common/dimens.dart';
import 'package:flutter_utils/pages/audio_play/config/audio_config.dart';
import 'package:flutter_utils/pages/audio_play/play/public_bottom_play_widget.dart';
import 'package:flutter_utils/pages/audio_play/request/post_http.dart';
import 'package:flutter_utils/pages/audio_play/search/search_album_widget.dart';
import 'package:flutter_utils/pages/audio_play/search/search_artist_widget.dart';
import 'package:flutter_utils/pages/audio_play/search/search_track_widget.dart';
import 'package:flutter_utils/pages/audio_play/widget/album_item_widget.dart';
import 'package:flutter_utils/pages/audio_play/widget/artist_item_widget.dart';
import 'package:flutter_utils/pages/audio_play/widget/music_item_widget.dart';
import 'package:flutter_utils/utils/toast_utils.dart';
import 'package:flutter_utils/utils/utils.dart';
import 'package:flutter_utils/widget/custom_scaffold/search_app_bar.dart';
import 'package:flutter_utils/widget/custom_scaffold/search_bar_controller.dart';
import 'package:flutter_utils/widget/custom_scaffold/w_tab_bar.dart';
import 'package:flutter_utils/widget/custom_text.dart';
import 'package:flutter_utils/widget/list_item_widget.dart';
import 'package:flutter_utils/widget/widgets.dart';
import 'package:get/get.dart';

/// jacokwu
/// 8/25/21 9:20 AM

class AudioSearchPage extends StatefulWidget {
  const AudioSearchPage({Key? key}) : super(key: key);

  @override
  _AudioSearchPageState createState() => _AudioSearchPageState();
}

class _AudioSearchPageState extends State<AudioSearchPage> with TickerProviderStateMixin {
  late SearchBarController _controller;
  late TabController _tabController;

  String? _searchValue;
  bool _hasValue = false;
  bool _hasFocus = false;

  bool _hasResult = false;

  List<String>? _searchHistoryList;
  List<String> _searchSugList = [];

  List<String> _displayOrder = [];

  List<Map<String, dynamic>> _trackList = [];
  List<Map<String, dynamic>> _artistList = [];
  List<Map<String, dynamic>> _albumList = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _controller = SearchBarController()
      ..addListener(() {
        _hasFocus = _controller.isFocus;
        _hasValue = _controller.hasValue;
        if (_searchValue != _controller.value && _controller.value.isNotEmpty) {
          _searchValue = _controller.value;
          _getSearchSugList();
        }
      });
    _getSearchHistory();
  }

  _getSearchHistory() async {
    _searchHistoryList = await AudioConfig.getSearchHistory();
    setState(() {});
  }

  _saveSearchHistory() {
    print(_searchValue);
    if (_searchHistoryList == null) _searchHistoryList = [];
    if (!_searchHistoryList!.contains(_searchValue!)) {
      _searchHistoryList!.insert(0, _searchValue!);
      AudioConfig.saveSearchHistory(_searchHistoryList!);
      setState(() {});
    }
  }

  _getSearchSugList() async {
    await AudioPostHttp.getSearchSug(_searchValue!, null).then((value) {
      if (value['state'] == true) {
        _searchSugList
          ..clear()
          ..addAll(value['data'].map<String>((e) => e as String));
        setState(() {});
      } else {
        showToast(value['errmsg']);
      }
    });
  }

  _search() async {
    _saveSearchHistory();
    await AudioPostHttp.search(_searchValue!, 1, 20, null).then((value) {
      if (value['state'] == true) {
        print(value);
        _displayOrder = value['data']['displayorder'].map<String>((e) => e as String).toList();
        _displayOrder.forEach((e) {
          switch (e) {
            case 'typeTrack':
              _trackList..addAll(value['data'][e].map<Map<String, dynamic>>((e) => e as Map<String, dynamic>));
              break;
            case 'typeArtist':
              _artistList..addAll(value['data'][e].map<Map<String, dynamic>>((e) => e as Map<String, dynamic>));
              break;
            case 'typeAlbum':
              _albumList..addAll(value['data'][e].map<Map<String, dynamic>>((e) => e as Map<String, dynamic>));
              break;
            default:
              break;
          }
        });
        _hasResult = true;
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
        controller: _controller,
        isSearch: true,
        searchHint: '周杰伦',
        onSearch: (value) {
          print(value);
          if (isStringNotEmpty(value)) {
            _searchValue = value;
            _search();
          }
        },
        needDefaultRightAction: false,
        rightAction: TextButton(
          onPressed: () {
            Get.back();
          },
          child: CustomText.content('取消'),
        ),
      ),
      body: PublicBottomPlayWidget(
        child: _hasFocus && _hasValue && _searchSugList.length > 0
            ? _buildHintBox()
            : _hasResult
            ? _buildResultBox()
            : _buildSearchBox(),
      ),
    );
  }

  /// 搜索提示
  Widget _buildHintBox() {
    return Container(
      color: Colors.white,
      width: double.infinity,
      height: double.infinity,
      child: MediaQuery.removePadding(
          context: context,
          removeTop: true,
          removeBottom: true,
          child: ListView.builder(
            itemBuilder: (_, index) => CustomListItem(
              title: CustomText.title(_searchSugList[index]),
              minLeadingWidth: 30,
              leading: Icon(
                Icons.search,
                size: Dimens.font_size_16,
                color: Constants.gray_9,
              ),
              onTap: () {
                print(_searchSugList[index]);
                _controller.value = _searchSugList[index];
                _controller.unFocus();
                _search();
              },
            ),
            itemCount: _searchSugList.length,
          )),
    );
  }

  /// 搜索结果
  Widget _buildResultBox() {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          WTabBar(
            tabs: [
              WTab(text: '全部'),
              WTab(text: '单曲'),
              WTab(text: '专辑'),
              WTab(text: '歌手'),
            ],
            controller: _tabController,
            indicatorColor: Colors.black,
            indicatorSize: WTabBarIndicatorSize.label,
          ),
          Expanded(
            child: WTabBarView(
              controller: _tabController,
              children: [
                _buildAllList(),
                SearchTrackWidget(word: _searchValue!),
                SearchAlbumWidget(word: _searchValue!),
                SearchArtistWidget(word: _searchValue!),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 搜索推荐
  Widget _buildSearchBox() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(vertical: Dimens.pd8, horizontal: Dimens.pd16),
      width: double.infinity,
      height: double.infinity,
      child: Visibility(
        visible: _searchHistoryList != null && _searchHistoryList!.length > 0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: Dimens.pd12),
              child: CustomText.content('历史记录'),
            ),
            Wrap(
              children: (_searchHistoryList ?? [])
                  .map((e) => GestureDetector(
                        onTap: () {
                          _controller
                            ..value = e
                            ..unFocus();
                          _searchValue = e;
                          _search();
                        },
                        child: Chip(
                          backgroundColor: Colors.white,
                          side: BorderSide(color: Constants.gray_9),
                          label: CustomText.content(
                            e,
                            fontSize: Dimens.font_size_12,
                          ),
                          deleteIcon: Icon(
                            Icons.clear,
                            color: Constants.gray_9,
                            size: Dimens.font_size_16,
                          ),
                          onDeleted: () {
                            _searchHistoryList!.remove(e);
                            setState(() {});
                            AudioConfig.saveSearchHistory(_searchHistoryList!);
                          },
                        ),
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAllList() {
    return CustomScrollView(
      slivers: [
        SliverList(
            delegate: SliverChildBuilderDelegate(
                (_, index) => MusicItemWidget(
                      musicItem: _trackList[index],
                    ),
                childCount: _trackList.length)),
        SliverList(
            delegate: SliverChildBuilderDelegate(
                (_, index) => AlbumItemWidget(
                      albumItem: _albumList[index],
                    ),
                childCount: _albumList.length)),
        SliverList(
            delegate: SliverChildBuilderDelegate(
                (_, index) => ArtistItemWidget(
                      artistItem: _artistList[index],
                    ),
                childCount: _artistList.length)),
      ],
    );
  }
}
