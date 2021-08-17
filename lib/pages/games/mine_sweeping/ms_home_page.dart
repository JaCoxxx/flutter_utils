import 'package:flutter/material.dart';
import 'package:flutter_utils/common/dimens.dart';
import 'package:flutter_utils/utils/toast_utils.dart';
import 'package:get/get.dart';

import 'ms_config.dart';

/// jacokwu
/// 8/10/21 2:44 PM

class MSHomePage extends StatefulWidget {
  const MSHomePage({Key? key}) : super(key: key);

  @override
  _MSHomePageState createState() => _MSHomePageState();
}

class _MSHomePageState extends State<MSHomePage> {
  int _gameDiff = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildItemButton('开始游戏', () {
                Get.toNamed('/ms-play', arguments: {'diff': _gameDiff});
              }),
              _buildItemButton('选择难度：${MSConfig.difficultyList[_gameDiff]}', () {
                _gameDiff = _gameDiff == MSConfig.difficultyList.length - 1 ? 0 : _gameDiff + 1;
                setState(() {});
              }),
              _buildItemButton('退出游戏', () {
                showSimpleAlertDialog(context, content: '确认退出吗?', showCancel: true, disabledBack: true,
                    confirmFunc: () {
                  Get.back();
                });
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildItemButton(String title, void Function() onPressed) {
    return RawMaterialButton(
      child: Text(
        title,
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w500,
          fontSize: Dimens.font_size_18,
        ),
      ),
      onPressed: onPressed,
    );
  }
}
