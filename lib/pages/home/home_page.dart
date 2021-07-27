import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:flutter_utils/common/dimens.dart';
import 'package:flutter_utils/widget/custom_scaffold/w_app_bar.dart';
import 'package:flutter_utils/widget/list_item_widget.dart';
import 'package:flutter_utils/widget/widgets.dart';
import 'package:get/get.dart';

final GlobalKey _scaffoldKey = GlobalKey();

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List menuList = [];

  @override
  void initState() {
    super.initState();
    menuList.addAll([
      {
        'title': '音乐播放器',
        'path': '/audio-play',
      },
      {
        'title': '视频播放器',
        'path': '/video-list',
      },
      {
        'title': 'H5',
        'path': '/unzip',
      },
      {
        'title': 'webView',
        'path': '/web-view',
      },
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final SystemUiOverlayStyle overlayStyle = SystemUiOverlayStyle.dark;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: overlayStyle,
      child: Scaffold(
        key: _scaffoldKey,
        body: SliderMenuContainer(
          isShadow: true,
          appBarPadding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top, bottom: Dimens.pd8),
          appBarHeight: MediaQuery.of(context).padding.top + 8 + 46,
          title: Text(
            '首页',
            style: TextStyle(
                fontSize: Dimens.font_size_18, fontWeight: FontWeight.w600),
          ),
          sliderMain: _buildSlideMain(),
          sliderMenu: _buildSlideMenu(),
        ),
      ),
    );
  }

  Widget _buildSlideMain() {
    return Container(
      color: Theme.of(context).backgroundColor,
      padding: EdgeInsets.symmetric(horizontal: Dimens.pd16, vertical: Dimens.pd8),
      child: MediaQuery.removeViewPadding(
        context: context,
        removeTop: true,
        child: SingleChildScrollView(
          child: GridView.builder(
            itemCount: menuList.length,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: Dimens.pd4,
              mainAxisSpacing: Dimens.pd4,
              childAspectRatio: 1.5,
            ),
            itemBuilder: (_, int index) {
              return _buildMainItemWidget(menuList[index]);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildMainItemWidget(dynamic item) {
    return Card(
      shadowColor: Colors.transparent,
      child: InkWell(
        child: Center(child: Text(item['title'])),
        onTap: () {
          Get.toNamed(item['path']);
        },
      ),
    );
  }

  Widget _buildSlideMenu() {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 160,
            child: Center(
              child: DrawerHeader(
                  child: CircleAvatar(
                child: Text('吴'),
              )),
            ),
          ),
          CustomListItem(
            title: Container(
              child: Text('设置'),
            ),
            leading: Container(
              child: Icon(Icons.settings),
            ),
            onTap: () {
              Get.toNamed('/setting');
            },
          ),
        ],
      ),
    );
  }
}
