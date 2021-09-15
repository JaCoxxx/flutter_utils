import 'package:flutter/material.dart';
import 'package:flutter_utils/common/constants.dart';
import 'package:flutter_utils/common/dimens.dart';
import 'package:flutter_utils/pages/audio_play/audio_public_list_page.dart';
import 'package:flutter_utils/pages/audio_play/play/public_bottom_play_widget.dart';
import 'package:flutter_utils/pages/audio_play/request/post_http.dart';
import 'package:flutter_utils/pages/audio_play/tracklist/track_detail_page.dart';
import 'package:flutter_utils/utils/toast_utils.dart';
import 'package:flutter_utils/widget/custom_scaffold/w_app_bar.dart';
import 'package:get/get.dart';

/// jacokwu
/// 8/26/21 10:17 AM

class CategoryListPage extends StatefulWidget {
  const CategoryListPage({Key? key}) : super(key: key);

  @override
  _CategoryListPageState createState() => _CategoryListPageState();
}

class _CategoryListPageState extends State<CategoryListPage> {
  List<Map<String, dynamic>> _categoryList = [];

  @override
  initState() {
    super.initState();
    _getCategoryList();
  }

  _getCategoryList() async {
    await AudioPostHttp.getTrackCategory().then((value) {
      if (value['state'] == true) {
        _categoryList
          ..clear()
          ..addAll(value['data'].map<Map<String, dynamic>>((e) => e as Map<String, dynamic>));
        setState(() {});
      } else {
        showToast(value['errmsg']);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WAppBar(
        titleConfig: WAppBarTitleConfig(title: '全部流派'),
        showDefaultBack: true,
      ),
      body: PublicBottomPlayWidget(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: Dimens.pd16),
            child: Column(
              children: List.generate(_categoryList.length, (index) => _buildItemWidget(_categoryList[index])),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildItemWidget(Map<String, dynamic> item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: Dimens.pd12),
          child: Text(
            item['categoryName'],
            style: TextStyle(color: Colors.black, fontSize: Dimens.font_size_18, fontWeight: FontWeight.w600),
          ),
        ),
        GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: Dimens.pd8,
            crossAxisSpacing: Dimens.pd8,
            childAspectRatio: 3,
          ),
          itemCount: item['subCate'].length,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (_, index) => GestureDetector(
            onTap: () {
              Get.to(AudioPublicListPage(
                title: item['subCate'][index]['categoryName'],
                fetch: (pageNo, pageSize) async {
                  return await AudioPostHttp.getTrackList(pageNo, pageSize, item['subCate'][index]['id']).then((value) {
                    if (value['state'] == true) {
                      return value['data']['result']
                          .map<Map<String, dynamic>>((e) => e as Map<String, dynamic>)
                          .toList();
                    } else {
                      showToast(value['errmsg']);
                      return [];
                    }
                  });
                },
                onTapItem: (int index, Map<String, dynamic> value) {
                  Get.to(TrackDetailPage(trackId: value['id'].toString()));
                },
              ));
            },
            child: Container(
              color: Constants.lightLineColor,
              alignment: Alignment.center,
              child: Text(
                item['subCate'][index]['categoryName'],
                style: TextStyle(color: Constants.gray_9, fontSize: Dimens.font_size_14),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
