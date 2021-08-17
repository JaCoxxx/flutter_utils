import 'package:flutter/material.dart';
import 'package:flutter_utils/common/dimens.dart';
import 'package:flutter_utils/common/model/sudoku_detail_model.dart';
import 'package:flutter_utils/pages/juhe/page/sudoku/sudoku_config.dart';
import 'package:flutter_utils/utils/toast_utils.dart';
import 'package:get/get.dart';
import 'package:multi_select_flutter/dialog/mult_select_dialog.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';

/// jacokwu
/// 8/4/21 7:15 PM

class SudokuHomePage extends StatefulWidget {
  const SudokuHomePage({Key? key}) : super(key: key);

  @override
  _SudokuHomePageState createState() => _SudokuHomePageState();
}

class _SudokuHomePageState extends State<SudokuHomePage> {
  String _gameDiff = 'easy';
  List<List<SudokuDetailModel>>? _cacheGame;

  @override
  void initState() {
    super.initState();
    initData();
  }

  initData() async {
    await getCacheGameInfo();
    await getGameDiff();
  }

  getGameDiff() async {
    _gameDiff = await SudokuConfig.getDiff() ?? 'easy';
    setState(() {});
  }

  // 获取游戏难度显示值
  String getGamaDiff() {
    return SudokuConfig.difficultyList
        .firstWhere((element) => element['key'] == _gameDiff)['value'];
  }

  // 获取本地游戏数据
  getCacheGameInfo() async {
    List<List<SudokuDetailModel>>? cacheValue =
        await SudokuConfig.getCacheGame();
    _cacheGame = cacheValue;
    print(_cacheGame);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_cacheGame != null)
                _buildItemButton('继续游戏', () {
                  Get.toNamed('/sudoku-play', arguments: {
                    'diff': _gameDiff,
                    'diffValue': getGamaDiff(),
                    'cacheGame': _cacheGame,
                  })!
                      .then((value) {
                    initData();
                  });
                }),
              _buildItemButton('开始游戏', () {
                if (_cacheGame != null) {
                  showSimpleAlertDialog(context,
                      content: '开始新游戏会清除之前保存的游戏进度，是否继续?',
                      showCancel: true,
                      confirmText: '继续', confirmFunc: () {
                    SudokuConfig.clearGame();
                    Get.toNamed('/sudoku-play', arguments: {
                      'diff': _gameDiff,
                      'diffValue': getGamaDiff(),
                    })!
                        .then((value) {
                      initData();
                    });
                  });
                } else {
                  Get.toNamed('/sudoku-play', arguments: {
                    'diff': _gameDiff,
                    'diffValue': getGamaDiff(),
                  })!
                      .then((value) {
                    initData();
                  });
                }
              }),
              _buildItemButton('选择难度：${getGamaDiff()}', () {
                int index = SudokuConfig.difficultyList
                    .indexWhere((element) => element['key'] == _gameDiff);

                _gameDiff = SudokuConfig.difficultyList[
                    index == SudokuConfig.difficultyList.length - 1
                        ? 0
                        : index + 1]['key'];
                SudokuConfig.setDiff(_gameDiff);
                setState(() {});
              }),
              _buildItemButton('退出游戏', () {
                showSimpleAlertDialog(context,
                    content: '确认退出吗?',
                    showCancel: true,
                    disabledBack: true, confirmFunc: () {
                  Get.back();
                });
              }),
            ],
          ),
        ),
      ),
    );
  }

  void _showMultiSelect(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (ctx) {
        return MultiSelectDialog(
          title: Text('选择难度'),
          items: SudokuConfig.difficultyList
              .map<MultiSelectItem>(
                  (e) => MultiSelectItem(e['key'], e['value']))
              .toList(),
          initialValue: [],
          onSelectionChanged: (values) {
            print(values);
          },
          searchHint: '搜索',
          confirmText: Text('确定'),
          cancelText: Text('取消'),
          onConfirm: (values) {
            print(values);
          },
        );
      },
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
