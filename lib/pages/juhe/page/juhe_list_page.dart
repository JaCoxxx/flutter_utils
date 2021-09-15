import 'package:flutter/material.dart';
import 'package:flutter_utils/common/dimens.dart';
import 'package:flutter_utils/pages/juhe/request/post_http.dart';
import 'package:flutter_utils/widget/custom_scaffold/w_app_bar.dart';
import 'package:flutter_utils/widget/list_item_widget.dart';
import 'package:get/get.dart';

/// jacokwu
/// 7/30/21 1:24 PM

class JuHeListPage extends StatefulWidget {
  const JuHeListPage({Key? key}) : super(key: key);

  @override
  _JuHeListPageState createState() => _JuHeListPageState();
}

class _JuHeListPageState extends State<JuHeListPage> {
  late List<Map<String, dynamic>> _menuList;

  @override
  void initState() {
    super.initState();
    JuHePostHttp.init();
    _menuList = [
      {
        'title': '历史上的今天',
        'path': '/today-history',
      },
      {
        'title': '今日国内油价',
        'path': '/today-oil-price',
      },
      {
        'title': '数独',
        'path': '/sudoku-home',
      },
      {
        'title': '物流查询',
        'path': '/logistics-query',
      },
      {
        'title': '一些功能',
        'path': '/some-utils',
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WAppBar(
        titleConfig: WAppBarTitleConfig(title: '聚合数据'),
        showDefaultBack: true,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: Dimens.pd8, vertical: Dimens.pd8),
        child: ListView.separated(
            itemBuilder: (_, index) =>
                _buildItemWidget(_menuList[index], index),
            separatorBuilder: (_, index) => Dimens.hGap4,
            itemCount: _menuList.length),
      ),
    );
  }

  Widget _buildItemWidget(Map<String, dynamic> item, int index) {
    return Card(
      shadowColor: Colors.transparent,
      child: CustomListItem(
        title: Text(
          item['title'],
          style: TextStyle(color: Colors.black, fontSize: Dimens.font_size_16),
        ),
        needDefaultTrailing: true,
        onTap: item['path'] == null
            ? null
            : () {
                Get.toNamed(item['path']);
              },
      ),
    );
  }
}
