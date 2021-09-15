import 'package:flutter/material.dart';
import 'package:flutter_utils/pages/pexels/page/pexels_photo_list_page.dart';
import 'package:flutter_utils/pages/pexels/page/pexels_video_list_page.dart';
import 'package:flutter_utils/pages/pexels/request/post_http.dart';
import 'package:flutter_utils/widget/custom_scaffold/w_app_bar.dart';
import 'package:flutter_utils/widget/custom_tab_bar.dart';
import 'package:flutter_utils/widget/widgets.dart';

/// jacokwu
/// 8/18/21 10:40 AM

class PexelsListPage extends StatefulWidget {
  const PexelsListPage({Key? key}) : super(key: key);

  @override
  _PexelsListPageState createState() => _PexelsListPageState();
}

class _PexelsListPageState extends State<PexelsListPage> {

  @override
  void initState() {
    super.initState();
    PexelsPostHttp.init();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WAppBar(
        titleConfig: WAppBarTitleConfig(title: 'pexels'),
        showDefaultBack: true,
      ),
      body: CustomTabBar(
        isExpanded: false,
        menuList: [
          CustomTabBarItemBean(title: '图片', renderFn: () => _buildImageContainer()),
          CustomTabBarItemBean(title: '视频', renderFn: () => _buildVideoContainer())
        ],
      ),
    );
  }

  Widget _buildImageContainer() {
    return PexelsPhotoListPage();
  }

  Widget _buildVideoContainer() {
    return PexelsVideoListPage();
  }
}
