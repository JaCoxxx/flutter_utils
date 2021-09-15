import 'package:flutter_utils/pages/audio_play/router/audio_router.dart';
import 'package:flutter_utils/pages/blog/blog_page.dart';
import 'package:flutter_utils/pages/blog/csdn/csdn_detail_page.dart';
import 'package:flutter_utils/pages/blog/csdn/csdn_list_page.dart';
import 'package:flutter_utils/pages/douban/page/douban_list_page.dart';
import 'package:flutter_utils/pages/douban/page/ex_page_one.dart';
import 'package:flutter_utils/pages/douban/page/ex_page_two.dart';
import 'package:flutter_utils/pages/file_manger/file_manager_list_page.dart';
import 'package:flutter_utils/pages/games/gams_list_page.dart';
import 'package:flutter_utils/pages/games/mine_sweeping/ms_home_page.dart';
import 'package:flutter_utils/pages/games/mine_sweeping/ms_play_page.dart';
import 'package:flutter_utils/pages/games/yingyongbao/yyb_list_page.dart';
import 'package:flutter_utils/pages/games/yingyongbao/yyb_search_page.dart';
import 'package:flutter_utils/pages/home/home_page.dart';
import 'package:flutter_utils/pages/juhe/page/juhe_list_page.dart';
import 'package:flutter_utils/pages/juhe/page/logistics_query_page.dart';
import 'package:flutter_utils/pages/juhe/page/some_utils_page.dart';
import 'package:flutter_utils/pages/juhe/page/sudoku/sudoku_home_page.dart';
import 'package:flutter_utils/pages/juhe/page/sudoku/sudoku_play_page.dart';
import 'package:flutter_utils/pages/juhe/page/today_history_detail_page.dart';
import 'package:flutter_utils/pages/juhe/page/today_hsitory_page.dart';
import 'package:flutter_utils/pages/juhe/page/today_oil_price_page.dart';
import 'package:flutter_utils/pages/pexels/page/pexels_list_page.dart';
import 'package:flutter_utils/pages/setting/about_us_page.dart';
import 'package:flutter_utils/pages/setting/settings_page.dart';
import 'package:flutter_utils/pages/splash/splash_page.dart';
import 'package:flutter_utils/pages/video_play/video_list_page.dart';
import 'package:flutter_utils/pages/video_play/video_play_page.dart';
import 'package:flutter_utils/pages/webview/load_local_html_page.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';

class MainRouter {
  static List<GetPage<dynamic>> routerConfig = [
    ...AudioRouter.routerConfig,
    GetPage(name: '/splash', page: () => SplashPage()),
    GetPage(name: '/home', page: () => HomePage()),
    GetPage(name: '/setting', page: () => SettingsPage()),
    GetPage(name: '/video-list', page: () => VideoListPage(), transition: Transition.noTransition,),
    GetPage(name: '/video-play', page: () => VideoPlayPage(), transition: Transition.noTransition,),
    GetPage(name: '/webview-test', page: () => LoadLocalHtmlPage(), transition: Transition.noTransition,),
    GetPage(name: '/blog', page: () => BlogPage(), transition: Transition.noTransition,),
    GetPage(name: '/csdn-list', page: () => CSDNListPage(), transition: Transition.noTransition,),
    GetPage(name: '/csdn-detail', page: () => CSDNDetailPage()),
    GetPage(name: '/douban-list', page: () => DoubanListPage(), transition: Transition.noTransition, children: [
      GetPage(name: '/ex1', page: () => ExPageOne()),
      GetPage(name: '/ex2', page: () => ExPageTwo()),
    ]),
    GetPage(name: '/juhe-list', page: () => JuHeListPage(), transition: Transition.noTransition,),
    GetPage(name: '/today-history', page: () => TodayHistoryPage()),
    GetPage(name: '/today-history-detail', page: () => ToDayHistoryDetailPage()),
    GetPage(name: '/today-oil-price', page: () => TodayOilPricePage()),
    GetPage(name: '/sudoku-home', page: () => SudokuHomePage()),
    GetPage(name: '/sudoku-play', page: () => SudokuPlayPage()),
    GetPage(name: '/games-list', page: () => GameListPage(), transition: Transition.noTransition,),
    GetPage(name: '/ms-play', page: () => MSPlayPage()),
    GetPage(name: '/ms-home', page: () => MSHomePage()),
    GetPage(name: '/some-utils', page: () => SomeUtilsPage()),
    GetPage(name: '/about-us', page: () => AboutUsPage()),
    GetPage(name: '/yyb-list', page: () => YYBListPage()),
    GetPage(name: '/yyb-search', page: () => YYBSearchPage()),
    GetPage(name: '/file-manager-list', page: () => FileManagerListPage(), transition: Transition.noTransition,),
    GetPage(name: '/pexels-list', page: () => PexelsListPage(), transition: Transition.noTransition,),
    GetPage(name: '/logistics-query', page: () => LogisticsQueryPage()),
  ];
}