import 'package:flutter/material.dart';
import 'package:flutter_utils/common/constants.dart';
import 'package:flutter_utils/common/dimens.dart';
import 'package:flutter_utils/common/model/yyb_list_model.dart';
import 'package:flutter_utils/utils/utils.dart';
import 'package:flutter_utils/widget/cache_network_image_widget.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../yyb_detail_page.dart';

/// jacokwu
/// 8/16/21 4:09 PM

class YYBListItemWidget extends StatelessWidget {
  final YYBListModel detail;
  const YYBListItemWidget({Key? key, required this.detail}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(YYBDetailPage(appDetail: detail));
      },
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(vertical: Dimens.pd12, horizontal: Dimens.pd16),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CacheNetworkImageWidget(imageUrl: detail.iconUrl),
              ),
            ),
            Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      detail.appName,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: Dimens.font_size_14),
                    ),
                    Dimens.hGap4,
                    Text(
                      detail.editorIntro,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.w300, fontSize: Dimens.font_size_14),
                    ),
                    Dimens.hGap4,
                    Row(
                      children: [
                        Text(
                          '${unitConverter(detail.appDownCount)}次下载',
                          style: TextStyle(color: Constants.gray_9, fontSize: Dimens.font_size_12),
                        ),
                        Dimens.wGap6,
                        Text(
                          bytesToSize(detail.fileSize),
                          style: TextStyle(color: Constants.gray_9, fontSize: Dimens.font_size_12),
                        ),
                      ],
                    ),
                  ],
                )),
            Dimens.wGap4,
            Expanded(
              child: TextButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      side: BorderSide(color: Colors.blueAccent), borderRadius: BorderRadius.circular(8))),
                ),
                onPressed: () {
                  launch(detail.pkgName);
                },
                child: Text(
                  '下载',
                  style: TextStyle(fontSize: Dimens.font_size_14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

