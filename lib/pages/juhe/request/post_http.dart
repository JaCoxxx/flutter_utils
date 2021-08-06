import 'package:flutter_utils/pages/douban/request/request_url.dart';
import 'package:flutter_utils/pages/juhe/request/request_url.dart';
import 'package:flutter_utils/utils/request.dart';

/// jacokwu
/// 7/28/21 4:15 PM

class JuHePostHttp {
  static Request _request = Request();
  static String _todayHistoryKey = '88d51d7fd6a7a4081f927f98a2471067';
  static String _todayOilPriceKey = '0466362d8d89b93b7abc936f0ceab541';
  static String _sudokuKey = 'bfa3ce9b7d5eadba4fbc341faf7c7ea3';

  static init() {
    _request = Request();
    _request.init(null, null);
  }

  /// 获取历史上的今天列表
  static Future getTodayHistoryList(String date) async {
    print(Uri.encodeFull(
        '${JuHeRequestUrl.getTodayHistory}?key=$_todayHistoryKey&date=$date'));
    print('${JuHeRequestUrl.getTodayHistory}?key=$_todayHistoryKey&date=$date');
    return _request.get(Uri.encodeFull(
        '${JuHeRequestUrl.getTodayHistory}?key=$_todayHistoryKey&date=$date'));
  }

  /// 获取历史上的今天详细信息
  static Future getTodayHistoryDetail(String id) async {
    return _request.get(Uri.encodeFull(
        '${JuHeRequestUrl.getTodayHistoryDetail}?key=$_todayHistoryKey&e_id=$id'));
  }

  /// 获取今日油价列表
  static Future getTodayOilPrice() async {
    return _request.get(Uri.encodeFull(
        '${JuHeRequestUrl.getTodayOilPrice}?key=$_todayOilPriceKey'));
  }

  /// 获取数独游戏数据
  static Future getSudokuPlayData(String difficulty) async {
    List data = [
      [1, 0, 0, 5, 0, 0, 3, 0, 4],
      [6, 3, 4, 7, 2, 8, 9, 5, 1],
      [2, 5, 9, 1, 4, 3, 0, 8, 6],
      [9, 4, 7, 6, 3, 2, 0, 1, 8],
      [8, 0, 3, 0, 0, 1, 4, 7, 2],
      [5, 1, 2, 4, 8, 7, 6, 3, 0],
      [0, 9, 0, 2, 0, 6, 8, 4, 3],
      [3, 2, 6, 8, 7, 4, 1, 0, 5],
      [0, 8, 0, 3, 0, 5, 0, 6, 7]
    ];
    return _request.get(Uri.encodeFull(
        '${JuHeRequestUrl.getSudokuData}?key=$_sudokuKey&difficulty=$difficulty'));
  }
}
