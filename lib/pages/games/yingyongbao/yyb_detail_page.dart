import 'package:flutter/material.dart';
import 'package:flutter_utils/common/constants.dart';
import 'package:flutter_utils/common/dimens.dart';
import 'package:flutter_utils/common/model/yyb_list_model.dart';
import 'package:flutter_utils/pages/games/yingyongbao/yyb_choice_detail_page.dart';
import 'package:flutter_utils/pages/games/yingyongbao/yyb_comment_page.dart';
import 'package:flutter_utils/utils/utils.dart';
import 'package:flutter_utils/widget/cache_network_image_widget.dart';
import 'package:flutter_utils/widget/custom_scaffold/w_app_bar.dart';
import 'package:flutter_utils/widget/custom_tab_bar.dart';
import 'package:flutter_utils/widget/photo_view_widget.dart';
import 'package:flutter_utils/widget/widgets.dart';
import 'package:get/get.dart';

/// jacokwu
/// 8/12/21 3:14 PM

class YYBDetailPage extends StatefulWidget {
  final YYBListModel appDetail;

  const YYBDetailPage({Key? key, required this.appDetail}) : super(key: key);

  @override
  _YYBDetailPageState createState() => _YYBDetailPageState();
}

class _YYBDetailPageState extends State<YYBDetailPage> with TickerProviderStateMixin {
  late TabController _controller;

  late ScrollController _scrollController;

  double _expandedHeight = 280;

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController()
      ..addListener(() {
        setState(() {});
      });
    _controller = TabController(length: 2, vsync: this);
  }

  bool get _showTitle {
    return _scrollController.hasClients && _scrollController.offset > (_expandedHeight - kToolbarHeight) / 2;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          NestedScrollView(
            controller: _scrollController,
            // physics: BouncingScrollPhysics(),
            headerSliverBuilder: (_, innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  pinned: true,
                  primary: true,
                  expandedHeight: _expandedHeight,
                  title: _showTitle
                      ? Text(widget.appDetail.appName,
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.w600, fontSize: Dimens.font_size_16))
                      : null,
                  flexibleSpace: FlexibleSpaceBar(
                    background: _buildAppBarFlexibleSpace(),
                  ),
                  bottom: TabBar(
                    tabs: [Text('详情'), Text('评论')],
                    indicator: BoxDecoration(
                      border: Border(bottom: BorderSide(color: Colors.blueAccent, width: 4)),
                    ),
                    labelColor: Colors.blueAccent,
                    labelPadding: EdgeInsets.symmetric(vertical: Dimens.pd6),
                    unselectedLabelColor: Colors.black,
                    indicatorSize: TabBarIndicatorSize.label,
                    controller: _controller,
                  ),
                ),
              ];
            },
            body: TabBarView(
              children: [YYBChoiceDetailPage(appDetail: widget.appDetail), YYBCommentPage(appDetail: widget.appDetail)],
              controller: _controller,
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding:
                  EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom, left: Dimens.pd16, right: Dimens.pd16),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      child: Text('立即下载（${bytesToSize(widget.appDetail.fileSize)}）'),
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all(EdgeInsets.symmetric(vertical: Dimens.pd12)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBarFlexibleSpace() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(top: 100),
      child: Column(
        children: [
          Container(
            height: 100,
            color: Colors.white,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CacheNetworkImageWidget(imageUrl: widget.appDetail.iconUrl),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.appDetail.appName,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.w600, fontSize: Dimens.font_size_16),
                        ),
                        Dimens.hGap4,
                        Text(
                          widget.appDetail.editorIntro,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.w300, fontSize: Dimens.font_size_14),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          _buildRatingWidget(),
        ],
      ),
    );
  }

  Widget _buildRatingWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: Dimens.pd16),
      color: Color(0xfff0f0f0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.stars),
                    Text(widget.appDetail.appRatingInfo.averageRating.toStringAsFixed(2)),
                  ],
                ),
                Text('${unitConverter(widget.appDetail.appRatingInfo.ratingCount)}人评分')
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [Text(unitConverter(widget.appDetail.appDownCount)), Text('下载量')],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitleTextWidget(String title) {
    return Text(
      title,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: Dimens.font_size_16),
    );
  }

  Widget _buildContentTextWidget(String content) {
    return Text(
      content,
      style: TextStyle(color: Constants.gray_9, fontSize: Dimens.font_size_14),
    );
  }
}
