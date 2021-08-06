import 'package:flutter/material.dart';
import 'package:flutter_utils/common/dimens.dart';
import 'package:flutter_utils/common/model/sudoku_detail_model.dart';
import 'package:flutter_utils/pages/juhe/page/sudoku/sudoku_config.dart';
import 'package:flutter_utils/pages/juhe/request/post_http.dart';
import 'package:flutter_utils/utils/toast_utils.dart';
import 'package:flutter_utils/widget/custom_scaffold/w_app_bar.dart';
import 'package:get/get.dart';

/// jacokwu
/// 8/5/21 10:17 AM

class SudokuPlayPage extends StatefulWidget {
  const SudokuPlayPage({Key? key}) : super(key: key);

  @override
  _SudokuPlayPageState createState() => _SudokuPlayPageState();
}

class _SudokuPlayPageState extends State<SudokuPlayPage> {
  List<List<SudokuDetailModel>> _playData = [];

  /// 当前点击点的大小宫坐标
  List<int> _currentIndex = [];

  /// 当前点击点的rc
  List<int> _currentRC = [];

  /// 当前点击点
  SudokuDetailModel? _currentGrid;

  /// 未做格子坐标
  List<List<int>> _undoRCList = [];

  /// 配置信息
  Map<String, dynamic> _gameConfig = {};

  bool _isShowBottomSheet = false;

  bool _gameIsOver = false;

  @override
  void initState() {
    super.initState();
    _gameConfig = Get.arguments;
    if (_gameConfig['cacheGame'] != null) {
      _initCacheData();
    } else {
      _getPlayData();
    }
  }

  _initCacheData() {
    _playData = _gameConfig['cacheGame'];
    _getUndoGrid();
    setState(() {});
  }

  _getPlayData() {
    showLoading();
    JuHePostHttp.getSudokuPlayData(_gameConfig['diff']).then((value) {
      if (value['error_code'] == 0) {
        Map result = _formatFetchData(value['result']);
        print(result);
        _playData
          ..clear()
          ..addAll(result['puzzle']
              .asMap()
              .keys
              .map<List<SudokuDetailModel>>((e) {
            List<int> gridValue = result['puzzle'][e].map<int>((item) => item as int).toList();
            return gridValue.asMap().keys.map<SudokuDetailModel>((ele) {
              int cardValue = gridValue[ele];
              return SudokuDetailModel(
                  value: cardValue,
                  isInitial: cardValue != 0,
                  answer: result['solution'][e][ele] as int,
                  rc: getCoordinate(e, ele));
            }).toList();
          }));
        _getUndoGrid();
        setState(() {});
      } else {
        showToast(value['reason']);
      }
      dismissLoading();
    });
  }

  /// 将请求数据格式化
  Map _formatFetchData(Map dataSource) {
    print(dataSource);
    Map result = {};
    result['puzzle'] = List.filled(9, <int>[]);
    result['solution'] = List.filled(9, <int>[]);
    for (int x = 0; x < 9; x ++) {
      result['puzzle'][x] = List.filled(9, 0);
      result['solution'][x] = List.filled(9, 0);
      for (int y = 0; y < 9; y ++) {
        print('x-$x,y-$y,r-${x ~/ 3 * 3 + y ~/ 3},c-${x % 3 * 3 + y % 3},data-${dataSource['puzzle'][x ~/ 3 * 3 + y ~/ 3][x % 3 * 3 + y % 3]}');
        result['puzzle'][x][y] = dataSource['puzzle'][x ~/ 3 * 3 + y ~/ 3][x % 3 * 3 + y % 3] as int;
        result['solution'][x][y] = dataSource['solution'][x ~/ 3 * 3 + y ~/ 3][x % 3 * 3 + y % 3] as int;
      }
    }
    return result;
  }

  /// 筛选出所有未完成的格子
  _getUndoGrid() {
    _undoRCList.clear();
    _playData.forEach((element) {
      element.forEach((e) {
        if (e.value == 0) {
          _undoRCList.add(e.rc);
        }
      });
    });
    setState(() {});
  }

  /// 增加未完成格子
  _addUndoGrid(List<int> value) {
    if (_undoRCList.indexWhere((element) => element == value) != -1) return;
    _undoRCList.add(value);
    setState(() {});
  }

  /// 减少未完成格子
  _dropUndoGrid(List<int> value) {
    if (_undoRCList.length == 0) _checkGameResult();
    if (_undoRCList.indexWhere((element) => element == value) == -1) return;
    _undoRCList.remove(value);
    setState(() {});
  }

  /// 判断游戏结果
  _checkGameResult() {
    bool _hasError = false;
    _playData.forEach((element) {
      element.forEach((e) {
        if (e.value != e.answer) {
          _hasError = true;
        }
      });
    });
    _gameIsOver = !_hasError;
    setState(() {});
  }

  /// 保存游戏
  _saveGame() async {
    await SudokuConfig.saveGame(_playData);
  }

  /// 修改标记状态
  _setMark() {
    _playData[_currentIndex[0]][_currentIndex[1]].isMarkStatus =
        !_playData[_currentIndex[0]][_currentIndex[1]].isMarkStatus;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WAppBar(
        titleConfig: WAppBarTitleConfig(
          title:
              '数独${_gameConfig['diffValue'] == null ? '' : '-${_gameConfig['diffValue']}'}',
        ),
        showDefaultBack: true,
        onClickBackBtn: () {
          if (!_gameIsOver)
          showDialog(
              context: context,
              builder: (_) {
                return AlertDialog(
                  title: Text('提示'),
                  content: Text('确认退出吗？'),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Get.back();
                        },
                        child: Text('取消')),
                    TextButton(
                        onPressed: () async {
                          Get.back();
                          await _saveGame();
                          Get.back();
                        },
                        child: Text('确认')),
                  ],
                );
              });
          else Get.back();
        },
      ),
      body: Container(
        child: Column(
          children: [
            Dimens.hGap6,
            if (_playData.length > 0)
            _buildContainer(),
            if (_playData.length > 0 && _undoRCList.length == 0 && _gameIsOver)
              Expanded(
                child: Container(
                  child: Center(
                    child: Text('恭喜你！答案完全正确'),
                  ),
                ),
              ),
            if (_playData.length > 0 && _undoRCList.length == 0 && !_gameIsOver)
              Expanded(
                child: Container(
                  child: Center(
                    child: Text('答案还有问题，再检查一下吧～'),
                  ),
                ),
              ),
            Spacer(),
            Dimens.hGap16,
            if (_isShowBottomSheet) _buildBottomSheet(),
          ],
        ),
      ),
    );
  }

  Widget _buildContainer() {
    return Container(
      color: Colors.black,
      padding: EdgeInsets.all(Dimens.pd2),
      child: MediaQuery.removePadding(
        context: context,
        removeBottom: true,
        removeTop: true,
        child: GridView.builder(
            itemCount: _playData.length,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 2,
              crossAxisSpacing: 2,
            ),
            itemBuilder: (_, index) =>
                _buildGridContent(index, _playData[index])),
      ),
    );
  }

  /// 渲染每一个宫
  Widget _buildGridContent(int bigIndex, List<SudokuDetailModel> gridValue) {
    return GridView.builder(
        itemCount: gridValue.length,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 1,
          crossAxisSpacing: 1,
        ),
        itemBuilder: (_, index) =>
            _buildItemContent(bigIndex, index, gridValue[index]));
  }

  /// 渲染单个格子
  Widget _buildItemContent(
      int bigIndex, int smallIndex, SudokuDetailModel item) {
    return Container(
      color: item.isSelected
          ? Colors.orange.shade300
          : item.isHighlight
              ? Colors.lightBlue.shade50
              : Colors.white,
      child: !item.isInitial
          ? TextButton(
              style: ButtonStyle(
                padding: MaterialStateProperty.all(EdgeInsets.zero),
              ),
              onPressed: () {
                setHighlight(item, bigIndex);
                _currentIndex = [bigIndex, smallIndex];
                _currentRC = item.rc;
                _currentGrid = item;
                if (!_isShowBottomSheet) {
                  _isShowBottomSheet = true;
                }
                setState(() {});
              },
              child: item.isMarkStatus
                  ? _buildMarkContent(item.markList)
                  : Text(
                      item.value == 0 ? '' : item.value.toString(),
                      style: TextStyle(
                          color: Colors.orange.shade600,
                          fontWeight: FontWeight.w600,
                          fontSize: Dimens.font_size_18),
                    ))
          : Center(
              child: Text(
              item.value.toString(),
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: Dimens.font_size_18),
            )),
    );
  }

  /// 渲染标记内容
  Widget _buildMarkContent(List<int> markList) {
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      removeBottom: true,
      removeLeft: true,
      removeRight: true,
      child: GridView.builder(
          itemCount: 9,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
          ),
          itemBuilder: (_, index) {
            return Center(
              child: Text(
                markList.contains(index + 1) ? (index + 1).toString() : '',
                style: TextStyle(color: Colors.orange.shade600, fontSize: 10),
              ),
            );
          }),
    );
  }

  /// 渲染键盘
  Widget _buildBottomSheet() {
    List<Map<String, dynamic>> _keyboardList = SudokuConfig.keyboardList;
    return Container(
      color: Colors.white,
      child: GridView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: _keyboardList.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            childAspectRatio: 2,
          ),
          itemBuilder: (_, index) {
            return Container(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  TextButton(
                    child: Text(
                      _keyboardList[index]['value'],
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                          fontSize: Dimens.font_size_16),
                    ),
                    onPressed: () {
                      onClickKeyboard(_keyboardList[index]);
                    },
                  ),
                  if (_currentGrid != null &&
                      _currentGrid!.isMarkStatus &&
                      '123456789'.contains(_keyboardList[index]['key']))
                    Positioned(
                      right: 10,
                      top: 10,
                      child: Container(
                        width: 5,
                        height: 5,
                        decoration: BoxDecoration(
                            color: _currentGrid!.markList.contains(
                                    int.parse(_keyboardList[index]['key']))
                                ? Colors.orange.shade600
                                : Colors.orange.shade100,
                            borderRadius: BorderRadius.circular(50)),
                      ),
                    ),
                ],
              ),
            );
          }),
    );
  }

  /// 获取点坐标
  List<int> getCoordinate(int bigIndex, int smallIndex) {
    late int r;
    late int c;
    c = bigIndex % 3 * 3 + smallIndex % 3 + 1;
    r = bigIndex ~/ 3 * 3 + smallIndex ~/ 3 + 1;
    return [r, c];
  }

  /// 设置高亮区域及点击区域
  setHighlight(SudokuDetailModel clickItem, int bigIndex) {
    _playData.forEach((element) {
      element.forEach((e) {
        e.isHighlight = false;
        e.isSelected = false;
        if (e.rc[0] == clickItem.rc[0] ||
            e.rc[1] == clickItem.rc[1] ||
            _playData.indexWhere((ele) => element == ele) == bigIndex) {
          e.isHighlight = true;
        }
        if (e.rc[0] == clickItem.rc[0] && e.rc[1] == clickItem.rc[1]) {
          e.isSelected = true;
        }
      });
    });
    setState(() {});
  }

  /// 点击虚拟键盘
  onClickKeyboard(Map<String, dynamic> keyboardItem) {
    switch (keyboardItem['key']) {
      case '1':
      case '2':
      case '3':
      case '4':
      case '5':
      case '6':
      case '7':
      case '8':
      case '9':
        int value = int.parse(keyboardItem['key']);
        if (_currentGrid!.isMarkStatus) {
          // 标记状态下
          if (_currentGrid!.markList.contains(value)) {
            _currentGrid!.markList.remove(value);
          } else {
            _currentGrid!.markList.add(value);
          }
          setState(() {});
        } else {
          // 非标记状态下
          _playData[_currentIndex[0]][_currentIndex[1]].value = value;
          _dropUndoGrid(_currentRC);
        }

        break;
      case 'del':
        _playData[_currentIndex[0]][_currentIndex[1]].value = 0;
        _playData[_currentIndex[0]][_currentIndex[1]].markList = [];
        _playData[_currentIndex[0]][_currentIndex[1]].isMarkStatus = false;
        _addUndoGrid(_currentRC);
        break;
      case 'mark':
        _setMark();
        break;
      default:
        break;
    }
    setState(() {});
  }
}
