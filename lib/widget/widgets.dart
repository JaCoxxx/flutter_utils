import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

/// 空组件
const emptyWidget = SizedBox(width: 0, height: 0);

/// 右箭头
const rightArrowIcon = Icon(Icons.keyboard_arrow_right, size: 24, color: Color(0xFF999999));

/// 安全距离 - bottom
Widget safeAreaBottom(context) => SizedBox(height: MediaQuery.of(context).padding.bottom);

/// 安全距离 - top
Widget safeAreaTop(context) => SizedBox(height: MediaQuery.of(context).padding.top);

/// 安全距离 - left
Widget safeAreaLeft(context) => SizedBox(height: MediaQuery.of(context).padding.left);

/// 安全距离 - right
Widget safeAreaRight(context) => SizedBox(height: MediaQuery.of(context).padding.right);

/// 必输效果
Widget requiredText() => Text(
    '*',
    style: TextStyle(
        color: Colors.red,
        fontSize: 16.0
    ),
  );

/// 页面loading
Widget pageLoading(context) => Container(
  width: double.infinity,
  height: double.infinity,
  child: Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          width: 50.0,
          height: 50.0,
          child: SpinKitFadingCube(
            color: Theme.of(context).primaryColor,
            size: 25.0,
          ),
        ),
        Container(
          child: Text('加载中...'),
        )
      ],
    ),
  ),
);
