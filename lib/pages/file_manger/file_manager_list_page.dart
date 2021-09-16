import 'dart:ffi';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_utils/common/constants.dart';
import 'package:flutter_utils/common/dimens.dart';
import 'package:flutter_utils/common/model/local_file_item_model.dart';
import 'package:flutter_utils/pages/error/no_data_widget.dart';
import 'package:flutter_utils/pages/file_manger/config/file_manager_config.dart';
import 'package:flutter_utils/pages/file_manger/file_manager_bottom_action.dart';
import 'package:flutter_utils/pages/file_manger/file_manager_setting_page.dart';
import 'package:flutter_utils/pages/file_manger/model/file_setting_model.dart';
import 'package:flutter_utils/utils/dialog_utils.dart';
import 'package:flutter_utils/utils/toast_utils.dart';
import 'package:flutter_utils/utils/utils.dart';
import 'package:flutter_utils/widget/custom_divider.dart';
import 'package:flutter_utils/widget/custom_scaffold/w_app_bar.dart';
import 'package:flutter_utils/widget/custom_text.dart';
import 'package:flutter_utils/widget/list_item_widget.dart';
import 'package:flutter_utils/widget/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

/// jacokwu
/// 8/17/21 4:41 PM

class FileManagerListPage extends StatefulWidget {
  final String? initialPath;

  const FileManagerListPage({Key? key, this.initialPath}) : super(key: key);

  @override
  _FileManagerListPageState createState() => _FileManagerListPageState();
}

class _FileManagerListPageState extends State<FileManagerListPage> {
  late List<LocalFileItemModel> _currentFileList;

  late ScrollController _controller;

  /// 顶级路径
  late String _initialPath;

  /// 当前路径
  late String _currentPath;

  /// 设置信息
  late FileSettingModel _settingValue;

  /// 是否展示下方操作栏
  late bool _showBottomAction;

  /// 是否展示多选框
  late bool _showMultiSelector;

  /// 选中的列表
  late List<LocalFileItemModel> _selectedList;

  /// 当前文件夹title
  String get _currentTitle => _showMultiSelector
      ? (_selectedList.length == 0 ? '未选择' : '已选择 ${_selectedList.length} 项')
      : (_currentPath == _initialPath ? '文件管理' : _getFileName(Directory(_currentPath)));

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
    _currentFileList = [];
    _currentPath = '';
    _initialPath = '';
    _showBottomAction = false;
    _showMultiSelector = false;
    _selectedList = [];
    _settingValue = FileManagerConfig.defaultSettingValue;
    _initData();
  }

  _initData() async {
    await getStoragePower();
    await _getSettingValue();
    if (widget.initialPath != null) {
      _currentPath = widget.initialPath!;
      _initialPath = widget.initialPath!;
    } else if (Platform.isAndroid) {
      _currentPath = '/storage/emulated/0';
      _initialPath = '/storage/emulated/0';
    } else {
      Directory douDir = await getApplicationDocumentsDirectory();
      _currentPath = douDir.parent.path;
      _initialPath = douDir.parent.path;
    }
    _getCurrentDir();
    setState(() {});
  }

  _getSettingValue() async {
    FileSettingModel? cacheValue = await FileManagerConfig.getSetting();
    _settingValue = cacheValue == null ? FileManagerConfig.defaultSettingValue : cacheValue;
    setState(() {});
  }

  _getCurrentDir() async {
    List<LocalFileItemModel> _files = [];
    List<LocalFileItemModel> _folder = [];
    Directory currentDir = Directory(_currentPath);
    print(currentDir.path);
    for (FileSystemEntity file in currentDir.listSync()) {
      String fileName = _getFileName(file);
      if (!_settingValue.showHiddenFile && fileName.startsWith('.')) continue;
      if (FileSystemEntity.isFileSync(file.path)) {
        _files
            .add(LocalFileItemModel(file: file, isFolder: false, fileName: fileName, suffix: getFileSuffix(fileName)));
      } else
        _folder.add(LocalFileItemModel(file: file, isFolder: true, fileName: fileName));
    }
    _files.sort((a, b) => a.fileName.toLowerCase().compareTo(b.fileName.toLowerCase()));
    _folder.sort((a, b) => a.fileName.toLowerCase().compareTo(b.fileName.toLowerCase()));
    _currentFileList
      ..clear()
      ..addAll(_folder.map<LocalFileItemModel>((e) => e))
      ..addAll(_files.map<LocalFileItemModel>((e) => e));
    if (_controller.hasClients) _controller.jumpTo(0);
    setState(() {});
  }

  String _getFileName(FileSystemEntity fileSystemEntity) {
    return fileSystemEntity.path.substring(fileSystemEntity.parent.path.length + 1);
  }

  void _onTapItem(LocalFileItemModel itemModel) {
    if (_showMultiSelector) {
      _selectedList.contains(itemModel) ? _selectedList.remove(itemModel) : _selectedList.add(itemModel);
      setState(() {});
    } else if (itemModel.isFolder) {
      _currentPath = itemModel.file.path;
      _getCurrentDir();
    } else {
      OpenFile.open(itemModel.file.path,
          type: FileManagerConfig.fileOpenType['.${(itemModel.suffix ?? '').toLowerCase()}']);
      // print(itemModel.file.resolveSymbolicLinksSync());
      // print(itemModel.file.uri);
      // print(itemModel.file.statSync().size);
      // print(itemModel.file.statSync().type);
    }
  }

  void _onLongPressItem(LocalFileItemModel itemModel) {
    if (_showMultiSelector) {
      _selectedList.contains(itemModel) ? _selectedList.remove(itemModel) : _selectedList.add(itemModel);
    } else {
      _showBottomAction = true;
      _showMultiSelector = true;
      _selectedList
        ..clear()
        ..add(itemModel);
    }
    setState(() {});
  }

  _createNewFolder() async {
    showBottomInputDialog(context, title: '新建文件夹', initialValue: '新建文件夹', onConfirm: (value) async {
      if (isStringEmpty(value)) {
        showToast('请输入文件夹名称');
      } else {
        var file = Directory('$_currentPath/$value');
        try {
          bool exists = await file.exists();
          if (!exists) {
            await file.create();
            showToast('新建成功');
            Get.back();
            _getCurrentDir();
          } else {
            showToast('文件夹已存在');
          }
        } catch (e) {
          print(e);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_showMultiSelector || _showBottomAction) {
          _showMultiSelector = false;
          _showBottomAction = false;
          setState(() {});
          return false;
        }
        if (_currentPath == _initialPath) {
          return true;
        } else {
          _currentPath = Directory(_currentPath).parent.path;
          _getCurrentDir();
          return false;
        }
      },
      child: Scaffold(
        appBar: WAppBar(
          titleConfig: WAppBarTitleConfig(title: _currentTitle, centerTitle: false),
          showDefaultBack: true,
          backIcon: _showMultiSelector ? Icon(Icons.clear) : null,
          onClickBackBtn: () {
            if (_showMultiSelector || _showBottomAction) {
              _showMultiSelector = false;
              _showBottomAction = false;
              setState(() {});
            } else if (_currentPath == _initialPath) {
              Get.back();
            } else {
              _currentPath = Directory(_currentPath).parent.path;
              _getCurrentDir();
            }
          },
          rightAction: _showMultiSelector
              ? Checkbox(
                  value: _selectedList.length == _currentFileList.length,
                  onChanged: (value) {
                    if (value == true) {
                      _selectedList
                        ..clear()
                        ..addAll(_currentFileList);
                    } else {
                      _selectedList.clear();
                    }
                    setState(() {});
                  },
                )
              : PopupMenuButton<String>(
                  itemBuilder: (_) {
                    return [
                      PopupMenuItem<String>(
                        value: 'setting',
                        child: CustomText.title('设置'),
                      ),
                      PopupMenuItem<String>(
                        value: 'new',
                        child: CustomText.title('新建文件夹'),
                      ),
                    ];
                  },
                  onSelected: (value) async {
                    print(value);
                    switch (value) {
                      case 'setting':
                        await Get.to(FileManagerSettingPage());
                        _initData();
                        break;
                      case 'new':
                        await _createNewFolder();
                        break;
                      default:
                        break;
                    }
                  },
                ),
        ),
        body: Container(
          color: Colors.white,
          child: Column(
            children: [
              Expanded(
                child: _currentFileList.length == 0
                    ? _buildEmptyLayout()
                    : _settingValue.fileLayoutType
                        ? _buildListLayout()
                        : _buildGridLayout(),
              ),
              if (_showBottomAction)
                FileManagerBottomAction(
                  selectedFileList: _selectedList,
                  refresh: () {
                    _showMultiSelector = false;
                    _showBottomAction = false;
                    _selectedList.clear();
                    _getCurrentDir();
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  /// 空
  Widget _buildEmptyLayout() {
    return NoDataWidget(
      buildImage: (_) => Icon(
        FontAwesomeIcons.folder,
        size: ScreenUtil().setWidth(100),
        color: Constants.gray_9,
      ),
      emptyString: '没有文件',
    );
  }

  /// 列表样式布局
  Widget _buildListLayout() {
    return ListView.separated(
      controller: _controller,
      itemBuilder: (_, index) => _buildListItemWidget(index),
      separatorBuilder: (_, index) => CustomDivider(),
      itemCount: _currentFileList.length + 1,
      shrinkWrap: true,
    );
  }

  Widget _buildListItemWidget(int index) {
    if (index == 0)
      return _currentPath == _initialPath
          ? emptyWidget
          : CustomListItem(
              backgroundColor: Colors.white,
              title: _buildTitleWidget('. . .'),
              onTap: _showMultiSelector
                  ? null
                  : () {
                      if (_currentPath == _initialPath) {
                        showToast('已经是顶级目录了');
                      } else {
                        _currentPath = Directory(_currentPath).parent.path;
                        _getCurrentDir();
                      }
                    },
            );
    else {
      LocalFileItemModel _itemModel = _currentFileList[index - 1];
      return _buildListFileWidget(_itemModel);
    }
  }

  Widget _buildListFileWidget(LocalFileItemModel itemModel) {
    return CustomListItem(
      backgroundColor:
          _showMultiSelector && _selectedList.contains(itemModel) ? Constants.lightLineColor : Colors.white,
      title: _buildTitleWidget(itemModel.fileName),
      subtitle: _buildSubTitle(itemModel),
      leading: Icon(itemModel.isFolder ? FontAwesomeIcons.folder : FileManagerConfig.getFileIcon(itemModel.suffix)),
      onTap: () => _onTapItem(itemModel),
      onLongPress: () => _onLongPressItem(itemModel),
    );
  }

  /// grid样式布局
  Widget _buildGridLayout() {
    return GridView.builder(
      padding: EdgeInsets.symmetric(horizontal: Dimens.pd16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
      itemBuilder: (_, index) => _buildGridItemWidget(index, _currentFileList[index]),
      itemCount: _currentFileList.length,
      controller: _controller,
      shrinkWrap: true,
    );
  }

  Widget _buildGridItemWidget(int index, LocalFileItemModel itemModel) {
    return GestureDetector(
      onTap: () => _onTapItem(itemModel),
      onLongPress: () => _onLongPressItem(itemModel),
      child: Card(
        shadowColor: Colors.transparent,
        color: _showMultiSelector && _selectedList.contains(itemModel) ? Constants.lightLineColor : Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              itemModel.isFolder ? FontAwesomeIcons.folder : FileManagerConfig.getFileIcon(itemModel.suffix),
              size: Dimens.font_size_32,
            ),
            _buildTitleWidget(itemModel.fileName),
            CustomText.content(itemModel.file.statSync().modified.toString().substring(0, 10)),
          ],
        ),
      ),
    );
  }

  Widget _buildTitleWidget(String title) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: Dimens.pd8),
      child: CustomText.title(title),
    );
  }

  Widget _buildSubTitle(LocalFileItemModel itemModel) {
    return Row(
      children: [
        CustomText.content(itemModel.file.statSync().modified.toString().substring(0, 16)),
      ],
    );
  }
}
