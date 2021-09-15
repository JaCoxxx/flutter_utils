import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_utils/common/constants.dart';
import 'package:flutter_utils/common/dimens.dart';
import 'package:flutter_utils/common/model/pexels_video_model.dart';
import 'package:flutter_utils/pages/pexels/page/pexels_video_play_page.dart';
import 'package:flutter_utils/pages/pexels/request/post_http.dart';
import 'package:flutter_utils/utils/toast_utils.dart';
import 'package:flutter_utils/utils/utils.dart';
import 'package:flutter_utils/widget/cache_network_image_widget.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

/// jacokwu
/// 8/18/21 3:14 PM

class PexelsVideoListPage extends StatefulWidget {
  const PexelsVideoListPage({Key? key}) : super(key: key);

  @override
  _PexelsVideoListPageState createState() => _PexelsVideoListPageState();
}

class _PexelsVideoListPageState extends State<PexelsVideoListPage> {
  late List<PexelsVideoModel> _videoList;
  late EasyRefreshController _easyRefreshController;
  late ScrollController _scrollController;

  int page = 1;
  int perPage = 10;
  int total = 0;

  @override
  void initState() {
    super.initState();
    _videoList = [];
    _easyRefreshController = EasyRefreshController();
    _scrollController = ScrollController(debugLabel: 'pexels_video');
    // _getFeaturedPhotoList();
  }

  Future _getPopularVideoList() async {
    return await PexelsPostHttp.getPopularVideo(page, perPage).then((value) {
      if (value['error'] == null) {
        total = value['total_results'];
        if (page == 1) _videoList.clear();
        _videoList.addAll(value['videos'].map<PexelsVideoModel>((e) => PexelsVideoModel.fromJson(e)));
        print(_videoList.length);
        setState(() {});
      } else {
        showToast(value['error']);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return EasyRefresh(
      controller: _easyRefreshController,
      scrollController: _scrollController,
      firstRefresh: true,
      firstRefreshWidget: Container(
        height: double.infinity,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
      onRefresh: () async {
        page = 1;
        await _getPopularVideoList().then((value) {
          _easyRefreshController.finishRefreshCallBack!(success: true);
        });
      },
      onLoad: () async {
        page += 1;
        await _getPopularVideoList().then((value) {
          _easyRefreshController.finishLoadCallBack!(success: true, noMore: total == _videoList.length);
        });
      },
      child: GridView.custom(
        controller: _scrollController,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 2,
          crossAxisSpacing: 2,
          childAspectRatio: 1.2,
        ),
        childrenDelegate: SliverChildBuilderDelegate(
          (_, index) {
            return GestureDetector(
              onTap: () {
                Get.to(PexelsVideoPlayPage(videoModel: _videoList[index]));
              },
              child: Card(
                clipBehavior: Clip.antiAlias,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Stack(
                        children: [
                          CacheNetworkImageWidget(
                            fit: BoxFit.fitWidth,
                            imageUrl: _videoList[index].image,
                          ),
                          Positioned(
                            left: 0,
                            top: 0,
                            bottom: 0,
                            right: 0,
                            child: Container(
                              child: Center(
                                child: Icon(
                                  FontAwesomeIcons.play,
                                  color: Colors.white.withAlpha(90),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            left: 0,
                            bottom: 16,
                            right: 0,
                            child: Container(
                              alignment: Alignment.centerRight,
                              padding: EdgeInsets.symmetric(horizontal: Dimens.pd4),
                              child: Text(
                                getTimeBySeconds(_videoList[index].duration),
                                style: TextStyle(color: Colors.white, fontSize: Dimens.font_size_12),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: Dimens.pd8, vertical: Dimens.pd4),
                      child: Text(
                        _videoList[index].user.name,
                        style: TextStyle(color: Constants.gray_9, fontSize: Dimens.font_size_14),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: Dimens.pd8, vertical: Dimens.pd4),
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(text: '由'),
                            TextSpan(
                                text: 'Pexels',
                                style: TextStyle(
                                    color: Colors.black, fontSize: Dimens.font_size_14, fontWeight: FontWeight.w600)),
                            TextSpan(text: '提供数据支持。'),
                          ],
                          style: TextStyle(color: Constants.gray_c, fontSize: Dimens.font_size_12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
          childCount: _videoList.length,
        ),
      ),
    );
  }
}
