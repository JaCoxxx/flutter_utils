import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_utils/common/constants.dart';
import 'package:flutter_utils/common/dimens.dart';
import 'package:flutter_utils/pages/audio_play/bloc/controller_bloc/audio_controller_bloc.dart';
import 'package:flutter_utils/pages/audio_play/config/audio_config.dart';
import 'package:flutter_utils/pages/audio_play/play/public_bottom_play_widget.dart';
import 'package:flutter_utils/pages/audio_play/request/post_http.dart';
import 'package:flutter_utils/pages/audio_play/widget/music_item_widget.dart';
import 'package:flutter_utils/utils/toast_utils.dart';
import 'package:flutter_utils/utils/utils.dart';
import 'package:flutter_utils/widget/cache_network_image_widget.dart';
import 'package:flutter_utils/widget/custom_text.dart';
import 'package:flutter_utils/widget/list_item_widget.dart';
import 'package:flutter_utils/widget/sliver/sliver_top_hover_delegate.dart';
import 'package:flutter_utils/widget/widgets.dart';

/// jacokwu
/// 8/25/21 9:07 AM

class TrackDetailPage extends StatefulWidget {
  final String trackId;
  const TrackDetailPage({Key? key, required this.trackId}) : super(key: key);

  @override
  _TrackDetailPageState createState() => _TrackDetailPageState();
}

class _TrackDetailPageState extends State<TrackDetailPage> with TickerProviderStateMixin {
  late ScrollController _scrollController;

  double _expandedHeight = ScreenUtil().setWidth(500);

  double _extraPicHeight = 0;

  Map<String, dynamic> _trackInfo = {};

  double _preDy = 0;
  double _initialDy = 0;

  late AnimationController _animationController;
  late Animation<double> _animation;
  late Future<Map<String, dynamic>>? _future;

  bool get _showTitle {
    return _scrollController.hasClients && _scrollController.offset > (_expandedHeight - kToolbarHeight) * 2 / 3;
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

    _animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 300));

    _animation = Tween(begin: 0.0, end: 0.0).animate(_animationController);

    _future = _getTrackDetailInfo();
  }

  Future<Map<String, dynamic>> _getTrackDetailInfo() async {
    return await AudioPostHttp.getTrackInfo(widget.trackId, 1, 99999).then((value) {
      if (value['state'] == true) {
        _trackInfo = value['data'];
        // setState(() { });
      } else {
        showToast(value['errmsg']);
      }
      return _trackInfo;
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
      body: PublicBottomPlayWidget(
        child: FutureBuilder(
          future: _future,
          builder: (_, snap) {
            if (!snap.hasData) return pageLoading(context);
            return Listener(
              onPointerMove: (event) {
                _updatePicHeight(event.position.dy);
              },
              onPointerUp: (event) {
                _runAnimation();
                _animationController.forward(from: 0);
              },
              child: ExtendedNestedScrollView(
                controller: _scrollController,
                pinnedHeaderSliverHeightBuilder: () {
                  return kToolbarHeight + MediaQuery.of(context).padding.top + 50;
                },
                onlyOneScrollInBody: true,
                headerSliverBuilder: (_, innerBoxIsScrolled) {
                  return [
                    SliverAppBar(
                      pinned: true,
                      title: _showTitle ? CustomText.title(_trackInfo['title']) : emptyWidget,
                      expandedHeight: _expandedHeight + _extraPicHeight,
                      iconTheme: IconThemeData(color: _showTitle ? Colors.black : Colors.white),
                      backgroundColor: Colors.white,
                      shadowColor: Colors.transparent,
                      stretchTriggerOffset: _expandedHeight,
                      flexibleSpace: FlexibleSpaceBar(
                        background: _buildAppBarBackground(),
                      ),
                    ),
                    SliverPersistentHeader(
                        delegate: SliverTopHoverDelegate(
                      child: _buildTitleContainerWidget(),
                      childMaxExtent: ScreenUtil().setWidth(160),
                      childMinExtent: ScreenUtil().setWidth(160),
                    )),
                    SliverPersistentHeader(
                      delegate: SliverTopHoverDelegate(
                          child: _buildTopBarWidget(),
                          childMaxExtent: ScreenUtil().setWidth(100),
                          childMinExtent: ScreenUtil().setWidth(100)),
                    ),
                  ];
                },
                body: _buildBodyWidget(),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildAppBarBackground() {
    return Container(
      height: _expandedHeight,
      color: Constants.lightLineColor,
      child: isStringEmpty(_trackInfo['pic'])
          ? null
          : CacheNetworkImageWidget(
              width: MediaQuery.of(context).size.width,
              height: _expandedHeight + _extraPicHeight * 2,
              imageUrl: _trackInfo['pic'] ?? '',
              fit: BoxFit.cover,
            ),
    );
  }

  Widget _buildTitleContainerWidget() {
    return GestureDetector(
      onTap: () {
        AudioConfig.showPageDetailDialog(context,
            pic: _trackInfo['pic'], title: _trackInfo['title'], desc: _trackInfo['desc'], tagList: _trackInfo['tagList'].map<String>((e) => e as String).toList());
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: Dimens.pd8, horizontal: Dimens.pd12),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(color: Constants.lightLineColor, width: 0.5),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText.title(
              _trackInfo['title'],
              fontSize: Dimens.font_size_22,
            ),
            Dimens.hGap8,
            if (isStringNotEmpty(_trackInfo['desc']))
              CustomListItem(
                minLeadingWidth: 0,
                contentPadding: EdgeInsets.zero,
                title: CustomText.title(
                  _trackInfo['desc'],
                  fontSize: Dimens.font_size_12,
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  size: Dimens.font_size_12,
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
        onTap: () {
          BlocProvider.of<AudioControllerBloc>(context).state.audioPlayController.replacePlayList(
              _trackInfo['trackList'].map<Map<String, dynamic>>((e) => <String, dynamic>{...e}).toList(), null);
        },
        contentPadding: EdgeInsets.symmetric(horizontal: Dimens.pd16),
        title: Text('播放全部'),
        leading: Icon(
          Icons.play_circle_fill_outlined,
          color: Colors.red,
        ),
        trailing: Row(
          children: [
            IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.download_outlined,
                  color: Colors.black,
                )),
            IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.check_circle_outline,
                  color: Colors.black,
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildBodyWidget() {
    return Container(
      color: Colors.white,
      child: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        // removeBottom: true,
        child: ListView.builder(
          itemBuilder: (_, index) => MusicItemWidget(
            musicItem: _trackInfo['trackList'][index],
            minLeadingWidth: 30,
            leading: CustomText.content(fillInNum(index + 1)),
          ),
          itemCount: _trackInfo['trackList'].length,
          physics: ClampingScrollPhysics(),
        ),
      ),
    );
  }
}
