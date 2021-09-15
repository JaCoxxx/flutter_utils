import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_utils/common/constants.dart';
import 'package:flutter_utils/common/dimens.dart';
import 'package:flutter_utils/pages/audio_play/artist/artist_detail_album_page.dart';
import 'package:flutter_utils/pages/audio_play/artist/artist_detail_info_page.dart';
import 'package:flutter_utils/pages/audio_play/artist/artist_detail_song_page.dart';
import 'package:flutter_utils/pages/audio_play/play/public_bottom_play_widget.dart';
import 'package:flutter_utils/pages/audio_play/request/post_http.dart';
import 'package:flutter_utils/utils/toast_utils.dart';
import 'package:flutter_utils/utils/utils.dart';
import 'package:flutter_utils/widget/cache_network_image_widget.dart';
import 'package:flutter_utils/widget/custom_scaffold/w_app_bar.dart';
import 'package:flutter_utils/widget/custom_scaffold/w_tab_bar.dart';
import 'package:flutter_utils/widget/sliver/sliver_top_hover_delegate.dart';
import 'package:flutter_utils/widget/sliver/sticky_tab_bar_delegate.dart';
import 'package:flutter_utils/widget/widgets.dart';
import 'package:get/get.dart';

/// jacokwu
/// 8/25/21 9:13 AM

class ArtistDetailPage extends StatefulWidget {
  const ArtistDetailPage({Key? key}) : super(key: key);

  @override
  _ArtistDetailPageState createState() => _ArtistDetailPageState();
}

class _ArtistDetailPageState extends State<ArtistDetailPage> with TickerProviderStateMixin {
  late String artistCode;

  Map<String, dynamic> _artistInfo = {};

  double _expandedHeight = ScreenUtil().setWidth(500);

  late TabController _controller;
  late ScrollController _scrollController;

  late double _extraPicHeight;

  double _preDy = 0;
  double _initialDy = 0;

  late AnimationController _animationController;
  late Animation<double> _animation;

  GlobalKey _headerKey = GlobalKey();
  GlobalKey _tabBarKey = GlobalKey();

  late Future<Map<String, dynamic>> _future;

  bool get _showTitle {
    return _scrollController.hasClients && _scrollController.offset > (_expandedHeight - kToolbarHeight);
  }

  @override
  void initState() {
    super.initState();
    _extraPicHeight = 0;
    _controller = TabController(length: 3, vsync: this);
    _scrollController = ScrollController();

    _animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 300));

    _animation = Tween(begin: 0.0, end: 0.0).animate(_animationController);

    artistCode = Get.arguments;

    _future = _getArtistInfo();
  }

  Future<Map<String, dynamic>> _getArtistInfo() async {
    return await AudioPostHttp.getArtistInfo(artistCode).then((value) {
      if (value['state'] == true) {
        _artistInfo = value['data'] as Map<String, dynamic>;
        setState(() { });
      } else {
        showToast(value['errmsg']);
      }
      return _artistInfo;
    });
  }

  _updatePicHeight(double dy) {
    if (_scrollController.offset != 0) return;
    if (_preDy == 0) {
      _preDy = dy;
      _initialDy = dy;
    }
    if (dy - _initialDy > 180 || dy < _initialDy) return;
    _extraPicHeight += dy - _preDy;
    _preDy = dy;
    setState(() {});
  }

  _runAnimation() {
    _animation = Tween(begin: _extraPicHeight, end: 0.0).animate(_animationController)
      ..addListener(() {
        _extraPicHeight = _animation.value;
        setState(() {});
      });
    _preDy = 0;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: PublicBottomPlayWidget(
        child: _buildContainer(),
      ),
    );
  }

  Widget _buildContainer() {
    return FutureBuilder<Map<String, dynamic>>(
        future: _future,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return emptyWidget;
          return Listener(
            onPointerMove: (event) {
              _updatePicHeight(event.position.dy);
            },
            onPointerUp: (event) {
              _runAnimation();
              _animationController.forward(from: 0);
            },
            child: ExtendedNestedScrollView(
              key: _headerKey,
              controller: _scrollController,
              pinnedHeaderSliverHeightBuilder: () {
                double _tabBarHeight = _buildTabBarWidget().preferredSize.height;
                return kToolbarHeight + MediaQuery.of(context).padding.top + _tabBarHeight;
              },
              onlyOneScrollInBody: true,
              headerSliverBuilder: (_, innerBoxIsScrolled) {
                return [
                  SliverAppBar(
                    pinned: true,
                    expandedHeight: _expandedHeight + _extraPicHeight,
                    title: _showTitle
                        ? Text(
                      _artistInfo['name'] ?? '',
                      style: TextStyle(color: Colors.black),
                    )
                        : emptyWidget,
                    iconTheme: IconThemeData(color: _showTitle ? Colors.black : Colors.white),
                    backgroundColor: Colors.white,
                    stretchTriggerOffset: _expandedHeight,
                    flexibleSpace: FlexibleSpaceBar(
                      background: _buildAppBarBackground(),
                    ),
                  ),
                  SliverPersistentHeader(
                    delegate: SliverTopHoverDelegate(
                      child: _buildTitleWidget(),
                      childMinExtent: 100,
                      childMaxExtent: 100,
                    ),
                  ),
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: StickyTabBarDelegate(
                      backgroundColor: Colors.white,
                      child: _buildTabBarWidget(),
                    ),
                  ),
                ];
              },
              body: SafeArea(
                top: false,
                child: WTabBarView(
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    ArtistDetailSongPage(
                      artistCode: artistCode,
                    ),
                    ArtistDetailAlbumPage(
                      artistCode: artistCode,
                    ),
                    ArtistDetailInfoPage(artistInfo: _artistInfo),
                  ],
                  controller: _controller,
                ),
              ),
            ),
          );
        });
  }

  Widget _buildAppBarBackground() {
    return Container(
      height: _expandedHeight,
      color: Constants.lightLineColor,
      child: isStringEmpty(_artistInfo['pic']) ? null : CacheNetworkImageWidget(
        width: MediaQuery.of(context).size.width,
        height: _expandedHeight + _extraPicHeight * 2,
        imageUrl: _artistInfo['pic'] ?? '',
        fit: BoxFit.cover,
      ),
    );
  }

  WTabBar _buildTabBarWidget() {
    return WTabBar(
      key: _tabBarKey,
      indicatorSize: WTabBarIndicatorSize.label,
      indicatorColor: Colors.black,
      unselectedLabelColor: Constants.gray_9,
      labelStyle: TextStyle(fontSize: Dimens.font_size_14),
      labelPadding: EdgeInsets.symmetric(vertical: 0, horizontal: Dimens.pd16),
      tabs: [
        WTab(text: '热门单曲'),
        WTab(text: '全部专辑'),
        WTab(text: '简介'),
      ],
      controller: _controller,
    );
  }

  Widget _buildTitleWidget() {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      padding: EdgeInsets.only(left: Dimens.pd25, top: Dimens.pd25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _artistInfo['name'],
            style: TextStyle(color: Colors.black, fontSize: Dimens.font_size_18, fontWeight: FontWeight.w600),
          ),
          Row(
            children: [
              TextButton.icon(
                onPressed: () {},
                icon: Icon(
                  Icons.star_border,
                  size: Dimens.font_size_12,
                  color: Colors.black,
                ),
                label: Text(
                  '收藏',
                  style: TextStyle(color: Colors.black, fontSize: Dimens.font_size_12),
                ),
                style: ButtonStyle(),
              ),
              TextButton.icon(
                  onPressed: () {},
                  icon: Icon(
                    Icons.share_rounded,
                    size: Dimens.font_size_12,
                    color: Colors.black,
                  ),
                  label: Text(
                    '分享',
                    style: TextStyle(color: Colors.black, fontSize: Dimens.font_size_12),
                  )),
            ],
          ),
        ],
      ),
    );
  }
}
