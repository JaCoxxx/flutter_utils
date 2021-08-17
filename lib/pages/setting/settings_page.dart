import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_utils/common/dimens.dart';
import 'package:flutter_utils/utils/clear_cache_utils.dart';
import 'package:flutter_utils/utils/toast_utils.dart';
import 'package:flutter_utils/utils/utils.dart';
import 'package:flutter_utils/widget/custom_scaffold/w_app_bar.dart';
import 'package:flutter_utils/widget/list_item_widget.dart';
import 'package:flutter_utils/widget/widgets.dart';
import 'package:open_app_settings/open_app_settings.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _isAndroid = false;

  int? _cacheBytes;

  String? _cacheValue;

  List _menuList = [];

  @override
  void initState() {
    super.initState();
    _initData();
  }

  _initData() async {
    _getPlatformInfo();
    await _getCacheValue();
    _getMenuList();
  }

  _getPlatformInfo() {
    _isAndroid = Platform.isAndroid;
    setState(() {});
  }

  _getCacheValue() async {
    _cacheBytes = await ClearCacheUtil.total();
    print(_cacheBytes);
    _cacheValue = bytesToSize(_cacheBytes);
    setState(() {});
  }

  _getMenuList() {
    _menuList
      ..clear()
      ..addAll([
        {
          'title': '清理缓存',
          'expandWidget': () => Text(_cacheValue ?? ''),
          'onTap': () async {
            try {
              if (_cacheBytes! <= 0) throw '没有缓存可清理';

              /// 执行清除缓存
              await ClearCacheUtil.clear();

              /// 更新缓存
              await _getCacheValue();

              showToast('缓存清除成功');
            } catch (e) {
              showToast(e.toString());
            }
          },
        },
        {
          'title': '应用信息',
          'onTap': () {
            OpenAppSettings.openAppSettings();
          },
          'onlyAndroid': true,
        },
        {
          'title': '电池优化',
          'onTap': () {
            OpenAppSettings.openBatteryOptimizationSettings();
          },
          'onlyAndroid': true,
        },
        {
          'title': '蓝牙',
          'onTap': () {
            OpenAppSettings.openBluetoothSettings();
          },
          'onlyAndroid': true,
        },
        {
          'title': '移动数据',
          'onTap': () {
            OpenAppSettings.openDataRoamingSettings();
          },
          'onlyAndroid': true,
        },
        {
          'title': '日期和时间',
          'onTap': () {
            OpenAppSettings.openDateSettings();
          },
          'onlyAndroid': true,
        },
        {
          'title': '显示和亮度',
          'onTap': () {
            OpenAppSettings.openDisplaySettings();
          },
          'onlyAndroid': true,
        },
        {
          'title': '储存',
          'onTap': () {
            OpenAppSettings.openInternalStorageSettings();
          },
          'onlyAndroid': true,
        },
        {
          'title': '定位服务',
          'onTap': () {
            OpenAppSettings.openLocationSettings();
          },
          'onlyAndroid': true,
        },
        {
          'title': 'NFC',
          'onTap': () {
            OpenAppSettings.openNFCSettings();
          },
          'onlyAndroid': true,
        },
        {
          'title': '应用通知',
          'onTap': () {
            OpenAppSettings.openNotificationSettings();
          },
          'onlyAndroid': true,
        },
        {
          'title': '安全设置',
          'onTap': () {
            OpenAppSettings.openSecuritySettings();
          },
          'onlyAndroid': true,
        },
        {
          'title': '声音和震动',
          'onTap': () {
            OpenAppSettings.openSoundSettings();
          },
          'onlyAndroid': true,
        },
        {
          'title': 'WIFI设置',
          'onTap': () {
            OpenAppSettings.openWIFISettings();
          },
          'onlyAndroid': true,
        },
      ]);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WAppBar(
        titleConfig: WAppBarTitleConfig(title: '设置'),
        showDefaultBack: true,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: Dimens.pd8),
        child: SingleChildScrollView(
          child: Column(
            children: [
              ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (_, index) {
                  return !_isAndroid && _menuList[index]['onlyAndroid'] == true
                      ? emptyWidget
                      : _buildSettingItem(
                          _menuList[index]['title'],
                          _menuList[index]['iconData'] ?? null,
                          _menuList[index]['onTap'],
                          expandWidget: _menuList[index]['expandWidget'],
                        );
                },
                shrinkWrap: true,
                itemCount: _menuList.length,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingItem(String title, IconData? iconData, VoidCallback onTap, {Widget Function()? expandWidget}) {
    return CustomListItem(
      title: Padding(
        padding: EdgeInsets.symmetric(vertical: Dimens.pd4),
        child: Text(title),
      ),
      leading: iconData == null ? null : Icon(iconData),
      trailing: Row(
        children: [
          if (expandWidget != null) expandWidget(),
          rightArrowIcon,
        ],
      ),
      needDefaultDivider: true,
      backgroundColor: Colors.white,
      onTap: onTap,
    );
  }
}
