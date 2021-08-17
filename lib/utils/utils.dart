import 'dart:async';
import 'dart:io';
import 'dart:math' as Math;

import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

/// 解析get传递的参数
Map<String, dynamic> getParametersDecode(String parameters) {
  Map<String, dynamic> parametersMap = {};
  parameters.split('?')[1].split('&').forEach((element) {
    List keyValue = element.split('=');
    parametersMap[keyValue[0]] = Uri.decodeComponent(keyValue[1]);
  });
  return parametersMap;
}

/// 触摸收起键盘
void hideKeyboard(BuildContext context) {
  FocusScope.of(context).requestFocus(FocusNode());
}

/// 获取读取储存权限
Future<bool> getStoragePower() async {
  if (await Permission.storage.status == PermissionStatus.granted) {
    return true;
  } else {
    bool result = await Permission.storage.request().isGranted;
    if (!result) {
      return Future.delayed(Duration(milliseconds: 100)).then((value) => getStoragePower());
    } else {
      return true;
    }
  }
}

/// 获取下载地址
Future<String> getDownloadPath() async {
  PackageInfo packageInfo = await PackageInfo.fromPlatform();

  Directory dir;
  String path;
  String packageName = packageInfo.packageName;
  if (Platform.isAndroid) {
    dir = (await getExternalStorageDirectory())!;
    path = dir.path.replaceFirst('Android/data/$packageName/files', 'Download');
  } else {
    final dir = await getApplicationDocumentsDirectory();
    path = dir.path;
  }
  return path;
}

/// 判断本地文件是否存在
bool checkFileExist(String path) {
  return File(path).existsSync();
}

/// 字节转换
String bytesToSize(bytes) {
  if (bytes == 0) return '0 B';
  int k = 1024;
  List<String> sizes = ['B', 'KB', 'MB', 'GB', 'TB', 'PB', 'EB', 'ZB', 'YB'];
  int i = (Math.log(bytes) / Math.log(k)).floor();

  double value = bytes / Math.pow(k, i);

  return value.toStringAsFixed(3) + ' ' + sizes[i];
}

/// 获取当前版本信息
Future<String> getAppVersionString() async {
  PackageInfo _info = await PackageInfo.fromPlatform();
  return _info.version;
}

/// 数字加单位
String unitConverter(int num) {
  if (Math.pow(10, 8) <= num) {
    return '${num ~/ Math.pow(10, 8)}亿';
  } else if (Math.pow(10, 4) <= num) {
    return '${num ~/ Math.pow(10, 4)}万';
  } else {
    return num.toString();
  }
}

/// 函数防抖
///
/// [func]: 要执行的方法
/// [delay]: 要迟延的时长
VoidCallback debounceFunc({required Function func, Duration delay = const Duration(milliseconds: 500)}) {
  Timer? timer;
  VoidCallback target = () {
    if (timer?.isActive ?? false) {
      timer?.cancel();
    }
    timer = Timer(delay, () {
      func.call();
    });
  };
  return target;
}

/// 函数节流
///
/// [func]: 要执行的方法
VoidCallback throttleFunc(Future Function() func) {
  bool enable = true;
  VoidCallback target = () {
    if (enable == true) {
      enable = false;
      func().then((_) {
        enable = true;
      });
    }
  };
  return target;
}
