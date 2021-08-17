import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_utils/common/constants.dart';
import 'package:flutter_utils/common/dimens.dart';
import 'package:flutter_utils/common/model/ms_detail_model.dart';
import 'package:flutter_utils/utils/toast_utils.dart';
import 'package:flutter_utils/widget/custom_scaffold/w_app_bar.dart';
import 'package:flutter_utils/widget/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

/// jacokwu
/// 8/9/21 3:44 PM

class MSPlayPage extends StatefulWidget {
  const MSPlayPage({Key? key}) : super(key: key);

  @override
  _MSPlayPageState createState() => _MSPlayPageState();
}

class _MSPlayPageState extends State<MSPlayPage> {
  /// 单个格子宽度
  static const double _gridWidth = 48.80;

  /// 单行数量枚举
  static const List<int> _lineCountList = [8, 16, 30];

  /// 总个数枚举
  static const List<int> _gridTotalCountList = [64, 256, 480];

  /// 雷数量枚举
  static const List<int> _mineCountList = [10, 40, 99];

  /// 数字颜色枚举
  static const List<Color> _numColorList = [
    Color(0xFF2C00FF),
    Color(0xFF238000),
    Color(0xFFF30101),
    Color(0xFF110080),
    Color(0xFF800000),
    Color(0xFF008080),
    Color(0xFF000000),
    Color(0xFF808080)
  ];

  /// 单行数量
  late int _lineCount;

  /// 雷数量
  late int _mineCount;

  /// 难度系数 0 - 2
  late int _diffFactor;

  /// 格子总数量
  late int _gridTotalCount;

  /// 表格基础数据
  late List<MSDetailModel> _playData = [];

  /// 雷数据下标
  late List<int> _mineData;

  /// 标记数据下标
  late List<int> _markData;

  /// 游戏是否失败
  bool _gameOver = false;

  /// 游戏是否结束
  bool _gameFinish = false;

  /// 计时器
  int _time = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  @override
  void dispose() {
    super.dispose();
    if (_timer != null) _timer!.cancel();
  }

  _initData() {
    _diffFactor = Get.arguments['diff'] ?? 0;
    _lineCount = _lineCountList[_diffFactor];
    _gridTotalCount = _gridTotalCountList[_diffFactor];
    _mineCount = _mineCountList[_diffFactor];
    _mineData = [];
    _markData = [];
    _playData = [];

    _time = 0;
    if (_timer != null) _timer!.cancel();

    _gameFinish = false;
    _gameOver = false;

    _getBasePlayData();
    _getMineData();
    _setTimer();

    setState(() {});
  }

  /// 计时器
  _setTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      _time += 1;
      setState(() {});
    });
  }

  /// 生成基础数据
  _getBasePlayData() {
    for (int i = 0; i < _gridTotalCount; i++) {
      _playData.add(MSDetailModel(xy: [i ~/ _lineCount, i % _lineCount]));
    }
  }

  /// 计算附近雷的数量
  _getNearbyMineCount(int subscript) {
    List<int> _subscriptList = _getNearBySubscriptList(subscript);
    _subscriptList.forEach((element) {
      _playData[element].mineNum += 1;
    });
  }

  /// 获取所有雷的下标
  _getMineData() {
    _mineData = [];
    do {
      Random _random = Random();
      int _randomData = _random.nextInt(_gridTotalCount);
      if (!_mineData.contains(_randomData)) {
        _mineData.add(_randomData);
        _playData[_randomData].isMine = true;
        // 给附近格子的数量加一
        _getNearbyMineCount(_randomData);
      }
    } while (_mineData.length < _mineCount);
    _mineData.sort();
  }

  /// 获取当前下标附近下标集合
  List<int> _getNearBySubscriptList(int subscript) {
    List<int> _subscriptList = [];
    try {
      // 左上角 / 左侧第一列不考虑
      if (subscript - _lineCount - 1 >= 0 && subscript % _lineCount != 0) {
        _subscriptList.add(subscript - _lineCount - 1);
      }
      // 上方
      if (subscript - _lineCount >= 0) {
        _subscriptList.add(subscript - _lineCount);
      }
      // 右上角 / 右侧第一列不考虑
      if (subscript - _lineCount + 1 >= 0 && (subscript + 1) % _lineCount != 0) {
        _subscriptList.add(subscript - _lineCount + 1);
      }
      // 左侧 / 左侧第一列不考虑
      if (subscript - 1 >= 0 && subscript % _lineCount != 0) {
        _subscriptList.add(subscript - 1);
      }
      // 左下角 / 左侧第一列不考虑
      if (subscript + _lineCount - 1 < _gridTotalCount && subscript % _lineCount != 0) {
        _subscriptList.add(subscript + _lineCount - 1);
      }
      // 下方
      if (subscript + _lineCount < _gridTotalCount) {
        _subscriptList.add(subscript + _lineCount);
      }
      // 右下角 / 右侧第一列不考虑
      if (subscript + _lineCount + 1 < _gridTotalCount && (subscript + 1) % _lineCount != 0) {
        _subscriptList.add(subscript + _lineCount + 1);
      }
      // 右方 / 右侧第一列不考虑
      if (subscript + 1 < _gridTotalCount && (subscript + 1) % _lineCount != 0) {
        _subscriptList.add(subscript + 1);
      }
    } catch (err) {
      print('ERR$err');
    }
    return _subscriptList;
  }

  /// 单击格子
  _onTapGrid(MSDetailModel clickItem, int subscript) {
    // 判断格子是否处于标记状态，标记状态则取消标记
    // 判读格子是否为雷，为雷则结束游戏
    // 如果格子数量为0，则展示相邻所有0格及数字格
    if (clickItem.isMark) {
      clickItem.isMark = false;
      setState(() {});
      return;
    }
    clickItem.isTap = true;
    if (clickItem.isMine) {
      _gameLose();
    } else if (clickItem.mineNum == 0) {
      _showNearbyGrid(subscript);
    }
    _checkUnTapGrid();
    setState(() {});
  }

  /// 双击格子
  _onDoubleTapGrid(MSDetailModel clickItem, int subscript) {
    // 改变标记状态
    clickItem.isMark ? _delMark(subscript) : _addMark(subscript);
  }

  /// 长按格子
  _onLongTapGrid(MSDetailModel clickItem, int subscript) {
    // 改变标记状态
    clickItem.isMark ? _delMark(subscript) : _addMark(subscript);
  }

  _showNearbyGrid(int subscript) {
    print('subscript$subscript');
    List<int> _nearbySubscriptList = _getNearBySubscriptList(subscript);
    print('_nearbySubscriptList$_nearbySubscriptList');
    _nearbySubscriptList.forEach((element) {
      print('element$element');
      if (_playData[element].mineNum == 0 && !_playData[element].isTap && !_playData[element].isMark) {
        _playData[element].isTap = true;
        _showNearbyGrid(element);
      } else
        _playData[element].isTap = true;
    });
  }

  /// 添加标记
  _addMark(int subscript) {
    if (_markData.length == _mineCount) return;
    if (_markData.contains(subscript)) return;
    _playData[subscript].isMark = true;
    _markData.add(subscript);
    if (_markData.length == _mineCount) _checkGameResult();
    setState(() {});
  }

  /// 取消标记
  _delMark(int subscript) {
    if (!_markData.contains(subscript)) return;
    _playData[subscript].isMark = false;
    _markData.remove(subscript);
    setState(() {});
  }

  /// 检查没点开格子
  _checkUnTapGrid() {
    List<int> _unTapList = [];
    _playData.asMap().keys.forEach((element) {
      if (!_playData[element].isTap) _unTapList.add(element);
    });
    if (_unTapList.length == _mineCount) {
      _unTapList.forEach((element) {
        _addMark(element);
      });
      _checkGameResult();
    }
  }

  /// 判断游戏是否完成
  _checkGameResult() {
    if (_markData.length != _mineData.length) return;
    if (_markData.every((element) => _mineData.contains(element))) {
      _playData.asMap().keys.forEach((element) {
        if (!_playData[element].isMark && !_playData[element].isTap) _playData[element].isTap = true;
      });
      _gameFinish = true;
      _gameOver = false;
      _timer!.cancel();
      setState(() {});
    }
  }

  /// 结束游戏
  _gameLose() {
    _gameFinish = true;
    _gameOver = true;
    _timer!.cancel();
    _playData.asMap().keys.forEach((element) {
      if (_mineData.contains(element) && !_playData[element].isMark) {
        _playData[element].isTap = true;
      }
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WAppBar(
        titleConfig: WAppBarTitleConfig(title: '扫雷'),
        showDefaultBack: true,
      ),
      body: Container(
        child: Column(
          children: [
            Container(
              // padding: EdgeInsets.symmetric(vertical: Dimens.pd8),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(bottom: BorderSide()),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(width: 18, child: Image.asset('assets/images/ms_mine.png')),
                          Dimens.wGap6,
                          Text(
                            (_mineCount - _markData.length).toString(),
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: Dimens.font_size_18,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: TextButton(
                        child: Text(
                          _gameFinish
                              ? _gameOver
                                  ? 'T_T'
                                  : '^_^'
                              : '^_^',
                          style: TextStyle(color: Colors.black),
                        ),
                        onPressed: () {
                          _initData();
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _time.toString(),
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: Dimens.font_size_18,
                            ),
                          ),
                          Dimens.wGap6,
                          Icon(
                            FontAwesomeIcons.clock,
                            size: 18,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Container(
                  width: _lineCount * _gridWidth,
                  alignment: Alignment.center,
                  child: GridView.builder(
                      itemCount: _playData.length,
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: _lineCount,
                      ),
                      itemBuilder: (_, index) => _buildItemWidget(_playData[index], index)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemWidget(MSDetailModel item, int index) {
    return Container(
      width: _gridWidth,
      height: _gridWidth,
      decoration: BoxDecoration(border: Border.all(color: Constants.black_3), color: Colors.white),
      child: InkWell(
        child: Center(
          child: Builder(builder: (_) {
            if (item.isTap && item.isMine)
              return _buildMineStatusWidget();
            else if (item.isTap && !item.isMine)
              return _buildTrueStatusWidget(item.mineNum);
            else if (item.isMark)
              return _buildMarkStatusWidget();
            else
              return _buildBaseStatusWidget(SizedBox());
          }),
        ),
        onTap: _gameFinish || item.isTap
            ? null
            : () {
                _onTapGrid(item, index);
              },
        onDoubleTap: _gameFinish || item.isTap
            ? null
            : () {
                _onDoubleTapGrid(item, index);
              },
        onLongPress: _gameFinish || item.isTap
            ? null
            : () {
                _onLongTapGrid(item, index);
              },
      ),
    );
  }

  /// 默认基础状态
  Widget _buildBaseStatusWidget(Widget child) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: Constants.gray_c,
        border: Border(
          top: BorderSide(color: Colors.white, width: 3),
          left: BorderSide(color: Colors.white, width: 3),
          right: BorderSide(color: Constants.gray_9, width: 3),
          bottom: BorderSide(color: Constants.gray_9, width: 3),
        ),
      ),
      child: child,
    );
  }

  /// 标记状态
  Widget _buildMarkStatusWidget() {
    return _buildBaseStatusWidget(Image.asset('assets/images/ms_flag.png'));
  }

  /// 点开雷状态
  Widget _buildMineStatusWidget() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.red.shade600,
      child: Image.asset('assets/images/ms_mine.png'),
    );
  }

  /// 点开数字状态
  Widget _buildTrueStatusWidget(int mineNum) {
    return mineNum == 0
        ? emptyWidget
        : Text(
            mineNum.toString(),
            style: TextStyle(
              color: _numColorList[mineNum - 1],
              fontSize: Dimens.font_size_24,
              fontWeight: FontWeight.w900,
            ),
          );
  }
}
