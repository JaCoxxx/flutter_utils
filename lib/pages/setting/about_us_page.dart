import 'package:flutter/material.dart';
import 'package:flutter_utils/common/constants.dart';
import 'package:flutter_utils/common/dimens.dart';
import 'package:flutter_utils/utils/utils.dart';
import 'package:flutter_utils/widget/custom_divider.dart';
import 'package:flutter_utils/widget/custom_scaffold/w_app_bar.dart';
import 'package:flutter_utils/widget/list_item_widget.dart';

/// jacokwu
/// 8/11/21 4:43 PM

class AboutUsPage extends StatefulWidget {
  const AboutUsPage({Key? key}) : super(key: key);

  @override
  _AboutUsPageState createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage> {
  String _version = '1.0.0';

  List _menuList = [];

  @override
  void initState() {
    super.initState();
    _initData();
  }

  _initData() async {
    await _getVersionString();
    _setMenuList();
    setState(() {});
  }

  _getVersionString() async {
    _version = await getAppVersionString();
  }

  _setMenuList() {
    _menuList
      ..clear()
      ..addAll([
        {
          'title': '检查更新',
          'key': 'update',
        },
        {
          'title': '帮助',
          'key': 'help',
        },
        {
          'title': '反馈',
          'key': 'feedback',
        },
      ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WAppBar(
        titleConfig: WAppBarTitleConfig(title: '关于我们'),
        showDefaultBack: true,
      ),
      body: Container(
        child: Column(
          children: [
            Container(
              height: 260,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/author.png',
                    width: 150,
                  ),
                  Dimens.hGap6,
                  Text(
                    '当前版本: V$_version',
                    style: TextStyle(
                      color: Constants.gray_8e,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: Dimens.pd12),
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: MediaQuery.removePadding(
                context: context,
                removeTop: true,
                removeBottom: true,
                child: ListView.separated(
                  shrinkWrap: true,
                    itemBuilder: (_, index) => CustomListItem(
                          title: Padding(
                            padding: EdgeInsets.symmetric(vertical: Dimens.pd4),
                            child: Text(_menuList[index]['title']),
                          ),
                        ),
                    separatorBuilder: (_, index) => CustomDivider(),
                    itemCount: _menuList.length),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
