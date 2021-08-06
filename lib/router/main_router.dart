import 'package:flutter_utils/pages/audio_play/audio_list_page.dart';
import 'package:flutter_utils/pages/audio_play/audio_play_page.dart';
import 'package:flutter_utils/pages/blog/blog_page.dart';
import 'package:flutter_utils/pages/blog/csdn/csdn_detail_page.dart';
import 'package:flutter_utils/pages/blog/csdn/csdn_list_page.dart';
import 'package:flutter_utils/pages/douban/page/douban_list_page.dart';
import 'package:flutter_utils/pages/home/home_page.dart';
import 'package:flutter_utils/pages/juhe/page/juhe_list_page.dart';
import 'package:flutter_utils/pages/juhe/page/sudoku/sudoku_home_page.dart';
import 'package:flutter_utils/pages/juhe/page/sudoku/sudoku_play_page.dart';
import 'package:flutter_utils/pages/juhe/page/today_history_detail_page.dart';
import 'package:flutter_utils/pages/juhe/page/today_hsitory_page.dart';
import 'package:flutter_utils/pages/juhe/page/today_oil_price_page.dart';
import 'package:flutter_utils/pages/setting/settings_page.dart';
import 'package:flutter_utils/pages/splash/splash_page.dart';
import 'package:flutter_utils/pages/video_play/video_list_page.dart';
import 'package:flutter_utils/pages/video_play/video_play_page.dart';
import 'package:flutter_utils/pages/webview/webview_unzip_page.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';

class MainRouter {
  static List<GetPage<dynamic>> routerConfig = [
    GetPage(name: '/splash', page: () => SplashPage()),
    GetPage(name: '/home', page: () => HomePage()),
    GetPage(name: '/setting', page: () => SettingsPage()),
    GetPage(name: '/video-list', page: () => VideoListPage()),
    GetPage(name: '/video-play', page: () => VideoPlayPage()),
    GetPage(name: '/audio-list', page: () => AudioListPage()),
    GetPage(name: '/audio-play', page: () => AudioPlayPage()),
    GetPage(name: '/unzip', page: () => WebviewUnzipPage()),
    GetPage(name: '/blog', page: () => BlogPage()),
    GetPage(name: '/csdn-list', page: () => CSDNListPage()),
    GetPage(name: '/csdn-detail', page: () => CSDNDetailPage()),
    GetPage(name: '/douban-list', page: () => DoubanListPage()),
    GetPage(name: '/juhe-list', page: () => JuHeListPage()),
    GetPage(name: '/today-history', page: () => TodayHistoryPage()),
    GetPage(name: '/today-history-detail', page: () => ToDayHistoryDetailPage()),
    GetPage(name: '/today-oil-price', page: () => TodayOilPricePage()),
    GetPage(name: '/sudoku-home', page: () => SudokuHomePage()),
    GetPage(name: '/sudoku-play', page: () => SudokuPlayPage()),
  ];
}