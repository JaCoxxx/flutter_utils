import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_utils/common/constants.dart';
import 'package:flutter_utils/common/dimens.dart';
import 'package:flutter_utils/utils/utils.dart';
import 'package:flutter_utils/widget/cache_network_image_widget.dart';
import 'package:flutter_utils/widget/custom_divider.dart';
import 'package:flutter_utils/widget/custom_text.dart';
import 'package:get/get.dart';

/// jacokwu
/// 8/31/21 3:14 PM

class ShowDetailWidget extends StatelessWidget {
  final String? pic;

  final String title;

  final String? desc;

  final bool isAlbum;

  final List<String>? tagList;

  const ShowDetailWidget(
      {Key? key, required this.pic, required this.title, this.desc, this.isAlbum = false, this.tagList})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.back();
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                color: Colors.black.withOpacity(0.2),
                child: isStringEmpty(pic)
                    ? Container(
                        color: Colors.black38,
                      )
                    : CacheNetworkImageWidget(
                        imageUrl: pic ?? '',
                        width: MediaQuery.of(context).size.width / 5 * 3,
                        height: MediaQuery.of(context).size.width / 5 * 3,
                        fit: BoxFit.cover,
                      )),
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Container(
                color: Colors.black38,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top, bottom: MediaQuery.of(context).padding.bottom),
              child: Stack(
                children: [
                  Positioned(
                    right: 0,
                    top: 0,
                    child: GestureDetector(
                      onTap: () => Get.back(),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: Dimens.font_size_16),
                        child: Icon(
                          Icons.clear,
                          color: Colors.white,
                          size: Dimens.font_size_24,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: ScreenUtil().setWidth(100)),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Dimens.hGap30,
                          Stack(
                            alignment: AlignmentDirectional.topCenter,
                            children: [
                              Dimens.hGap30,
                              if (isAlbum)
                                Positioned(
                                  left: 0,
                                  top: 5,
                                  child: Container(
                                    width: MediaQuery.of(context).size.width / 5 * 3,
                                    height: MediaQuery.of(context).size.width / 5 * 3,
                                    decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(200),
                                    ),
                                  ),
                                ),
                              Container(
                                  margin: isAlbum ? EdgeInsets.only(top: Dimens.pd30) : EdgeInsets.zero,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(6)),
                                      color: Constants.backgroundColor),
                                  clipBehavior: Clip.antiAlias,
                                  child: isStringEmpty(pic)
                                      ? null
                                      : CacheNetworkImageWidget(
                                          imageUrl: pic ?? '',
                                          width: MediaQuery.of(context).size.width / 5 * 3,
                                          height: MediaQuery.of(context).size.width / 5 * 3,
                                          fit: BoxFit.cover,
                                        )),
                            ],
                          ),
                          Dimens.hGap30,
                          CustomText(
                            title,
                            fontSize: Dimens.font_size_18,
                            color: Colors.white,
                          ),
                          Dimens.hGap30,
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: ScreenUtil().setWidth(1),
                            child: Container(
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(colors: [
                                Colors.transparent,
                                Colors.transparent,
                                Color(0x33FEFEFE),
                                Color(0xFFFEFEFE),
                                Color(0xFFFEFEFE),
                                Color(0x33FEFEFE),
                                Colors.transparent,
                                Colors.transparent
                              ])),
                            ),
                          ),
                          Dimens.hGap22,
                          if (tagList != null && tagList!.length > 0)
                            Container(
                              height: ScreenUtil().setWidth(100),
                              padding: EdgeInsets.symmetric(horizontal: Dimens.font_size_16, vertical: Dimens.pd12),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  CustomText(
                                    '标签: ',
                                    color: Colors.white,
                                    fontSize: Dimens.font_size_12,
                                  ),
                                  ...List.generate(
                                    tagList!.length,
                                    (index) => Container(
                                      padding: EdgeInsets.symmetric(horizontal: Dimens.pd4),
                                      child: CustomText(
                                        '#${tagList![index]}',
                                        color: Colors.white,
                                        fontSize: Dimens.font_size_12,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: Dimens.font_size_16),
                            child: Text(
                              desc ?? '-',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: Dimens.font_size_12,
                              ),
                            ),
                          ),
                          Dimens.hGap30,
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Center(
                      child: TextButton(
                        onPressed: () {},
                        child: CustomText(
                          '保存封面',
                          color: Colors.white,
                          fontSize: Dimens.font_size_14,
                        ),
                        style: ButtonStyle(
                          padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: Dimens.pd20)),
                          shape: MaterialStateProperty.all(RoundedRectangleBorder(
                              side: BorderSide(color: Colors.white, width: ScreenUtil().setWidth(1)),
                              borderRadius: BorderRadius.circular(50))),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
