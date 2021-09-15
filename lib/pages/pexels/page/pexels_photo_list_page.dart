import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_utils/common/dimens.dart';
import 'package:flutter_utils/common/model/pexels_photo_model.dart';
import 'package:flutter_utils/pages/pexels/request/post_http.dart';
import 'package:flutter_utils/utils/toast_utils.dart';
import 'package:flutter_utils/widget/cache_network_image_widget.dart';
import 'package:flutter_utils/widget/photo_view_widget.dart';
import 'package:get/get.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

/// jacokwu
/// 8/18/21 1:46 PM

class PexelsPhotoListPage extends StatefulWidget {
  const PexelsPhotoListPage({Key? key}) : super(key: key);

  @override
  _PexelsPhotoListPageState createState() => _PexelsPhotoListPageState();
}

class _PexelsPhotoListPageState extends State<PexelsPhotoListPage> {
  late List<PexelsPhotoModel> _photoList;
  late EasyRefreshController _easyRefreshController;
  late ScrollController _scrollController;

  int page = 1;
  int perPage = 10;
  int total = 0;

  @override
  void initState() {
    super.initState();
    _photoList = [];
    _easyRefreshController = EasyRefreshController();
    _scrollController = ScrollController(debugLabel: 'pexels_photo');
  }

  Future _getFeaturedPhotoList() async {
    return await PexelsPostHttp.getFeaturedPhoto(page, perPage).then((value) {
      if (value['error'] == null) {
        total = value['total_results'];
        if (page == 1) _photoList.clear();
        _photoList.addAll(value['photos'].map<PexelsPhotoModel>((e) => PexelsPhotoModel.fromJson(e)));
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
        await _getFeaturedPhotoList().then((value) {
          _easyRefreshController.finishRefreshCallBack!(success: true);
        }).catchError((err) {
          _easyRefreshController.finishRefreshCallBack!(success: false);
        });
      },
      onLoad: () async {
        page += 1;
        await _getFeaturedPhotoList().then((value) {
          _easyRefreshController.finishLoadCallBack!(success: true, noMore: total == _photoList.length);
        }).catchError((err) {
          _easyRefreshController.finishLoadCallBack!(success: false);
        });
      },
      child: StaggeredGridView.countBuilder(
          shrinkWrap: true,
          crossAxisCount: 4,
          mainAxisSpacing: 4,
          crossAxisSpacing: 4,
          itemCount: _photoList.length,
          itemBuilder: (_, index) => _buildImageBody(index),
          staggeredTileBuilder: (index) => StaggeredTile.fit(2)),
    );
  }

  Widget _buildImageBody(int index) {
    PexelsPhotoModel itemModel = _photoList[index];
    BaseCacheManager cacheManager = DefaultCacheManager();
    return Container(
      child: Stack(
        children: [
          CacheNetworkImageWidget(
            fit: BoxFit.fitWidth,
            imageUrl: itemModel.src.original,
            cacheManager: cacheManager,
            onTap: () {
              Get.to(PhotoViewWidget(
                urlList: _photoList.map((e) => e.src.original).toList(),
                initialIndex: index,
                cacheManager: cacheManager,
              ));
            },
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              color: Colors.transparent,
              child: Row(
                children: [
                  Container(
                    width: 30,
                    padding: EdgeInsets.symmetric(horizontal: Dimens.pd4),
                    child: CircleAvatar(
                      child: Text(itemModel.photographer.substring(0, 1).toUpperCase()),
                    ),
                  ),
                  Expanded(
                      child: Text(
                        itemModel.photographer,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.white, fontSize: Dimens.font_size_12),
                      )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
