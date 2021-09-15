import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_utils/common/constants.dart';
import 'package:flutter_utils/common/dimens.dart';
import 'package:flutter_utils/pages/file_manger/config/file_manager_config.dart';
import 'package:flutter_utils/pages/file_manger/model/file_setting_model.dart';
import 'package:flutter_utils/widget/custom_scaffold/w_app_bar.dart';
import 'package:settings_ui/settings_ui.dart';

/// jacokwu
/// 9/10/21 3:19 PM

class FileManagerSettingPage extends StatefulWidget {
  const FileManagerSettingPage({Key? key}) : super(key: key);

  @override
  _FileManagerSettingPageState createState() => _FileManagerSettingPageState();
}

class _FileManagerSettingPageState extends State<FileManagerSettingPage> {
  late FileSettingModel _settingValue;

  @override
  void initState() {
    super.initState();
    _settingValue = FileManagerConfig.defaultSettingValue;
    _getCacheSettingValue();
  }

  _getCacheSettingValue() async {
    FileSettingModel? cacheValue = await FileManagerConfig.getSetting();
    _settingValue =
        cacheValue == null ? FileSettingModel.fromJson(FileManagerConfig.defaultSettingValue.toJson()) : cacheValue;
    setState(() {});
  }

  _setSettingValue() {
    FileManagerConfig.saveSetting(_settingValue);
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
        child: SettingsList(
          sections: [
            SettingsSection(
              title: '基础设置',
              titlePadding: EdgeInsets.symmetric(vertical: Dimens.pd8, horizontal: Dimens.pd16),
              titleTextStyle: TextStyle(color: Constants.gray_9, fontSize: Dimens.font_size_16),
              tiles: [
                SettingsTile.switchTile(
                  title: '显示隐藏文件',
                  onToggle: (value) {
                    _settingValue.showHiddenFile = value;
                    _setSettingValue();
                  },
                  switchValue: _settingValue.showHiddenFile,
                ),
                SettingsTile.switchTile(
                  title: '以列表形式展示',
                  onToggle: (value) {
                    _settingValue.fileLayoutType = value;
                    _setSettingValue();
                  },
                  switchValue: _settingValue.fileLayoutType,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
