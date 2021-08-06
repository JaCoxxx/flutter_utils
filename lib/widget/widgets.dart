import 'package:flutter/material.dart';

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
