import 'package:flutter/material.dart';

/// jacokwu
/// 8/4/21 4:15 PM

class GridTableUtils {

  /// 获取定位信息
  static AlignmentGeometry getAlignment(String? align) {
    switch (align) {
      case 'cl':
      case 'centerLeft':
        return Alignment.centerLeft;
      case 'cr':
      case 'centerRight':
        return Alignment.centerRight;
      case 'tc':
      case 'topCenter':
        return Alignment.topCenter;
      case 'tl':
      case 'topLeft':
        return Alignment.topLeft;
      case 'tr':
      case 'topRight':
        return Alignment.topRight;
      case 'bc':
      case 'bottomCenter':
        return Alignment.bottomCenter;
      case 'bl':
      case 'bottomLeft':
        return Alignment.bottomLeft;
      case 'br':
      case 'bottomRight':
        return Alignment.bottomRight;
      case 'center':
      default:
        return Alignment.center;
    }
  }
}
