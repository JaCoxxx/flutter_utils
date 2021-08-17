import 'package:flutter/material.dart';
import 'package:flutter_utils/common/dimens.dart';
import 'package:flutter_utils/widget/custom_divider.dart';
import 'package:flutter_utils/widget/custom_scaffold/w_app_bar.dart';
import 'package:get/get.dart';

/// jacokwu
/// 8/9/21 3:45 PM

class GameListPage extends StatefulWidget {
  const GameListPage({Key? key}) : super(key: key);

  @override
  _GameListPageState createState() => _GameListPageState();
}

class _GameListPageState extends State<GameListPage> {
  List<Map<String, dynamic>> _gameList = [
    {
      'title': '扫雷',
      'path': '/ms-home',
    },
    {
      'title': '数独',
      'path': '/sudoku-home',
    },
    {
      'title': '2048',
      'path': '/2048-play',
    },
    {
      'title': '应用宝',
      'path': '/yyb-list',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WAppBar(
        titleConfig: WAppBarTitleConfig(title: '游戏列表'),
        showDefaultBack: true,
      ),
      body: Container(
        padding: EdgeInsets.all(Dimens.pd8),
        child: ListView.separated(
            itemBuilder: (_, index) => _buildItemWidget(_gameList[index]),
            separatorBuilder: (_, index) => CustomDivider(),
            itemCount: _gameList.length),
      ),
    );
  }

  Widget _buildItemWidget(Map<String, dynamic> item) {
    return Card(
      shadowColor: Colors.transparent,
      child: InkWell(
        child: Container(
            padding: EdgeInsets.symmetric(
                horizontal: Dimens.pd16, vertical: Dimens.pd8),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: Dimens.pd8),
              child: Text(item['title']),
            )),
        onTap: () {
          Get.toNamed(item['path']);
        },
      ),
    );
  }
}
