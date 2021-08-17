import 'package:flutter/material.dart';
import 'package:flutter_utils/common/constants.dart';
import 'package:flutter_utils/common/dimens.dart';
import 'package:flutter_utils/common/model/yyb_list_model.dart';
import 'package:flutter_utils/utils/utils.dart';
import 'package:flutter_utils/widget/cache_network_image_widget.dart';
import 'package:flutter_utils/widget/photo_view_widget.dart';
import 'package:flutter_utils/widget/widgets.dart';
import 'package:get/get.dart';

/// jacokwu
/// 8/13/21 3:10 PM

class YYBChoiceDetailPage extends StatefulWidget {
  final YYBListModel appDetail;

  const YYBChoiceDetailPage({Key? key, required this.appDetail}) : super(key: key);

  @override
  _YYBChoiceDetailPageState createState() => _YYBChoiceDetailPageState();
}

class _YYBChoiceDetailPageState extends State<YYBChoiceDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(vertical: Dimens.pd8, horizontal: Dimens.pd8),
      child: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        removeBottom: true,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 200,
                padding: EdgeInsets.symmetric(vertical: Dimens.pd8),
                child: ListView.separated(
                  itemBuilder: (_, index) => Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: CacheNetworkImageWidget(
                      imageUrl: widget.appDetail.images[index],
                      onTap: () {
                        Get.to(PhotoViewWidget(urlList: widget.appDetail.images, initialIndex: index));
                      },
                    ),
                  ),
                  separatorBuilder: (_, index) => Dimens.wGap8,
                  itemCount: widget.appDetail.images.length,
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                ),
              ),
              Card(
                color: Color(0xfff0f0f0),
                shadowColor: Colors.transparent,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildTitleTextWidget('应用信息'),
                          _buildContentTextWidget('版本号 ${widget.appDetail.versionName}'),
                        ],
                      ),
                      Dimens.hGap10,
                      if (widget.appDetail.description != null) Text(widget.appDetail.description!),
                      if (widget.appDetail.description != null) Dimens.hGap10,
                      Text(widget.appDetail.newFeature),
                      Dimens.hGap4,
                      _buildContentTextWidget('开发商: ${widget.appDetail.authorName}'),
                      Dimens.hGap4,
                      _buildContentTextWidget(
                          '${DateTime.fromMillisecondsSinceEpoch(widget.appDetail.apkPublishTime).toLocal().toString().substring(0, 16)}更新'),
                    ],
                  ),
                ),
              ),
              Dimens.hGap16,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildTitleTextWidget('使用该应用的人还喜欢'),
                  GestureDetector(
                    child: Row(
                      children: [
                        _buildContentTextWidget('全部'),
                        Dimens.wGap4,
                        Icon(
                          Icons.arrow_forward_ios,
                          size: Dimens.font_size_16,
                          color: Constants.gray_9,
                        )
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                height: 120,
                child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (_, index) => _buildOtherAppWidget(),
                    separatorBuilder: (_, index) => Dimens.wGap10,
                    itemCount: 16),
              ),
              Dimens.hGap16,
              ListView.separated(
                itemBuilder: (_, index) => _buildVideoWidget(),
                separatorBuilder: (_, index) => Dimens.hGap16,
                itemCount: 20,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
              ),
              safeAreaBottom(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOtherAppWidget() {
    return Container(
      width: 80,
      child: Column(
        children: [
          Dimens.hGap6,
          CacheNetworkImageWidget(
            imageUrl: widget.appDetail.iconUrl,
            width: 40,
          ),
          Dimens.hGap4,
          Text(
            widget.appDetail.appName,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: Dimens.font_size_14),
          ),
          Text(
            '${unitConverter(widget.appDetail.appDownCount)}次下载',
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: Dimens.font_size_12, color: Constants.gray_9),
          ),
          Dimens.hGap4,
          GestureDetector(
            onTap: () {},
            child: Container(
              padding: EdgeInsets.symmetric(vertical: Dimens.pd4, horizontal: Dimens.pd12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blueAccent),
                borderRadius: BorderRadius.circular(50),
              ),
              child: Text(
                '下载',
                style: TextStyle(fontSize: Dimens.font_size_12, color: Colors.blueAccent),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoWidget() {
    return Card(
      color: Color(0xfff0f0f0),
      shadowColor: Colors.transparent,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: _buildTitleTextWidget('这是视频标题这是视频标题这是视频标题这是视频标题这是视频标题这是视频标题'),
          ),
          Container(
            height: 200,
            color: Colors.amber,
            child: Center(
              child: Text('这是视频'),
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
