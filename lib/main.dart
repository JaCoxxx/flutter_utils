import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_utils/common/constants.dart';
import 'package:flutter_utils/common/main_theme_data.dart';
import 'package:flutter_utils/pages/main/my_app.dart';
import 'package:flutter_utils/pages/wrapper/bloc_wrapper.dart';
import 'package:flutter_utils/utils/request.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  if (Platform.isAndroid) {
    // 设置状态栏背景及颜色
    SystemUiOverlayStyle systemUiOverlayStyle =
        SystemUiOverlayStyle(statusBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
    // SystemChrome.setEnabledSystemUIOverlays([]); //隐藏状态栏
  }
  MainThemeData.init(MainThemeData.lightTheme);

  // AudioPlayer.logEnabled = true;

  Request().setEnableDebugPrint(true);

  EasyRefresh.defaultHeader = BezierCircleHeader(backgroundColor: Colors.transparent, color: Colors.blue);
  EasyRefresh.defaultFooter = BezierBounceFooter(backgroundColor: Colors.transparent, color: Colors.blue);

  runApp(BlocWrapper(child: MyApp()));
}
