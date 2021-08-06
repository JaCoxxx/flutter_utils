import 'dart:convert';

import 'package:flutter_utils/common/model/sudoku_detail_model.dart';
import 'package:flutter_utils/common/strings.dart';
import 'package:flutter_utils/utils/cache_utils.dart';

/// jacokwu
/// 8/4/21 7:37 PM

class SudokuConfig {
  /// 难度级别列表
  /// easy(简单)、normal(普通)、hard(困难)、veryhard(非常困难)
  static List<Map<String, dynamic>> difficultyList = [
    {
      'value': '简单',
      'key': 'easy',
    },
    {
      'value': '普通',
      'key': 'normal',
    },
    {
      'value': '困难',
      'key': 'hard',
    },
    {
      'value': '非常困难',
      'key': 'veryhard',
    },
  ];

  /// 自定义键盘内容
  static List<Map<String, dynamic>> keyboardList = [
    {
      'value': '1',
      'key': '1',
    },
    {
      'value': '2',
      'key': '2',
    },
    {
      'value': '3',
      'key': '3',
    },
    {
      'value': '4',
      'key': '4',
    },
    {
      'value': '5',
      'key': '5',
    },
    {
      'value': '6',
      'key': '6',
    },
    {
      'value': '7',
      'key': '7',
    },
    {
      'value': '8',
      'key': '8',
    },
    {
      'value': '9',
      'key': '9',
    },
    {
      'value': '清除',
      'key': 'del',
    },
    {
      'value': '标记',
      'key': 'mark',
    },
  ];

  /// 设置难度
  static setDiff(String value) {
    CacheUtils.setString(Strings.SUDOKU_DIFF, value);
  }

  /// 获取难度
  static Future<String?> getDiff() async {
    return await CacheUtils.getString(Strings.SUDOKU_DIFF);
  }

  /// 保存游戏
  static Future<void> saveGame(List value) async {
    String saveValue = jsonEncode(value);
    await CacheUtils.remove(Strings.SUDOKU_SAVE_GAME);
    await CacheUtils.setString(Strings.SUDOKU_SAVE_GAME, saveValue);
  }

  /// 读取游戏
  static Future<List<List<SudokuDetailModel>>?> getCacheGame() async {
    List<List<SudokuDetailModel>>? cacheList;
    String? cacheValue = await CacheUtils.getString(Strings.SUDOKU_SAVE_GAME);
    if (cacheValue != null) cacheList = jsonDecode(cacheValue).map<List<SudokuDetailModel>>((e) {
      List<SudokuDetailModel> modelList = e
          .map<SudokuDetailModel>((ele) => SudokuDetailModel.fromJson(ele))
          .toList();
      return modelList;
    }).toList();
    return cacheList;
  }

  /// 清除游戏进度
  static Future<void> clearGame() async {
    await CacheUtils.remove(Strings.SUDOKU_SAVE_GAME);
  }
}
