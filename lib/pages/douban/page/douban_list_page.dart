import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_utils/common/dimens.dart';
import 'package:flutter_utils/pages/douban/page/ex_page_one.dart';
import 'package:flutter_utils/pages/douban/request/post_http.dart';
import 'package:flutter_utils/utils/toast_utils.dart';
import 'package:flutter_utils/widget/cache_network_image_widget.dart';
import 'package:flutter_utils/widget/custom_scaffold/w_app_bar.dart';
import 'package:get/get.dart';

/// jacokwu
/// 7/29/21 3:05 PM

class DoubanListPage extends StatefulWidget {
  const DoubanListPage({Key? key}) : super(key: key);

  @override
  _DoubanListPageState createState() => _DoubanListPageState();
}

class _DoubanListPageState extends State<DoubanListPage>
    with TickerProviderStateMixin {
  List<Map<String, dynamic>> _hotList = [];
  late List<Map<String, dynamic>> _typeList;
  List<String> _tagsList = [];
  int _currentTabIndex = 0;
  int _currentTagIndex = 0;

  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _typeList = [
      {
        'name': '电影',
        'id': 'movie',
      },
      {
        'name': '电视',
        'id': 'tv',
      },
    ];

    _tabController = TabController(length: _typeList.length, vsync: this);

    DouBanPostHttp.init();
    // _getMovieTag();
  }

  _getMovieTag() async {
    showLoading();
    print(_typeList[_currentTabIndex]);
    DouBanPostHttp.getTagsList(_typeList[_currentTabIndex]['id']).then((value) {
      _tagsList
        ..clear()
        ..addAll(value['tags'].map<String>((e) => e as String));
      dismissLoading();
      _getList();
      setState(() {});
    }).catchError((err) {
      print(err);
      dismissLoading();
    });
  }

  _getList() async {
    showLoading();
    DouBanPostHttp.getHotList(_typeList[_currentTabIndex]['id'],
            _tagsList[_currentTagIndex], 50, 0)
        .then((value) {
      _hotList
        ..clear()
        ..addAll(value['subjects']
            .map<Map<String, dynamic>>((e) => e as Map<String, dynamic>));
      dismissLoading();
      setState(() {});
    }).catchError((err) {
      print(err);
      dismissLoading();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WAppBar(
        showDefaultBack: true,
        titleConfig: WAppBarTitleConfig(title: '豆瓣'),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: Dimens.pd8),
        child: Column(
          children: [
            TextButton(
              child: Text('点击'),
              onPressed: () {
                if (Platform.isAndroid) {
                  DeviceInfoPlugin().androidInfo.then((value) {
                    print(value.id);
                    print(value.version.codename);
                    print(value.androidId);
                  });
                } else {
                  DeviceInfoPlugin().iosInfo.then((value) {
                    print(value.identifierForVendor);
                    print(value.name);
                    print(value.systemName);
                  });
                }
              },
            ),
            TextButton(onPressed: () {
              // Get.toNamed('/douban-list/ex1');
              Get.to(ExPageOne());
            }, child: Text('ex1'),),
            TextButton(onPressed: () {
              Get.toNamed('/douban-list/ex2');
            }, child: Text('ex2'),),
          ],
        ),
      ),
    );
  }
}
